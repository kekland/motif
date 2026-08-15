part of '../cubic.dart';

typedef _Cubic = ({Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3});

@pragma('vm:prefer-inline')
(_Cubic, _Cubic) _deCasteljauSplit(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3, double t) {
  if (!(t > 0 && t < 1)) throw ArgumentError.value(t, 't', 'must be in range (0, 1)');

  final u = 1 - t;
  final m01 = p0 * u + p1 * t;
  final m12 = p1 * u + p2 * t;
  final m23 = p2 * u + p3 * t;
  final m012 = m01 * u + m12 * t;
  final m123 = m12 * u + m23 * t;
  final m0123 = m012 * u + m123 * t;

  return (
    (p0: p0, p1: m01, p2: m012, p3: m0123),
    (p0: m0123, p1: m123, p2: m23, p3: p3),
  );
}
