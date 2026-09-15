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

    final m = controller.value;

    final scale = math.sqrt(m[0] * m[0] + m[1] * m[1]);
    final (level, crossfade) = _level(scale);
    final half = baseSpacing / math.pow(2.0, level) / 2.0;

    final inverse = Matrix4.inverted(m);
    var minX = double.infinity, minY = double.infinity;
    var maxX = double.negativeInfinity, maxY = double.negativeInfinity;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final points = [rect.topLeft, rect.topRight, rect.bottomRight, rect.bottomLeft];
    for (final c in points) {
      final w = MatrixUtils.transformPoint(inverse, c);
      minX = math.min(minX, w.dx);
      minY = math.min(minY, w.dy);
      maxX = math.max(maxX, w.dx);
      maxY = math.max(maxY, w.dy);
    }

    final majorPoints = <Offset>[];
    final minorPoints = <Offset>[];

    for (var i = (minX / half).floor(); i <= (maxX / half).ceil(); i++) {
      for (var j = (minY / half).floor(); j <= (maxY / half).ceil(); j++) {
        final isMajor = i.isEven && j.isEven;
        final x = i * half;
        final y = j * half;
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
      ..strokeWidth = 2.0 / scale
      ..strokeCap = .round;

    final minorPaint = Paint()
      ..color = color.withScaledAlpha(maxOpacity * crossfade)
      ..strokeWidth = 2.0 / scale
      ..strokeCap = .round;

    canvas.save();
    canvas.transform(m.storage);

    if (majorPoints.isNotEmpty) {
      canvas.drawPoints(.points, majorPoints, majorPaint);
    }

    if (minorPoints.isNotEmpty && crossfade > 0.01) {
      canvas.drawPoints(.points, minorPoints, minorPaint);
    }

    canvas.restore();
  }

  (int, double) _level(double scale) {
    var level = 0;
    var s = scale;
    while (s < 1) {
      s *= 2;
      level--;
    }
    while (s >= 2) {
      s /= 2;
      level++;
    }
    return (level, math.log(s) / math.ln2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
