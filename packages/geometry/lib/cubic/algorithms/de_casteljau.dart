part of '../cubic.dart';

// @pragma('vm:prefer-inline')
// Vector2 _deCasteljauEvaluate(Vector2 p0, Vector2 p1, Vector2 p2, Vector2 p3, double t) {
//   final u = 1 - t;
//   final m01 = p0 * u + p1 * t;
//   final m12 = p1 * u + p2 * t;
//   final m23 = p2 * u + p3 * t;
//   final m012 = m01 * u + m12 * t;
//   final m123 = m12 * u + m23 * t;
//   return m012 * u + m123 * t;
// }

typedef _Cubic = ({Vector2 p0, Vector2 p1, Vector2 p2, Vector2 p3});

@pragma('vm:prefer-inline')
(_Cubic, _Cubic) _deCasteljauSplit(Vector2 p0, Vector2 p1, Vector2 p2, Vector2 p3, double t) {
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
    (p0: m0123.clone(), p1: m123, p2: m23, p3: p3),
  );
}
