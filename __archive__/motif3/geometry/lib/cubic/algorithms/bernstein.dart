part of '../cubic.dart';

@pragma('vm:prefer-inline')
double _bernsteinEvaluate1d(double p0, double p1, double p2, double p3, double t) {
  final u = 1 - t, uu = u * u, tt = t * t;
  return p0 * (uu * u) + p1 * (3 * uu * t) + p2 * (3 * u * tt) + p3 * (tt * t);
}

@pragma('vm:prefer-inline')
Vec2 _bernsteinEvaluate(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3, double t) {
  final u = 1 - t, uu = u * u, tt = t * t;
  return p0 * (uu * u) + p1 * (3 * uu * t) + p2 * (3 * u * tt) + p3 * (tt * t);
}

@pragma('vm:prefer-inline')
double _bernsteinVelocityEvaluate1d(double p0, double p1, double p2, double p3, double t) {
  final u = 1 - t;
  return (p1 - p0) * (3 * u * u) + (p2 - p1) * (6 * u * t) + (p3 - p2) * (3 * t * t);
}

@pragma('vm:prefer-inline')
Vec2 _bernsteinVelocityEvaluate(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3, double t) {
  final u = 1 - t;
  return (p1 - p0) * (3 * u * u) + (p2 - p1) * (6 * u * t) + (p3 - p2) * (3 * t * t);
}

@pragma('vm:prefer-inline')
Vec2 _bernsteinTangentEvaluate(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3, double t) {
  final v = _bernsteinVelocityEvaluate(p0, p1, p2, p3, t);
  if (v.length2 > 1e-18) return v.normalized();

  final chord = p3 - p0;
  if (chord.length2 > 1e-18) return chord.normalized();
  return .zero();
}

List<double> _bernsteinCubicRoots(double c0, double c1, double c2, double c3) {
  final out = <double>[];
  _findRoots([Vec2(0, c0), Vec2(1 / 3, c1), Vec2(2 / 3, c2), Vec2(1, c3)], 3, out, 0);
  out.sort();

  final dedup = <double>[];
  for (final t in out) {
    if (dedup.isEmpty || (t - dedup.last).abs() > 1e-9) dedup.add(t);
  }

  return dedup;
}
