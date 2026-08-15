part of '../cubic.dart';

@pragma('vm:prefer-inline')
Vector2 _bernsteinEvaluate(Vector2 p0, Vector2 p1, Vector2 p2, Vector2 p3, double t) {
  final u = 1 - t, uu = u * u, tt = t * t;
  return p0 * (uu * u) + p1 * (3 * uu * t) + p2 * (3 * u * tt) + p3 * (tt * t);
}

@pragma('vm:prefer-inline')
Vector2 _bernsteinVelocityEvaluate(Vector2 p0, Vector2 p1, Vector2 p2, Vector2 p3, double t) {
  final u = 1 - t;
  return (p1 - p0) * (3 * u * u) + (p2 - p1) * (6 * u * t) + (p3 - p2) * (3 * t * t);
}

@pragma('vm:prefer-inline')
Vector2 _bernsteinTangentEvaluate(Vector2 p0, Vector2 p1, Vector2 p2, Vector2 p3, double t) {
  final v = _bernsteinVelocityEvaluate(p0, p1, p2, p3, t);
  if (v.length2 > 1e-18) return v.normalized();

  final chord = p3 - p0;
  if (chord.length2 > 1e-18) return chord.normalized();
  return Vector2.zero();
}
