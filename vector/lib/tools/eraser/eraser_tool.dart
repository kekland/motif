import 'package:flutter/gestures.dart';
import 'package:vector/imports.dart';
import 'package:vector/tools/eraser/eraser_activity.dart';

class EraserTool extends Tool {
  const EraserTool();

  @override
  String get key => 'eraser';

  @override
  Widget buildIcon(BuildContext context) => Icons.eraser();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _EraserToolOverlay(info: info);
}

class _EraserToolOverlay extends HookWidget {
  const _EraserToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);
    final eraserPosition = useState<(Offset, double)?>(null);

    final activityRecognizer = useDragActivityRecognizer(
      () => EraserActivity(
        controller: controller,
        onPositionUpdate: (p, r) => eraserPosition.value = (p, r),
      ),
      onEnd: () => eraserPosition.value = null,
    );

    return Listener(
      behavior: .translucent,
      onPointerDown: (e) {
        activityRecognizer.addPointer(e);
      },
      child: IgnorePointer(
        child: CustomPaint(
          painter: _EraserPainter(
            position: eraserPosition.value,
            transform: info.childPaintTransform,
          ),
        ),
      ),
    );
  }
}

class _EraserPainter extends CustomPainter {
  _EraserPainter({
    super.repaint,
    required this.position,
    required this.transform,
  });

  final (Offset, double)? position;
  final Matrix4 transform;

  @override
  void paint(Canvas canvas, Size size) {
    if (position == null) return;

    final path = Path()..addOval(Rect.fromCircle(center: position!.$1, radius: position!.$2));
    final transformedPath = path.transform(transform.storage);

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..style = .stroke
      ..strokeCap = .round;

    canvas.drawDashedPath(transformedPath, paint: paint, dashLength: 1.0, gapLength: 4.0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
