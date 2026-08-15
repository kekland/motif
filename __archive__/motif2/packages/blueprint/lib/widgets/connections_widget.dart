part of 'widgets.dart';

class ConnectionsWidget extends SingleChildRenderObjectWidget {
  const ConnectionsWidget({
    super.key,
    super.child,
    required this.controller,
  });

  final BlueprintController controller;

  @override
  RenderConnections createRenderObject(BuildContext context) {
    return RenderConnections(
      controller: controller,
      connectionsColor: context.colors.display.tertiary,
      buildContext: context,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderConnections renderObject) {
    renderObject.controller = controller;
    renderObject.connectionsColor = context.colors.display.tertiary;
    renderObject.buildContext = context;
  }
}

class RenderConnections extends RenderProxyBox with OverflowHitTestable {
  RenderConnections({
    required this._controller,
    required this._connectionsColor,
    required this._buildContext,
  }) {
    controller.addListener(_onContainerChanged);
    transientConnections.addListener(_onTransientConnectionsChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onContainerChanged);
    transientConnections.removeListener(_onTransientConnectionsChanged);
    super.dispose();
  }

  BlueprintController _controller;
  BlueprintController get controller => _controller;
  set controller(BlueprintController value) {
    if (_controller == value) return;
    controller.removeListener(_onContainerChanged);
    transientConnections.removeListener(_onTransientConnectionsChanged);

    _controller = value;
    controller.addListener(_onContainerChanged);
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

  BuildContext _buildContext;
  BuildContext get buildContext => _buildContext;
  set buildContext(BuildContext value) {
    if (_buildContext == value) return;
    _buildContext = value;
    markNeedsPaint();
  }

  TransientConnections get transientConnections => _controller.transientConnections;

  final _sockets = <Socket, RenderSocket>{};
  void attachSocket(RenderSocket socket) => _sockets[socket.socket] = socket;
  void detachSocket(RenderSocket socket) => _sockets.remove(socket.socket);
  Offset getSocketPosition(Socket socket) {
    final renderSocket = _sockets[socket]!;
    final socketRect = MatrixUtils.transformRect(
      renderSocket.getTransformTo(this),
      Offset.zero & renderSocket.size,
    );

    return socketRect.center;
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

  void _drawConnection(
    Canvas canvas,
    Offset start,
    Offset end,
    Color color, {
    double startDx = -1.0,
    double endDx = 1.0,
  }) {
    final cp1 = Offset(start.dx + startDx * 50.0, start.dy);
    final cp2 = Offset(end.dx + endDx * 50.0, end.dy);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, end.dx, end.dy);

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
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    final transientConnections = this.transientConnections.connections.toList();
    for (final connection in transientConnections) {
      var start = getSocketPosition(connection.source);
      var end = connection.position;

      if (connection.source is OutputSocket) {
        (start, end) = (end, start);
      }

      final color = connection.source.resolveColor(buildContext) ?? connectionsColor;
      _drawConnection(canvas, start, end, color);
    }

    for (final connection in controller.connections) {
      final start = getSocketPosition(connection.input);
      final end = getSocketPosition(connection.output);

      final color = connection.input.resolveColor(buildContext) ?? connectionsColor;
      _drawConnection(canvas, start, end, color);
    }

    canvas.restore();
    super.paint(context, offset);
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
        result.add(SocketHitTestEntry(socket, localPosition, socket: socket.socket));
      }
    }

    return result;
  }
}

class SocketHitTestEntry extends BoxHitTestEntry {
  SocketHitTestEntry(super.target, super.localPosition, {required this.socket});

  final Socket socket;
}
