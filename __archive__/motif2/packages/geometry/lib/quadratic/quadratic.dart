import 'package:vector_math/vector_math_64.dart';

class Quadratic2 {
  Quadratic2(this.p0, this.p2, {Vector2? p1}) : p1 = p1 ?? (p0 + p2) / 2.0;

  final Vector2 p0;
  final Vector2 p1;
  final Vector2 p2;

  Aabb2 get bbox {
    final min = p0.clone();
    final max = p0.clone();

    Vector2.min(min, p1, min);
    Vector2.max(max, p1, max);
    Vector2.min(min, p2, min);
    Vector2.max(max, p2, max);

    return Aabb2.minMax(min, max);
  }
}
