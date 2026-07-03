import 'dart:math' as math;

import 'package:vector_math/vector_math_64.dart';

double perpendicularDistance(Vector2 p, Vector2 a, Vector2 b) {
  final d = b - a;
  final len = d.length;
  if (len < 1e-9) return p.distanceTo(a);
  return ((p.x - a.x) * (-d.y) + (p.y - a.y) * d.x).abs() / len;
}

extension Aabb2Utils on Aabb2 {
  // double signedDistanceTo(Vector2 p) {
  //   final distance = distanceTo(p);
  //   if (containsVector2(p)) return -distance;
  //   return distance;
  // }

  double distanceTo(Vector2 p) {
    final dx = math.max(0.0, math.max(min.x - p.x, p.x - max.x));
    final dy = math.max(0.0, math.max(min.y - p.y, p.y - max.y));
    return math.sqrt(dx * dx + dy * dy);
  }

  bool intersectsWithAabb2Tolerance(Aabb2 other, double tolerance) {
    final a = this, b = other;
    if (a.max.x + tolerance < b.min.x || b.max.x + tolerance < a.min.x) return false;
    if (a.max.y + tolerance < b.min.y || b.max.y + tolerance < a.min.y) return false;
    return true;
  }

  Aabb2 inflate(double amount) {
    final inflated = Aabb2.minMax(min - Vector2.all(amount), max + Vector2.all(amount));
    return inflated;
  }
}

extension GeometryVector2Utils on Vector2 {
  Vector2 pointReflect(Vector2 p) {
    return p * 2 - this;
  }
}
