import 'dart:math' as math;
import 'dart:ui';

extension PaintUtils on Canvas {
  void drawDashedLine(
    Offset from,
    Offset to, {
    required Iterable<double> pattern,
    required Paint paint,
  }) {
    assert(pattern.length.isEven);
    final distance = (to - from).distance;
    final normalizedPattern = pattern.map((width) => width / distance).toList();
    final points = <Offset>[];
    double t = 0;
    int i = 0;

    while (t < 1) {
      points.add(Offset.lerp(from, to, t)!);
      t += normalizedPattern[i++]; // dashWidth
      points.add(Offset.lerp(from, to, t.clamp(0, 1))!);
      t += normalizedPattern[i++]; // dashSpace
      i %= normalizedPattern.length;
    }

    drawPoints(PointMode.lines, points, paint);
  }
}

extension DrawDashedPath on Canvas {
  void drawDashedPath(
    Path path, {
    required Paint paint,
    required double dashLength,
    required double gapLength,
  }) {
    final dashedPath = path.dashed(dashLength: dashLength, gapLength: gapLength);
    drawPath(dashedPath, paint);
  }
}

extension DashedPath on Path {
  Path dashed({
    required double dashLength,
    required double gapLength,
  }) {
    final result = Path();

    for (final metric in computeMetrics()) {
      var distance = 0.0;
      var drawing = true;

      while (distance < metric.length) {
        final step = drawing ? dashLength : gapLength;
        final end = math.min(distance + step, metric.length);
        if (drawing) result.addPath(metric.extractPath(distance, end), Offset.zero);

        distance = end;
        drawing = !drawing;
      }
    }

    return result;
  }
}
