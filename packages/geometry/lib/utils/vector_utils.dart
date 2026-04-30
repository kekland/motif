import 'dart:math' as math;

import 'package:vector_math/vector_math_64.dart';

double perpendicularDistance(Vector2 p, Vector2 a, Vector2 b) {
  final d = b - a;
  final len = d.length;
  if (len < 1e-9) return p.distanceTo(a);
  return ((p.x - a.x) * (-d.y) + (p.y - a.y) * d.x).abs() / len;
}

extension DistanceToAabb2 on Aabb2 {
  double distanceTo(Vector2 p) {
    final dx = math.max(0.0, math.max(min.x - p.x, p.x - max.x));
    final dy = math.max(0.0, math.max(min.y - p.y, p.y - max.y));
    return math.sqrt(dx * dx + dy * dy);
  }
}
