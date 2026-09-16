import 'package:geometry/geometry.dart';

extension type const LineSegment2._(Vec2List storage) implements Object {
  LineSegment2.zero() : storage = .new(2);

  LineSegment2(Vec2 a, Vec2 b) : storage = .new(2) {
    storage[0] = a;
    storage[1] = b;
  }

  LineSegment2.view(Vec2List storage) : storage = storage;

  Vec2 get a => storage[0];
  Vec2 get b => storage[1];

  set a(Vec2 value) => storage[0] = value;
  set b(Vec2 value) => storage[1] = value;

  Intersection? intersect(LineSegment2 other, {double tolerance = 1e-9}) {
    return lineSegmentIntersect(a, b, other.a, other.b, tolerance: tolerance);
  }
}

Intersection? lineSegmentIntersect(Vec2 a, Vec2 b, Vec2 c, Vec2 d, {double tolerance = 1e-9}) {
  final r = b - a;
  final s = d - c;
  final denom = r.cross(s);
  if (denom.abs() < 1e-18) return null;

  final qp = c - a;
  final u = qp.cross(s) / denom;
  final v = qp.cross(r) / denom;

  if (u < -tolerance || u > 1 + tolerance || v < -tolerance || v > 1 + tolerance) return null;
  return .new(u.clamp(0.0, 1.0), v.clamp(0.0, 1.0), a + r * u);
}
