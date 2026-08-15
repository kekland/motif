import 'package:vector_math/vector_math_64.dart';

class Intersection {
  Intersection(this.point, this.tA, this.tB);

  final Vector2 point;
  final double tA, tB;
}
