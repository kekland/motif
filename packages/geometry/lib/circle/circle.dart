import 'package:vector_math/vector_math_64.dart';

class Circle2 {
  Circle2(this.center, this.radius);

  final Vector2 center;
  final double radius;

  bool containsPoint(Vector2 point) {
    final dx = point.x - center.x;
    final dy = point.y - center.y;
    return dx * dx + dy * dy <= radius * radius;
  }

  /// Whether the circle fully contains the given AABB.
  bool containsAabb(Aabb2 aabb) {
    if (!containsPoint(aabb.min)) return false;
    if (!containsPoint(aabb.max)) return false;
    if (!containsPoint(Vector2(aabb.min.x, aabb.max.y))) return false;
    if (!containsPoint(Vector2(aabb.max.x, aabb.min.y))) return false;

    return true;
  }
}
