import 'package:vector_math/vector_math_64.dart';

/// Implementation of the Ramer-Douglas-Peucker algorithm for path decimation/simplification.
List<Vector2> ramerDouglasPeucker(List<Vector2> points, {double epsilon = 2.0}) {
  final length = points.length;
  final epsilonSquared = epsilon * epsilon;
  if (length < 3) return points;

  var maxDistanceSquared = 0.0;
  var index = 0;
  var lastIndex = length - 1;

  var pStart = points.first;
  var pEnd = points.last;

  for (var i = 1; i < lastIndex; i++) {
    final distanceSquared = _perpendicularDistanceSquared(points[i], pStart, pEnd);
    if (distanceSquared > maxDistanceSquared) {
      maxDistanceSquared = distanceSquared;
      index = i;
    }
  }

  if (maxDistanceSquared > epsilonSquared) {
    final left = ramerDouglasPeucker(points.sublist(0, index + 1), epsilon: epsilon);
    final right = ramerDouglasPeucker(points.sublist(index), epsilon: epsilon);
    return [...left.sublist(0, left.length - 1), ...right];
  } else {
    return [pStart, pEnd];
  }
}

double _perpendicularDistanceSquared(Vector2 point, Vector2 lineStart, Vector2 lineEnd) {
  final line = lineEnd - lineStart;
  final lengthSquared = line.length2;
  if (lengthSquared == 0.0) return point.distanceToSquared(lineStart);

  var t = ((point.x - lineStart.x) * line.x + (point.y - lineStart.y) * line.y) / lengthSquared;
  t = t.clamp(0.0, 1.0);

  final proj = lineStart + (line * t);
  return point.distanceToSquared(proj);
}

/// Implementation of the Ramer-Douglas-Peucker algorithm in 1D.
List<(double, double)> ramerDouglasPeucker1D(List<(double, double)> points, {double epsilon = 2.0}) {
  if (points.length < 3) return points;

  var maxError = 0.0;
  var index = 0;

  final start = points.first;
  final end = points.last;
  final range = end.$1 - start.$1;

  for (var i = 1; i < points.length - 1; i++) {
    final pt = points[i];

    late final double expectedY;
    if (range == 0) {
      expectedY = start.$2;
    } else {
      final t = (pt.$1 - start.$1) / range;
      expectedY = start.$2 + t * (end.$2 - start.$2);
    }

    final error = (pt.$2 - expectedY).abs();
    if (error > maxError) {
      maxError = error;
      index = i;
    }
  }

  if (maxError > epsilon) {
    final left = ramerDouglasPeucker1D(points.sublist(0, index + 1), epsilon: epsilon);
    final right = ramerDouglasPeucker1D(points.sublist(index), epsilon: epsilon);
    return [...left.sublist(0, left.length - 1), ...right];
  } else {
    return [start, end];
  }
}
