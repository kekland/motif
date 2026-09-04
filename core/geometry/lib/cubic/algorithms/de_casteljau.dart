part of '../cubic.dart';

@pragma('vm:prefer-inline')
void _deCasteljauSplit(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3, double t, Cubic2 a, Cubic2 b) {
  if (!(t > 0 && t < 1)) throw ArgumentError.value(t, 't', 'must be in range (0, 1)');

  final u = 1 - t;
  final m01 = p0 * u + p1 * t;
  final m12 = p1 * u + p2 * t;
  final m23 = p2 * u + p3 * t;
  final m012 = m01 * u + m12 * t;
  final m123 = m12 * u + m23 * t;
  final m0123 = m012 * u + m123 * t;

  a.p0 = p0;
  a.p1 = m01;
  a.p2 = m012;
  a.p3 = m0123;

  b.p0 = m0123;
  b.p1 = m123;
  b.p2 = m23;
  b.p3 = p3;
}
