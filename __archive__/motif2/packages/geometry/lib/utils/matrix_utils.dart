import 'dart:math' as math;

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
    final p1 = aabb.topLeft;
    final p2 = aabb.topRight;
    final p3 = aabb.bottomRight;
    final p4 = aabb.bottomLeft;

    final t1 = transform2(p1);
    final t2 = transform2(p2);
    final t3 = transform2(p3);
    final t4 = transform2(p4);

    final minX = math.min(math.min(t1.x, t2.x), math.min(t3.x, t4.x));
    final minY = math.min(math.min(t1.y, t2.y), math.min(t3.y, t4.y));
    final maxX = math.max(math.max(t1.x, t2.x), math.max(t3.x, t4.x));
    final maxY = math.max(math.max(t1.y, t2.y), math.max(t3.y, t4.y));

    return .minMax(.new(minX, minY), .new(maxX, maxY));
  }

  Vector2 transformDelta2(Vector2 a, Vector2 b) {
    final ta = transform2(a);
    final tb = transform2(b);
    return ta - tb;
  }

  (double width, double height) transformSize(double width, double height) {
    return (width * scaleX, height * scaleY);
  }

  Matrix4 lerpDecomposed(Matrix4 other, double t) {
    // Source from SDK (Matrix4Tween)
    final beginTranslation = Vector3.zero();
    final endTranslation = Vector3.zero();
    final beginRotation = Quaternion.identity();
    final endRotation = Quaternion.identity();
    final beginScale = Vector3.zero();
    final endScale = Vector3.zero();

    decompose(beginTranslation, beginRotation, beginScale);
    other.decompose(endTranslation, endRotation, endScale);

    final Vector3 lerpTranslation = beginTranslation * (1.0 - t) + endTranslation * t;
    final Quaternion lerpRotation = (beginRotation.scaled(1.0 - t) + endRotation.scaled(t)).normalized();
    final Vector3 lerpScale = beginScale * (1.0 - t) + endScale * t;

    return Matrix4.compose(lerpTranslation, lerpRotation, lerpScale);
  }
}
