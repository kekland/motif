import 'dart:math' as math;

import 'package:geometry/geometry.dart';

List<double> hermiteTangents(List<RawProfileSample> s) {
  final n = s.length;
  if (n == 0) return const [];
  if (n == 1) return [0.0];

  final secants = List<double>.filled(n - 1, 0.0);
  for (var i = 0; i < n - 1; i++) {
    final s0 = s[i], s1 = s[i + 1];
    final h = s1.x - s0.x;
    secants[i] = (h > 1.0e-6) ? (s1.v - s0.v) / h : 0.0;
  }

  final m = List<double>.filled(n, 0.0);
  m[0] = secants[0];
  m[n - 1] = secants[n - 2];

  for (var i = 1; i < n - 1; i++) {
    final s0 = secants[i - 1], s1 = secants[i];
    if (s0 * s1 <= 0.0) {
      m[i] = 0.0;
    } else {
      m[i] = (s0 + s1) / 2.0;
    }
  }

  for (var i = 0; i < n - 1; i++) {
    final s = secants[i];
    if (s.abs() <= 1.0e-12) {
      m[i] = 0.0;
      m[i + 1] = 0.0;
    } else {
      final a = m[i] / s;
      final b = m[i + 1] / s;
      final sumSq = a * a + b * b;

      if (sumSq > 9.0) {
        final scale = 3.0 / math.sqrt(sumSq);
        m[i] = scale * a * s;
        m[i + 1] = scale * b * s;
      }
    }
  }

  return m;
}

ProfileSample hermiteInterpolate(ProfileSample a, ProfileSample b, double t) {
  final h = b.x - a.x;
  final u = t;
  final u2 = u * u;
  final oneMinusU = 1.0 - u;
  final oneMinusU2 = oneMinusU * oneMinusU;

  final h00 = (1.0 + 2.0 * u) * oneMinusU2;
  final h10 = u * oneMinusU2;
  final h01 = u2 * (3.0 - 2.0 * u);
  final h11 = u2 * (u - 1.0);

  final v = h00 * a.v + h10 * h * a.dv + h01 * b.v + h11 * h * b.dv;

  final dh00 = 6.0 * u * (u - 1.0);
  final dh10 = (1.0 - u) * (1.0 - 3.0 * u);
  final dh01 = -dh00;
  final dh11 = u * (3.0 * u - 2.0);

  final dvDu = dh00 * a.v + dh10 * h * a.dv + dh01 * b.v + dh11 * h * b.dv;
  final dvDx = dvDu / h;

  return (
    x: a.x + h * u,
    v: v,
    dv: dvDx,
  );
}
