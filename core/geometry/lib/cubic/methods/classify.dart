part of '../cubic.dart';

enum CubicType {
  point,
  line,
  quadratic,
  serpentine,
  cusp,
  loop,
}

final class CubicClassification {
  new(this.type, this.d1, this.d2, this.d3, {this.loopPoint});

  final CubicType type;
  final double d1, d2, d3;

  final (double, double)? loopPoint;
}

@pragma('vm:prefer-inline')
double _det(Vec2 p, Vec2 q, Vec2 r) => (q - p).cross(r - p);

CubicClassification _cubicClassify(Cubic2 c) {
  final a1 = _det(c.p0, c.p3, c.p2);
  final a2 = _det(c.p1, c.p0, c.p3);
  final a3 = _det(c.p2, c.p1, c.p0);

  final d1 = a1 - 2 * a2 + 3 * a3;
  final d2 = -a2 + 3 * a3;
  final d3 = 3 * a3;

  final scale = math.max(math.max(d1.abs(), d2.abs()), d3.abs());
  final eps = 1e-9 * scale;
  bool isZero(double v) => v.abs() <= eps;

  if (scale == 0.0) {
    const eps = 1e-12;
    final isPoint = c.p0.equals(c.p3, eps) && c.p1.equals(c.p0, eps) && c.p2.equals(c.p0, eps);
    return .new(isPoint ? .point : .line, d1, d2, d3);
  }

  if (isZero(d1)) {
    final isQuadratic = isZero(d2);
    return .new(isQuadratic ? .quadratic : .cusp, d1, d2, d3);
  }

  final disc = 3 * d2 * d2 - 4 * d1 * d3;
  if (isZero(disc / scale)) return .new(.cusp, d1, d2, d3);
  if (disc > 0) return .new(.serpentine, d1, d2, d3);

  final root = math.sqrt(-disc);
  final t1 = (d2 - root) / (2 * d1);
  final t2 = (d2 + root) / (2 * d1);
  final tmin = math.min(t1, t2);
  final tmax = math.max(t1, t2);

  return .new(.loop, d1, d2, d3, loopPoint: (tmin, tmax));
}
