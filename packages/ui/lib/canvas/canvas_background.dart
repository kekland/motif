import 'dart:math' as math;

import 'package:ui/ui.dart';

class CanvasBackground extends StatelessWidget {
  const CanvasBackground({
    super.key,
    required this.transformationController,
    required this.dotColor,
    required this.backgroundColor,
    this.baseSpacing = 32.0,
  });

  final TransformationController transformationController;
  final Color dotColor;
  final Color backgroundColor;
  final double baseSpacing;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CanvasBackgroundPainter(
        controller: transformationController,
        color: dotColor,
        backgroundColor: backgroundColor,
        baseSpacing: baseSpacing,
      ),
    );
  }
}

class _CanvasBackgroundPainter extends CustomPainter {
  _CanvasBackgroundPainter({
    required this.controller,
    required this.color,
    required this.backgroundColor,
    required this.baseSpacing,
  }) : super(repaint: controller);

  final TransformationController controller;
  final Color color;
  final Color backgroundColor;
  final double baseSpacing;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final transform = controller.value;

    final scale = transform.getMaxScaleOnAxis();
    final tx = transform.getTranslation().x;
    final ty = transform.getTranslation().y;

    final zoom = math.log(scale) / math.ln2;
    final zoomLevel = zoom.floor();

    final crossfade = zoom - zoomLevel;

    final step = baseSpacing / math.pow(2.0, zoomLevel);
    final halfStep = step / 2.0;

    final startX = -tx / scale;
    final endX = (size.width - tx) / scale;
    final startY = -ty / scale;
    final endY = (size.height - ty) / scale;

    final startIdxX = (startX / halfStep).floor();
    final endIdxX = (endX / halfStep).ceil();
    final startIdxY = (startY / halfStep).floor();
    final endIdxY = (endY / halfStep).ceil();

    final majorPoints = <Offset>[];
    final minorPoints = <Offset>[];

    for (var i = startIdxX; i <= endIdxX; i++) {
      for (var j = startIdxY; j <= endIdxY; j++) {
        final isMajor = i.isEven && j.isEven;
        final x = (i * halfStep) * scale + tx;
        final y = (j * halfStep) * scale + ty;
        final point = Offset(x, y);

        if (isMajor) {
          majorPoints.add(point);
        } else {
          minorPoints.add(point);
        }
      }
    }

    final maxOpacity = 0.6;
    final majorPaint = Paint()
      ..color = color.withScaledAlpha(maxOpacity)
      ..strokeWidth = 2.0
      ..strokeCap = .round;

    final minorPaint = Paint()
      ..color = color.withScaledAlpha(maxOpacity * crossfade)
      ..strokeWidth = 2.0
      ..strokeCap = .round;

    if (majorPoints.isNotEmpty) {
      canvas.drawPoints(.points, majorPoints, majorPaint);
    }

    if (minorPoints.isNotEmpty && crossfade > 0.01) {
      canvas.drawPoints(.points, minorPoints, minorPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
