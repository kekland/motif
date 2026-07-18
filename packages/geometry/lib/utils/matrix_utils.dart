import 'package:geometry/geometry.dart';

extension Matrix4Utils on Matrix4 {
  Vector2 transform2(Vector2 v) {
    final m = storage;
    final x = v.x;
    final y = v.y;

    final nx = (m[0] * x + m[4] * y + m[12]);
    final ny = (m[1] * x + m[5] * y + m[13]);
    final w = m[3] * x + m[7] * y + m[15];

    if (w == 1.0) return .new(nx, ny);
    return .new(nx / w, ny / w);
  }

  Vector2 unproject2(Vector2 v) {
    final m = storage;
    final x = v.x;
    final y = v.y;

    final wi = m[15];
    if (wi == 0.0) return .zero();

    final ix = m[12] / wi;
    final iy = m[13] / wi;
    final iz = m[14] / wi;

    final wd = m[11] + m[15];
    if (wd == 0.0) return .zero();

    final dxr = (m[8] + m[12]) / wd;
    final dyr = (m[9] + m[13]) / wd;
    final dzr = (m[10] + m[14]) / wd;

    final dx = dxr - ix;
    final dy = dyr - iy;
    final dz = dzr - iz;
    if (dz == 0.0) return .zero();

    final ws = m[3] * x + m[7] * y + m[15];
    if (ws == 0.0) return .zero();

    final sx = (m[0] * x + m[4] * y + m[12]) / ws;
    final sy = (m[1] * x + m[5] * y + m[13]) / ws;
    final sz = (m[2] * x + m[6] * y + m[14]) / ws;

    final t = sz / dz;
    final px = sx - (dx * t);
    final py = sy - (dy * t);
    return .new(px, py);
  }

  Aabb2 transformAabb2(Aabb2 aabb) {
    final a = transform2(aabb.min);
    final b = transform2(aabb.max);
    return a.aabb2(b);
  }

  Vector2 transformDelta2(Vector2 a, Vector2 b) {
    final ta = transform2(a);
    final tb = transform2(b);
    return ta - tb;
  }
}
