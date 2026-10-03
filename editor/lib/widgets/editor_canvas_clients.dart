import 'dart:math' as math;

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
        editor.sync.updatePresence(pointerPosition: position);
      },
      onExit: (e) {
        editor.sync.updatePresence(pointerPosition: null);
      },
      child: Listener(
        behavior: .translucent,
        onPointerHover: (e) {
          final position = editor.globalToScene(e.position);
          editor.sync.updatePresence(pointerPosition: position);
        },
        onPointerMove: (e) {
          final position = editor.globalToScene(e.position);
          editor.sync.updatePresence(pointerPosition: position);
        },
        child: child,
      ),
    );
  }
}

class EditorCanvasPeersWidget extends HookWidget {
  const new({
    super.key,
    required this.transform,
  });

  final Matrix4 transform;

  Widget? _buildPeerCursor(PeerPresence client) {
    final position = client.pointerPosition;
    if (position == null) return null;

    final color = HSLColor.fromAHSL(1, (client.id.hashCode % 360).toDouble(), 0.7, 0.55).toColor();

    return _PeerCursorWidget(
      color: color,
      position: position.offset,
      scale: 1 / transform.getMaxScaleOnAxis2D(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final peers = useExistingSignal(context.editor.sync.peers).value;
    final cursors = peers.values.map(_buildPeerCursor).nonNulls.toList();

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

class _PeerCursorWidget extends StatefulWidget {
  const new({
    super.key,
    required this.color,
    required this.position,
    required this.scale,
  });

  final Color color;
  final Offset position;
  final double scale;

  @override
  State<_PeerCursorWidget> createState() => _PeerCursorWidgetState();
}

class _PeerCursorWidgetState extends State<_PeerCursorWidget> with SingleTickerProviderStateMixin {
  static const _t = 0.035;

  late final _position = ValueNotifier(widget.position);
  late final _ticker = createTicker(_tick);
  var _last = Duration.zero;

  @override
  void didUpdateWidget(covariant _PeerCursorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.position != oldWidget.position && !_ticker.isActive) {
      _last = .zero;
      _ticker.start();
    }
  }

  void _tick(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;

    final delta = widget.position - _position.value;
    if (delta.distanceSquared < 0.01) {
      _position.value = widget.position;
      _ticker.stop();
      return;
    }

    final t = 1 - math.pow(0.5, dt / _t);
    _position.value += delta * t.toDouble();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.scale * 32;

    return Positioned(
      left: 0,
      top: 0,
      child: IgnorePointer(
        child: ValueListenableBuilder(
          valueListenable: _position,
          builder: (context, position, child) => Transform.translate(offset: position, child: child),
          child: VectorGraphic(
            loader: assets.cursors.toolCursor,
            width: size,
            height: size,
            colorFilter: cursorTint(widget.color),
          ),
        ),
      ),
    );
  }
}
