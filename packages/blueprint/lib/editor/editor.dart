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

class BlueprintEditor<B extends Blueprint<B>> with ChangeNotifier, ChangeNotifierDisposable {
  BlueprintEditor(B value) {
    _value = $signal(value);
  }

  static BlueprintEditor of(BuildContext context) => context.read<BlueprintEditor>();
  static BlueprintEditor watch(BuildContext context) => context.watch<BlueprintEditor>();

  late final Signal<B> _value;
  B get value => _value.value;

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
  Iterable<OutputSocket> incoming(InputSocket s) => value.incoming(s);
  Iterable<InputSocket> outgoing(OutputSocket s) => value.outgoing(s);

  // -------------------------------------------------------------------------------------------------------------------
  // Renderer
  // -------------------------------------------------------------------------------------------------------------------

  late final transientConnections = $customDisposable(TransientConnections(), (d) => d.dispose());
  final renderKey = GlobalKey();
  RenderConnections get render => renderKey.currentContext?.findRenderObject() as RenderConnections;

  Offset globalToLocal(Offset globalPosition) => render.globalToLocal(globalPosition);
  List<SocketHitTestEntry> hitTestSockets(Offset globalPosition) =>
      render.hitTestSockets(globalToLocal(globalPosition));

  // -------------------------------------------------------------------------------------------------------------------
  // Edits
  // -------------------------------------------------------------------------------------------------------------------

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

  void setFixed(NodeId id, bool isFixed) => _commit(
    value.setFixed(id, isFixed),
    changedNodes: [id],
  );

  void connect(SocketRef a, SocketRef b) => _commit(
    value.connect(a, b),
    changedSockets: [a, b],
  );

  void disconnect(SocketRef a, SocketRef b) => _commit(
    value.disconnect(a, b),
    changedSockets: [a, b],
  );

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
}
