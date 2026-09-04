part of '../cubic.dart';

const _glX = [
  -0.9602898564975362,
  -0.7966664774136267,
  -0.525532409916329,
  -0.18343464249564978,
  0.18343464249564978,
  0.525532409916329,
  0.7966664774136267,
  0.9602898564975362,
];

const _glW = [
  0.10122853629037706,
  0.22238103445337443,
  0.3137066458778869,
  0.36268378337836166,
  0.36268378337836166,
  0.3137066458778869,
  0.22238103445337443,
  0.10122853629037706,
];

double _gaussEstimate(Cubic2 c, double a, double b) {
  final half = (b - a) / 2;
  final mid = (a + b) / 2;
  var sum = 0.0;

  for (var i = 0; i < 8; i++) {
    sum += _glW[i] * _cubicVelocity(c, mid + half * _glX[i]).length;
  }

  return half * sum;
}

double _arcLengthIntegrate(Cubic2 c, double a, double b, double estimate, double tolerance, int depth) {
  final m = (a + b) / 2;
  final left = _gaussEstimate(c, a, m);
  final right = _gaussEstimate(c, m, b);

  if (depth == 0 || (left + right - estimate).abs() <= tolerance) return left + right;

  return _arcLengthIntegrate(c, a, m, left, tolerance / 2, depth - 1) +
      _arcLengthIntegrate(c, m, b, right, tolerance / 2, depth - 1);
}

double _cubicArcLength(Cubic2 c, [double t0 = 0.0, double t1 = 1.0]) {
  if (t1 <= t0) return 0.0;

  final tol = 1e-10 * ((c.p1 - c.p0).length + (c.p2 - c.p1).length + (c.p3 - c.p2).length);
  if (tol == 0.0) return 0.0;

  final extrema = _cubicExtrema(c);
  final breaks = [t0];
  for (final e in extrema) {
    if (e > t0 && e < t1) breaks.add(e);
  }
  breaks.add(t1);

  var length = 0.0;
  for (var i = 0; i < breaks.length - 1; i++) {
    final (a, b) = (breaks[i], breaks[i + 1]);
    length += _arcLengthIntegrate(c, a, b, _gaussEstimate(c, a, b), tol, 16);
  }

  return length;
}

double _cubicDistanceAtT(Cubic2 c, double t) => _cubicArcLength(c, 0.0, t);

double _cubicTAtDistance(Cubic2 c, double distance) {
  final totalLength = _cubicArcLength(c);
  if (totalLength <= 0.0 || distance <= 0.0) return 0.0;
  if (distance >= totalLength) return 1.0;

  final eps = 1e-12 * totalLength;

  var lo = 0.0, hi = 1.0;
  var lengthAtLo = 0.0;
  var t = distance / totalLength;

  for (var i = 0; i < 16; i++) {
    final error = lengthAtLo + _cubicArcLength(c, lo, t) - distance;
    if (error.abs() <= eps) return t;

    if (error > 0) {
      hi = t;
    } else {
      lo = t;
      lengthAtLo = error + distance;
    }

    final vel = _cubicVelocity(c, t).length;
    var nextT = vel > eps ? t - (error / vel) : double.nan;
    if (!(nextT > lo && nextT < hi)) {
      nextT = (lo + hi) / 2;
    }

    if ((nextT - t).abs() <= eps) return nextT;
    t = nextT;
  }

  return t;
}
