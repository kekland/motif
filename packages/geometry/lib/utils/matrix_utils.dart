import 'package:vector_math/vector_math_64.dart';

extension Matrix4Utils on Matrix4 {
  Vector2 transform2(Vector2 v) {
    final m = storage;

    final x = v.x;
    final y = v.y;

    final w = m[3] * x + m[7] * y + m[15];
    final nx = (m[0] * x + m[4] * y + m[12]) / w;
    final ny = (m[1] * x + m[5] * y + m[13]) / w;

    return Vector2(nx, ny);
  }
}
