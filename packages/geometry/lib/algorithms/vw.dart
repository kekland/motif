import 'package:vector_math/vector_math_64.dart';

/// Implementation of the Visvalingam–Whyatt line simplification algorithm.
List<Vector2> visvalingamWhyatt(List<Vector2> points, {double epsilon = 2.0}) {
  final length = points.length;
  if (length < 3) return List.from(points, growable: false);

  final minArea = epsilon * epsilon * 0.5;

  final prev = List.generate(length, (i) => i - 1, growable: false);
  final next = List.generate(length, (i) => i + 1, growable: false);
  next[length - 1] = -1;

  final area = List.filled(length, double.infinity);
  for (var i = 1; i < length - 1; i++) {
    area[i] = _triangleArea(points[prev[i]], points[i], points[next[i]]);
  }

  while (true) {
    var minIndex = -1;
    var minValue = double.infinity;

    for (var i = next[0]; i != -1 && next[i] != -1; i = next[i]) {
      if (area[i] < minValue) {
        minValue = area[i];
        minIndex = i;
      }
    }

    if (minIndex == -1 || minValue >= minArea) break;

    final pr = prev[minIndex];
    final nx = next[minIndex];
    next[pr] = nx;
    if (nx != -1) prev[nx] = pr;

    if (pr > 0 && prev[pr] != -1 && next[pr] != -1) {
      area[pr] = _triangleArea(points[prev[pr]], points[pr], points[next[pr]]);
    }

    if (nx != -1 && nx < length - 1 && prev[nx] != -1 && next[nx] != -1) {
      area[nx] = _triangleArea(points[prev[nx]], points[nx], points[next[nx]]);
    }
  }

  final result = <Vector2>[];
  for (var i = 0; i != -1; i = next[i]) result.add(points[i]);
  return result;
}

double _triangleArea(Vector2 a, Vector2 b, Vector2 c) {
  return 0.5 * ((b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)).abs();
}
