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
