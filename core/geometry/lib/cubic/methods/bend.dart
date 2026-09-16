part of '../cubic.dart';

Cubic2 _cubicBend(Cubic2 c, double t, Vec2 q) {
  final u = 1 - t;
  final w1 = 3 * u * u * t;
  final w2 = 3 * u * t * t;
  final norm = w1 * w1 + w2 * w2;
  if (norm < 1e-12) return c.copy();

  final d = (q - c.point(t)) / norm;
  return .new(c.p0, c.p3, p1: c.p1 + d * w1, p2: c.p2 + d * w2);
}
