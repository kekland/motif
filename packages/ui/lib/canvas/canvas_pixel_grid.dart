import 'dart:math' as math;
import 'package:ui/ui.dart';

class CanvasPixelGrid extends StatelessWidget {
  const new({super.key, required this.transform});

  final Matrix4 transform;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CanvasPixelGridPainter(
        transform: transform,
        color: context.colors.divider.withScaledAlpha(0.5),
      ),
      size: .infinite,
    );
  }
}

class CanvasPixelGridPainter extends CustomPainter {
  CanvasPixelGridPainter({
    required this.transform,
    required this.color,
    this.showAt = 8.0,
    this.fullAt = 16.0,
  });

  final Matrix4 transform;
  final Color color;
  final double showAt;
  final double fullAt;

  @override
  void paint(Canvas canvas, Size view) {
    final m = transform.storage;
    final scale = math.sqrt(m[0] * m[0] + m[1] * m[1]);
    if (scale < showAt) return;

    final t = ((scale - showAt) / (fullAt - showAt)).clamp(0.0, 1.0);
    final paint = Paint()
      ..color = color.withScaledAlpha(t)
      ..strokeWidth = 1.0 / scale
      ..isAntiAlias = false;

    final inverse = Matrix4.inverted(transform);
    final corners = [
      Offset.zero,
      Offset(view.width, 0),
      Offset(0, view.height),
      Offset(view.width, view.height),
    ].map((c) => MatrixUtils.transformPoint(inverse, c));

    var minX = double.infinity, minY = double.infinity, maxX = -double.infinity, maxY = -double.infinity;
    for (final c in corners) {
      minX = math.min(minX, c.dx);
      maxX = math.max(maxX, c.dx);
      minY = math.min(minY, c.dy);
      maxY = math.max(maxY, c.dy);
    }

    final x0 = minX.floor(), x1 = maxX.ceil();
    final y0 = minY.floor(), y1 = maxY.ceil();

    final points = Float32List(((x1 - x0 + 1) + (y1 - y0 + 1)) * 4);
    var i = 0;
    for (var x = x0; x <= x1; x++) {
      points[i++] = x.toDouble();
      points[i++] = y0.toDouble();
      points[i++] = x.toDouble();
      points[i++] = y1.toDouble();
    }
    for (var y = y0; y <= y1; y++) {
      points[i++] = x0.toDouble();
      points[i++] = y.toDouble();
      points[i++] = x1.toDouble();
      points[i++] = y.toDouble();
    }

    canvas.drawRawPoints(.lines, points, paint);
  }

  @override
  bool shouldRepaint(CanvasPixelGridPainter old) => old.transform != transform;
}
