part of 'widgets.dart';

class BaseSocketWidget extends StatelessWidget {
  const BaseSocketWidget({
    super.key,
    required this.socket,
    this.dx = 0.0,
  });

  final Socket socket;
  final double dx;

  @override
  Widget build(BuildContext context) {
    final size = socket.isDynamic ? 10.0 : 8.0;
    final shape = socket.isDynamic ? BeveledRectangleBorder(borderRadius: .circular(16.0)) : StadiumBorder();

    final height = socket.isList ? 16.0 : size;

    Widget child = Container(
      width: size,
      height: height,
      decoration: ShapeDecoration(
        shape: shape.copyWithBorderSide(
          .new(
            width: 1.0,
            color: context.colors.surface.tertiary,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        color: socket.resolveColor(context) ?? context.colors.display.primary,
      ),
    );

    child = SizedBox(
      width: 24.0,
      height: 24.0,
      child: MouseRegion(
        hitTestBehavior: .translucent,
        cursor: Cursors.toolCursorControlPoint,
        child: DragActivityDetector(
          behavior: .translucent,
          activityFactory: () => ConnectSocketActivity(
            controller: BlueprintController.of(context),
            socket: socket,
          ),
          child: Center(child: child),
        ),
      ),
    );

    child = SizedOverflowBox(
      size: Size.zero,
      alignment: .center,
      child: DeferPointer(
        child: _SocketWidget(
          socket: socket,
          child: child,
        ),
      ),
    );

    return child;
  }
}

class ConnectSocketActivity extends DragActivity {
  ConnectSocketActivity({
    required this.controller,
    required this.socket,
  });

  final BlueprintController controller;
  final Socket socket;

  late final Socket targetSocket;
  late final TransientConnection connection;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final socket = this.socket;
    if (socket is InputSocket && socket.incoming.isNotEmpty) {
      // Disconnect any existing connection on the input socket
      final output = socket.incoming.first;
      socket.disconnect(output);
      connection = controller.transientConnections.add(output, controller.globalToLocal(details.globalPosition));
      targetSocket = output;
    } else {
      connection = controller.transientConnections.add(socket, controller.globalToLocal(details.globalPosition));
      targetSocket = socket;
    }
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);
    connection.position = controller.globalToLocal(details.globalPosition);
  }

  @override
  void onEnd(DragEndDetails? details) {
    super.onEnd(details);
    controller.transientConnections.remove(connection);

    final endHitTest = controller.hitTestSockets(details?.globalPosition ?? lastUpdateDetails!.globalPosition);
    for (final hit in endHitTest) {
      controller.connect(targetSocket, hit.socket);
      break;
    }
  }
}

class _SocketWidget extends SingleChildRenderObjectWidget {
  const _SocketWidget({super.key, super.child, required this.socket});

  final Socket socket;

  @override
  RenderSocket createRenderObject(BuildContext context) {
    return RenderSocket(socket: socket);
  }

  @override
  void updateRenderObject(BuildContext context, RenderSocket renderObject) {}
}

class RenderSocket extends RenderProxyBox {
  RenderSocket({required this._socket});

  Socket _socket;
  Socket get socket => _socket;
  set socket(Socket value) {
    if (_socket == value) return;
    _socket = value;
    markNeedsLayout();
  }

  RenderConnections? _connections;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _connections = findAncestorRenderObjectOfType<RenderConnections>();
    _connections?.attachSocket(this);
  }

  @override
  void detach() {
    _connections?.detachSocket(this);
    _connections = null;
    super.detach();
  }
}
