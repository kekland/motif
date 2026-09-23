import 'package:editor/imports.dart';

class EditorCanvasPointerUpdateWidget extends StatelessWidget {
  const new({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;

    return MouseRegion(
      hitTestBehavior: .translucent,
      opaque: false,
      onEnter: (e) {
        final position = editor.globalToScene(e.position);
        editor.onPointerChanged?.call(position);
      },
      onExit: (e) {
        editor.onPointerChanged?.call(null);
      },
      child: Listener(
        behavior: .translucent,
        onPointerHover: (e) {
          final position = editor.globalToScene(e.position);
          editor.onPointerChanged?.call(position);
        },
        child: child,
      ),
    );
  }
}

class EditorCanvasClientsPointersWidget extends HookWidget {
  const new({
    super.key,
    required this.transform,
  });

  final Matrix4 transform;

  Widget? _buildClientCursor(SceneClient client) {
    final position = client.pointerPosition;
    if (position == null) return null;
    
    final color = HSLColor.fromAHSL(1, (client.id.hashCode % 360).toDouble(), 0.7, 0.55).toColor();

    return Positioned(
      left: position.x,
      top: position.y,
      child: Transform.scale(
        scale: 1 / transform.getMaxScaleOnAxis(),
        child: VectorGraphic(
          loader: assets.cursors.toolCursor,
          width: 32.0,
          height: 32.0,
          colorFilter: cursorTint(color),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clients = useListenable(context.editor.clients).clients;
    final cursors = clients.map(_buildClientCursor).nonNulls.toList();

    return Stack(
      clipBehavior: .none,
      children: cursors,
    );
  }
}

// dart format off
ColorFilter cursorTint(Color c) => ColorFilter.matrix([
  1 - c.r, 0, 0, 0, c.r * 255,
  0, 1 - c.g, 0, 0, c.g * 255,
  0, 0, 1 - c.b, 0, c.b * 255,
  0, 0, 0, 1, 0,
]);
// dart format on
