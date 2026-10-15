part of '../editor.dart';

class BaseSocketWidget extends StatelessWidget {
  const BaseSocketWidget({
    super.key,
    required this.socket,
    required this.index,
    this.dx = 0.0,
  });

  final Socket socket;
  final int index;
  final double dx;

  @override
  Widget build(BuildContext context) {
    final (size, borderWidth) = switch (socket.isDynamic) {
      true => (12.0, 0.5),
      false => (8.0, 1.0),
    };

    final shape = socket.isDynamic ? BeveledRectangleBorder(borderRadius: .circular(size / 2.0)) : StadiumBorder();
    final color = context.watch<BlueprintColorResolvers>();

    Widget child = Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
        shape: shape.copyWithBorderSide(
          .new(
            width: borderWidth,
            color: context.colors.surface.tertiary,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        color: color.resolve(socket.category) ?? context.colors.display.primary,
      ),
    );

    child = SizedBox(
      width: 24.0,
      height: 24.0,
      child: MouseRegion(
        hitTestBehavior: .translucent,
        cursor: Cursors.toolCursorControlPoint,
        child: Center(child: child),
      ),
    );

    child = SizedOverflowBox(
      size: Size.zero,
      alignment: .center,
      child: _SocketWidget(
        socket: socket,
        index: index,
        child: child,
      ),
    );

    return child;
  }
}

class ConnectSocketActivity extends DragActivity {
  ConnectSocketActivity({
    required this.editor,
    required this.socket,
    required this.index,
  });

  final BlueprintEditor editor;
  final Socket socket;
  final int index;

  late final SocketRef targetSocket;
  late final TransientConnection connection;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final socket = this.socket;
    if (socket is InputSocket) {
      final connections = editor.socketConnections(socket.ref);
      final existing = connections.firstWhereOrNull((c) => c.index == index);
      if (existing != null) {
        final output = existing.output;
        editor.disconnect(existing.output, socket.ref, index: index);

        connection = editor.transientConnections.add(output, 0, editor.globalToLocal(details.globalPosition));
        targetSocket = output;
        return;
      }
    }

    connection = editor.transientConnections.add(socket.ref, index, editor.globalToLocal(details.globalPosition));
    targetSocket = socket.ref;
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);
    connection.position = editor.globalToLocal(details.globalPosition);
  }

  @override
  void onEnd(DragEndDetails details) {
    super.onEnd(details);
    editor.transientConnections.remove(connection);

    final endHitTest = editor.hitTestSockets(details.globalPosition);
    for (final hit in endHitTest) {
      editor.connect(targetSocket, hit.socket.ref, index: hit.index);
      break;
    }
  }
}

class _SocketWidget extends SingleChildRenderObjectWidget {
  const _SocketWidget({
    super.key,
    super.child,
    required this.socket,
    required this.index,
  });

  final Socket socket;
  final int index;

  @override
  RenderSocket createRenderObject(BuildContext context) {
    return RenderSocket(socket: socket, index: index);
  }

  @override
  void updateRenderObject(BuildContext context, RenderSocket renderObject) {}
}

class RenderSocket extends RenderProxyBox {
  RenderSocket({required this._socket, required this._index});

  SocketRef get ref => socket.ref;

  Socket _socket;
  Socket get socket => _socket;
  set socket(Socket value) {
    if (_socket == value) return;
    _socket = value;
    markNeedsLayout();
  }

  int _index;
  int get index => _index;
  set index(int value) {
    if (_index == value) return;
    _index = value;
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
