part of '../editor.dart';

class ConnectionsWidget extends SingleChildRenderObjectWidget {
  const ConnectionsWidget({
    super.key,
    super.child,
    required this.editor,
  });

  final BlueprintEditor editor;

  @override
  RenderConnections createRenderObject(BuildContext context) {
    return RenderConnections(
      controller: editor,
      connectionsColor: context.colors.display.tertiary,
      primaryColor: context.colors.accent.primary,
      buildContext: context,
      colorResolvers: context.watch<BlueprintColorResolvers>(),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderConnections renderObject) {
    renderObject.editor = editor;
    renderObject.connectionsColor = context.colors.display.tertiary;
    renderObject.primaryColor = context.colors.accent.primary;
    renderObject.buildContext = context;
    renderObject.colorResolvers = context.watch<BlueprintColorResolvers>();
  }
}

class RenderConnections extends RenderProxyBox with OverflowHitTestable {
  RenderConnections({
    required this._controller,
    required this._connectionsColor,
    required this._primaryColor,
    required this._buildContext,
    required this._colorResolvers,
  }) {
    editor.addListener(_onContainerChanged);
    editor.selection.addListener(_onContainerChanged);
    transientConnections.addListener(_onTransientConnectionsChanged);
  }

  @override
  void dispose() {
    editor.removeListener(_onContainerChanged);
    editor.selection.removeListener(_onContainerChanged);
    transientConnections.removeListener(_onTransientConnectionsChanged);
    super.dispose();
  }

  BlueprintEditor _controller;
  BlueprintEditor get editor => _controller;
  set editor(BlueprintEditor value) {
    if (_controller == value) return;
    editor.removeListener(_onContainerChanged);
    transientConnections.removeListener(_onTransientConnectionsChanged);

    _controller = value;
    editor.addListener(_onContainerChanged);
    transientConnections.addListener(_onTransientConnectionsChanged);
    markNeedsLayout();
  }

  Color _connectionsColor;
  Color get connectionsColor => _connectionsColor;
  set connectionsColor(Color value) {
    if (_connectionsColor == value) return;
    _connectionsColor = value;
    markNeedsPaint();
  }

  Color _primaryColor;
  Color get primaryColor => _primaryColor;
  set primaryColor(Color value) {
    if (_primaryColor == value) return;
    _primaryColor = value;
    markNeedsPaint();
  }

  BuildContext _buildContext;
  BuildContext get buildContext => _buildContext;
  set buildContext(BuildContext value) {
    if (_buildContext == value) return;
    _buildContext = value;
    markNeedsPaint();
  }

  BlueprintColorResolvers _colorResolvers;
  BlueprintColorResolvers get colorResolvers => _colorResolvers;
  set colorResolvers(BlueprintColorResolvers value) {
    if (_colorResolvers == value) return;
    _colorResolvers = value;
    markNeedsPaint();
  }

  TransientConnections get transientConnections => _controller.transientConnections;

  final _sockets = <(SocketRef, int?), RenderSocket>{};
  void attachSocket(RenderSocket socket) => _sockets[(socket.ref, socket.index)] = socket;
  void detachSocket(RenderSocket socket) => _sockets.remove((socket.ref, socket.index));
  Offset getSocketPosition(SocketRef socket, int index) {
    final renderSocket = _sockets[(socket, index)]!;
    final socketRect = MatrixUtils.transformRect(
      renderSocket.getTransformTo(this),
      Offset.zero & renderSocket.size,
    );

    return socketRect.center;
  }

  final _nodes = <NodeId, RenderNode>{};
  void attachNode(RenderNode node) => _nodes[node.node.id] = node;
  void detachNode(RenderNode node) => _nodes.remove(node.node.id);
  Rect getNodeRect(NodeId id) {
    final renderNode = _nodes[id]!;
    final nodeRect = MatrixUtils.transformRect(
      renderNode.getTransformTo(this),
      Offset.zero & renderNode.size,
    );

    return nodeRect;
  }

  void _onContainerChanged() => markNeedsPaint();

  var _lastTransientConnections = <TransientConnection>[];
  void _onTransientConnectionsChanged() {
    for (final c in _lastTransientConnections) c.removeListener(_onTransientConnectionChanged);
    for (final c in transientConnections.connections) c.addListener(_onTransientConnectionChanged);
    _lastTransientConnections = transientConnections.connections.toList();
    markNeedsPaint();
  }

  void _onTransientConnectionChanged() => markNeedsPaint();

  Cubic2 _getConnectionCubic(Connection connection) {
    final start = getSocketPosition(connection.input, connection.index).vec2;
    final end = getSocketPosition(connection.output, 0).vec2;
    return _getConnectionCubicRaw(start, end);
  }

  Cubic2 _getConnectionCubicRaw(Vec2 start, Vec2 end) {
    final extDistance = (end.x - start.x).abs() * 0.5;
    final cp1 = Vec2(start.x - extDistance, start.y);
    final cp2 = Vec2(end.x + extDistance, end.y);
    return .new(start, end, p1: cp1, p2: cp2);
  }

  void _drawConnection(Canvas canvas, Cubic2 cubic, Color color, {Color? outlineColor}) {
    final path = Path()
      ..moveTo(cubic.p0.x, cubic.p0.y)
      ..cubicTo(cubic.p1.x, cubic.p1.y, cubic.p2.x, cubic.p2.y, cubic.p3.x, cubic.p3.y);

    if (outlineColor != null) {
      canvas.drawPath(
        path,
        Paint()
          ..color = outlineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0,
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    final transientConnections = this.transientConnections.connections.toList();
    for (final connection in transientConnections) {
      var start = getSocketPosition(connection.source, connection.sourceIndex);
      var end = connection.position;
      final source = _sockets[(connection.source, 0)]!._socket;

      if (source is OutputSocket) {
        (start, end) = (end, start);
      }

      final color = colorResolvers.resolve(source.category) ?? connectionsColor;
      final cubic = _getConnectionCubicRaw(start.vec2, end.vec2);
      _drawConnection(canvas, cubic, color);
    }

    for (final connection in editor.connections) {
      final inputSocket = editor.value.socket(connection.input);
      final isSelected = editor.selection.isConnectionSelected(connection);

      final color = colorResolvers.resolve(inputSocket.category) ?? connectionsColor;
      final cubic = _getConnectionCubic(connection);
      _drawConnection(canvas, cubic, color, outlineColor: isSelected ? primaryColor : null);
    }

    canvas.restore();
    context.paintChild(child!, offset);
  }

  List<ConnectionHitTestEntry> hitTestConnections(Offset position, {double scale = 1.0}) {
    final result = <ConnectionHitTestEntry>[];

    final q = position.vec2;
    for (final connection in editor.connections) {
      final cubic = _getConnectionCubic(connection);

      final r = cubic.closestPoint(q);
      if (r.distance < 16.0 * scale) {
        result.add(ConnectionHitTestEntry(this, position, connection: connection, distance: r.distance));
      }
    }

    result.sort((a, b) => a.distance.compareTo(b.distance));
    return result;
  }

  List<SocketHitTestEntry> hitTestSockets(Offset position) {
    final result = <SocketHitTestEntry>[];

    for (final socket in _sockets.values) {
      final socketRect = MatrixUtils.transformRect(
        socket.getTransformTo(this),
        Offset.zero & socket.size,
      );

      if (socketRect.contains(position)) {
        final localPosition = position - socketRect.topLeft;
        result.add(
          SocketHitTestEntry(
            socket,
            localPosition,
            socket: socket.socket,
            index: socket.index,
          ),
        );
      }
    }

    return result;
  }

  List<NodeHitTestEntry> hitTestNodes(Offset position) {
    final result = BoxHitTestResult();
    hitTest(result, position: position);
    return result.path.whereType<NodeHitTestEntry>().toList();
  }

  List<NodeHitTestEntry> rectHitTestNodes(Aabb2 rect, HitTestRectMode mode) {
    final result = <NodeHitTestEntry>[];

    for (final node in editor.nodes) {
      final nodeRect = getNodeRect(node.id).aabb2;
      var isHit = rect.containsAabb(nodeRect);
      if (mode != .contain) isHit |= rect.intersectsAabb(nodeRect);
      if (isHit) result.add(.new(this, .zero, node: node));
    }

    return result;
  }

  List<ConnectionHitTestEntry> rectHitTestConnections(Aabb2 rect, HitTestRectMode mode) {
    final result = <ConnectionHitTestEntry>[];

    for (final connection in editor.connections) {
      final cubic = _getConnectionCubic(connection);
      var isHit = cubic.containedInAabb(rect);
      if (mode != .contain) isHit |= cubic.intersectsAabb(rect);
      if (isHit) result.add(.new(this, .zero, connection: connection, distance: 0.0));
    }

    return result;
  }
}

class SocketHitTestEntry extends BoxHitTestEntry {
  SocketHitTestEntry(
    super.target,
    super.localPosition, {
    required this.socket,
    required this.index,
  });

  final Socket socket;
  final int index;
}

class NodeHitTestEntry extends BoxHitTestEntry {
  NodeHitTestEntry(super.target, super.localPosition, {required this.node});

  final Node node;
}

class ConnectionHitTestEntry extends BoxHitTestEntry {
  ConnectionHitTestEntry(super.target, super.localPosition, {required this.connection, required this.distance});

  final Connection connection;
  final double distance;
}
