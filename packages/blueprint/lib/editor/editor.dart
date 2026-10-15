import 'dart:math';

import 'package:blueprint/editor/actions/actions.dart';
import 'package:blueprint/editor/widgets/editor_actions.dart';
import 'package:blueprint/editor/widgets/editor_canvas.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:ui/ui.dart';
import 'package:geometry/geometry.dart';
import 'package:blueprint/core.dart';

part 'transient_connection.dart';
part 'widgets/connections_widget.dart';
part 'widgets/editor_widget.dart';
part 'widgets/node_widget.dart';
part 'widgets/socket_widget.dart';

final _logger = Logger('BlueprintEditor');

class BlueprintEditor<B extends Blueprint<B>> with ChangeNotifier, ChangeNotifierDisposable {
  BlueprintEditor(B value) {
    _value = $signal(value);
    history = .new(this);
  }

  static BlueprintEditor of(BuildContext context) => context.read<BlueprintEditor>();
  static BlueprintEditor watch(BuildContext context) => context.watch<BlueprintEditor>();

  late final Signal<B> _value;
  B get value => _value.value;

  late final selection = $disposable(BlueprintEditorSelection(this));
  late final BlueprintEditorHistory<B> history;

  // -------------------------------------------------------------------------------------------------------------------
  // Signals
  // -------------------------------------------------------------------------------------------------------------------

  final _nodeSignals = <NodeId, ObjectSignal<Node>>{};
  final _socketSignals = <SocketRef, ObjectSignal<Socket>>{};

  ReadonlySignal<N> node<N extends Node>(NodeId id) {
    _nodeSignals[id] ??= ObjectSignal<N>(value.node<N>(id));
    return _nodeSignals[id]! as ReadonlySignal<N>;
  }

  ReadonlySignal<S> socket<S extends Socket>(SocketRef ref) {
    _socketSignals[ref] ??= ObjectSignal<S>(value.socket<S>(ref));
    return _socketSignals[ref]! as ReadonlySignal<S>;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Values
  // -------------------------------------------------------------------------------------------------------------------

  Iterable<Node> get nodes => value.nodes;
  Iterable<Connection> get connections => value.connections;
  Vec2 positionOf(NodeId id) => value.positionOf(id);
  bool isFixed(NodeId id) => value.isFixed(id);
  bool isConnected(Socket socket) => value.isConnected(socket);
  Iterable<Connection> connectionsOf(NodeId id) => value.connectionsOf(id);
  Iterable<Connection> socketConnections(SocketRef socket) => value.socketConnections(socket);
  
  Iterable<OutputSocket> incoming(InputSocket s) => value.incoming(s);
  Iterable<InputSocket> outgoing(OutputSocket s) => value.outgoing(s);

  // -------------------------------------------------------------------------------------------------------------------
  // Renderer
  // -------------------------------------------------------------------------------------------------------------------

  final canvasKey = GlobalKey();
  RenderBox get renderCanvas => canvasKey.currentContext!.findRenderObject() as RenderBox;
  late final canvasTransformationController = $customDisposable(TransformationController(), (v) => v.dispose());
  late final canvasFocusScopeNode = FocusScopeNode();

  late final transientConnections = $customDisposable(TransientConnections(), (d) => d.dispose());
  final renderKey = GlobalKey();
  RenderConnections get render => renderKey.currentContext?.findRenderObject() as RenderConnections;

  Offset globalToLocal(Offset globalPosition) => render.globalToLocal(globalPosition);

  List<SocketHitTestEntry> hitTestSockets(Offset globalPosition) {
    return render.hitTestSockets(globalToLocal(globalPosition));
  }

  List<NodeHitTestEntry> hitTestNodes(Offset globalPosition) {
    return render.hitTestNodes(globalToLocal(globalPosition));
  }

  List<ConnectionHitTestEntry> hitTestConnections(Offset globalPosition) {
    final scale = 1.0 / render.getTransformTo(null).getMaxScaleOnAxis2D();
    return render.hitTestConnections(globalToLocal(globalPosition), scale: scale);
  }

  Offset? cursorCanvasPosition;
  void onPointerPositionChanged(Offset? offset) {
    cursorCanvasPosition = offset != null ? globalToLocal(offset) : null;
  }

  bool get canvasHasFocus {
    if (canvasFocusScopeNode.hasPrimaryFocus) return true;

    final primaryFocus = FocusManager.instance.primaryFocus;
    var willGetFocus = false;
    if (primaryFocus == null) {
      willGetFocus = true;
    } else if (primaryFocus.ancestors.isEmpty) {
      willGetFocus = true;
    } else if (primaryFocus == canvasFocusScopeNode.enclosingScope) {
      willGetFocus = true;
    }

    return willGetFocus;
  }

  Vec2 get canvasCenter {
    final size = renderCanvas.size;
    return canvasTransformationController.toScene(size.center(Offset.zero)).vec2;
  }

  Vec2 get canvasPosition {
    return cursorCanvasPosition?.vec2 ?? canvasCenter;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Edits
  // -------------------------------------------------------------------------------------------------------------------

  void edit(VoidCallback fn, {Object? mergeKey}) {
    batch(fn);
    history.commit(value, mergeKey: mergeKey);
  }

  void _commit(
    B next, {
    Iterable<NodeId> changedNodes = const [],
    Iterable<SocketRef> changedSockets = const [],
  }) {
    _value.value = next;
    for (final id in changedNodes) {
      if (next.hasNode(id)) {
        _nodeSignals[id]?.value = next.node(id);
      } else {
        _nodeSignals.remove(id)?.dispose();
      }
    }

    for (final ref in changedSockets) {
      if (next.hasNode(ref.node)) {
        _socketSignals[ref]?.value = next.socket(ref);
      } else {
        _socketSignals.remove(ref)?.dispose();
      }
    }

    notifyListeners();
  }

  void add(Node node, {Vec2? position, bool isFixed = false}) => _commit(
    value.add(node, position: position, isFixed: isFixed),
    changedNodes: [node.id],
  );

  void remove(NodeId id) {
    final node = value.node(id);
    final touched = value.connectionsOf(id).map((c) => c.input.node == id ? c.input : c.output).toList();
    touched.addAll(node.sockets.map((s) => s.ref));

    _commit(
      value.remove(id),
      changedNodes: [id],
      changedSockets: touched,
    );
  }

  void replace(Node node) => _commit(
    value.replace(node),
    changedNodes: [node.id],
    changedSockets: node.sockets.map((s) => s.ref),
  );

  void move(NodeId id, Vec2 position) => _commit(
    value.move(id, position),
    changedNodes: [id],
  );

  void moveMany(Map<NodeId, Vec2> positions) => _commit(
    value.moveMany(positions),
    changedNodes: positions.keys,
  );

  void setFixed(NodeId id, bool isFixed) => _commit(
    value.setFixed(id, isFixed),
    changedNodes: [id],
  );

  void connect(SocketRef a, SocketRef b, {int index = 0}) => _commit(
    value.connect(a, b, index: index),
    changedSockets: [a, b],
  );

  void disconnect(SocketRef a, SocketRef b, {int index = 0}) => _commit(
    value.disconnect(a, b, index: index),
    changedSockets: [a, b],
  );

  void pasteSlice(BlueprintSlice slice) {
    edit(() {
      final materialized = slice.materialize(canvasPosition);
      for (final n in materialized.nodes) add(n, position: materialized.positions[n.id]);
      for (final c in materialized.connections) connect(c.input, c.output);
      selection.selectNodes(materialized.nodes.map((n) => n.id).toSet());
    });
  }

  void load(B value) {
    _commit(
      value,
      changedNodes: value.nodes.map((n) => n.id),
      changedSockets: value.nodes.expand((n) => n.sockets.map((s) => s.ref)),
    );
  }

  @override
  void dispose() {
    for (final signal in _nodeSignals.values) signal.dispose();
    for (final signal in _socketSignals.values) signal.dispose();
    _nodeSignals.clear();
    _socketSignals.clear();
    super.dispose();
  }

  void _set(B value) {
    load(value);
  }

  BlueprintSlice decodeSlice(Uint8List data) => value.decodeSlice(data);
  Uint8List encodeSlice(BlueprintSlice slice) => value.encodeSlice(slice);
}

final class BlueprintEditorSelection with ChangeNotifier, ChangeNotifierDisposable {
  BlueprintEditorSelection(this.editor);
  final BlueprintEditor editor;

  final _selectedNodes = <NodeId>{};
  final _selectedConnections = <Connection>{};

  Set<NodeId> get nodes => _selectedNodes;
  Set<Connection> get connections => _selectedConnections;

  bool isNodeSelected(NodeId id) => _selectedNodes.contains(id);
  bool isConnectionSelected(Connection connection) => _selectedConnections.contains(connection);

  void addNode(NodeId id) {
    _selectedNodes.add(id);
    notifyListeners();
  }

  void selectNode(NodeId id) {
    _clear();
    _selectedNodes.add(id);
    notifyListeners();
  }

  void selectNodes(Set<NodeId> ids) {
    _clear();
    _selectedNodes.addAll(ids);
    notifyListeners();
  }

  void deselectNode(NodeId id) {
    _selectedNodes.remove(id);
    notifyListeners();
  }

  void addConnection(Connection connection) {
    _selectedConnections.add(connection);
    notifyListeners();
  }

  void selectConnection(Connection connection) {
    _clear();
    _selectedConnections.add(connection);
    notifyListeners();
  }

  void deselectConnection(Connection connection) {
    _selectedConnections.remove(connection);
    notifyListeners();
  }

  void selectAll() {
    _selectedNodes.addAll(editor.value.nodes.map((n) => n.id));
    _selectedConnections.addAll(editor.value.connections);
    notifyListeners();
  }

  void _clear() {
    _selectedNodes.clear();
    _selectedConnections.clear();
  }

  void clear() {
    _clear();
    notifyListeners();
  }

  void handleMarquee(MarqueeValue value) {
    final rect = MatrixUtils.inverseTransformRect(
      editor.render.getTransformTo(null),
      value.$1,
    );

    final nodeResult = editor.render.rectHitTestNodes(rect.aabb2, value.$2);
    final connectionResult = editor.render.rectHitTestConnections(rect.aabb2, value.$2);
    _clear();
    _selectedNodes.addAll(nodeResult.map((e) => e.node.id));
    _selectedConnections.addAll(connectionResult.map((e) => e.connection));
    notifyListeners();
  }
}

final class BlueprintEditorHistory<B extends Blueprint<B>> {
  BlueprintEditorHistory(this.editor) {
    _entries.add(editor.value);
  }

  final BlueprintEditor<B> editor;

  final _entries = <B>[];
  var _cursor = 0;
  Object? _mergeKey;

  bool get canUndo => _cursor > 0;
  bool get canRedo => _cursor < _entries.length - 1;

  void commit(B entry, {Object? mergeKey}) {
    if (_cursor < _entries.length - 1) {
      _entries.removeRange(_cursor + 1, _entries.length);
    }

    if (mergeKey != null && mergeKey == _mergeKey) {
      _entries[_cursor] = entry;
      return;
    }

    _mergeKey = mergeKey;
    _entries.add(entry);
    _cursor++;
  }

  void undo() {
    if (!canUndo) return;
    _mergeKey = null;
    _cursor--;
    final entry = _entries[_cursor];
    editor._set(entry);
  }

  void redo() {
    if (!canRedo) return;
    _mergeKey = null;
    _cursor++;
    final entry = _entries[_cursor];
    editor._set(entry);
  }

  void clear() {
    _mergeKey = null;
    _entries.clear();
    _entries.add(editor.value);
    _cursor = 0;
  }
}
