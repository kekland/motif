part of '../cubic.dart';

/// Implementation of Schneider's smoothing algorithm to turn a polyline into a bezier spline.
CubicSpline2 schneider(List<Vector2> points, {double errorThreshold = 4.0}) {
  return .cubics(schneiderRaw(points, errorThreshold: errorThreshold));
}

/// Implementation of Schneider's smoothing algorithm to turn a polyline into a bezier spline.
///
/// Returns a list of cubics instead of baking them into a spline.
List<Cubic2> schneiderRaw(
  List<Vector2> points, {
  Vector2? startTangent,
  Vector2? endTangent,
  double errorThreshold = 4.0,
}) {
  if (points.length < 2) return [];

  final st = startTangent ?? (points[1] - points[0]);
  final et = endTangent ?? (points[points.length - 2] - points.last);

  return _fitCubic(points, st, et, errorThreshold: errorThreshold);
}

List<Cubic2> _fitCubic(
  List<Vector2> points,
  Vector2 startTangent,
  Vector2 endTangent, {
  double errorThreshold = 4.0,
}) {
  final st = startTangent.normalized();
  final et = endTangent.normalized();

  if (points.length == 2) {
    final dist = points[0].distanceTo(points[1]) / 3.0;
    return [.new(points[0], points[1], p1: points[0] + st * dist, p2: points[1] + et * dist)];
  }

  var u = _chordLengthParameterize(points);
  var curve = _generateBezierSegment(points, u, st, et);

  var (maxError, splitIndex) = _computeMaxError(points, u, curve);
  if (maxError < errorThreshold) return [curve];

  final maxIterations = 4;

  for (var i = 0; i < maxIterations; i++) {
    u = _reparameterize(points, u, curve);
    curve = _generateBezierSegment(points, u, st, et);
    final errorData = _computeMaxError(points, u, curve);
    maxError = errorData.$1;
    splitIndex = errorData.$2;

    if (maxError < errorThreshold) return [curve];
  }

  final centerTangent = _computeCenterTangent(points, splitIndex);

  final left = _fitCubic(points.sublist(0, splitIndex + 1), st, centerTangent, errorThreshold: errorThreshold);
  final right = _fitCubic(points.sublist(splitIndex), -centerTangent, et, errorThreshold: errorThreshold);
  return [...left, ...right];
}

List<double> _chordLengthParameterize(List<Vector2> points) {
  final u = List<double>.filled(points.length, 0.0, growable: false);
  for (var i = 1; i < points.length; i++) {
    u[i] = u[i - 1] + points[i].distanceTo(points[i - 1]);
  }

  final last = u.last;
  for (var i = 1; i < points.length; i++) u[i] /= last;

  return u;
}

List<double> _reparameterize(List<Vector2> points, List<double> uList, Cubic2 bezier) {
  final newU = List<double>.filled(points.length, 0.0, growable: false);

  for (var i = 0; i < points.length; i++) {
    final p = points[i];
    var u = uList[i];

    final b0 = math.pow(1 - u, 3).toDouble();
    final b1 = 3 * u * math.pow(1 - u, 2).toDouble();
    final b2 = 3 * math.pow(u, 2) * (1 - u).toDouble();
    final b3 = math.pow(u, 3).toDouble();
    final q = (bezier.p0 * b0) + (bezier.p1 * b1) + (bezier.p2 * b2) + (bezier.p3 * b3);

    final q1 = (bezier.p1 - bezier.p0) * 3.0;
    final q2 = (bezier.p2 - bezier.p1) * 3.0;
    final q3 = (bezier.p3 - bezier.p2) * 3.0;
    final bPrime0 = math.pow(1 - u, 2).toDouble();
    final bPrime1 = 2.0 * u * (1 - u);
    final bPrime2 = math.pow(u, 2).toDouble();
    final qPrime = (q1 * bPrime0) + (q2 * bPrime1) + (q3 * bPrime2);

    final qPrime1 = (q2 - q1) * 2.0;
    final qPrime2 = (q3 - q2) * 2.0;
    final qPrimePrime = (qPrime1 * (1 - u)) + (qPrime2 * u);

    final diff = q - p;
    final numerator = diff.dot(qPrime);
    final denominator = qPrime.dot(qPrime) + diff.dot(qPrimePrime);
    if (denominator == 0.0) {
      newU[i] = u;
    } else {
      newU[i] = (u - (numerator / denominator)).clamp(0.0, 1.0);
    }
  }

  return newU;
}

Cubic2 _generateBezierSegment(
  List<Vector2> points,
  List<double> uList,
  Vector2 startTangent,
  Vector2 endTangent,
) {
  final a = points.first;
  final b = points.last;

  var c00 = 0.0, c01 = 0.0, c10 = 0.0, c11 = 0.0;
  var x0 = 0.0, x1 = 0.0;

  for (var i = 0; i < points.length; i++) {
    final u = uList[i];
    final b0 = math.pow(1 - u, 3);
    final b1 = 3 * u * math.pow(1 - u, 2);
    final b2 = 3 * math.pow(u, 2) * (1 - u);
    final b3 = math.pow(u, 3);

    final a1 = startTangent * b1;
    final a2 = endTangent * b2;

    c00 += a1.dot(a1);
    c01 += a1.dot(a2);
    c10 += a1.dot(a2);
    c11 += a2.dot(a2);

    final diff = points[i] - (a * (b0 + b1) + b * (b2 + b3));
    x0 += a1.dot(diff);
    x1 += a2.dot(diff);
  }

  final det = c00 * c11 - c01 * c10;
  late double alpha1, alpha2;

  if (det == 0.0) {
    alpha1 = alpha2 = a.distanceTo(b) / 3.0;
  } else {
    alpha1 = (x0 * c11 - x1 * c01) / det;
    alpha2 = (x1 * c00 - x0 * c10) / det;
  }

  final length = a.distanceTo(b);
  final epsilon = 1e-6;
  final alphaCap = length * 2.0;
  if (alpha1 < epsilon || alpha2 < epsilon || alpha1 > alphaCap || alpha2 > alphaCap) {
    alpha1 = alpha2 = length / 3.0;
  }

  return .new(a, b, p1: a + (startTangent * alpha1), p2: b + (endTangent * alpha2));
}

(double, int) _computeMaxError(List<Vector2> points, List<double> uList, Cubic2 bezier) {
  var maxDist = 0.0;
  int splitPoint = points.length ~/ 2;

  for (var i = 1; i < points.length - 1; i++) {
    final u = uList[i];
    final b0 = math.pow(1 - u, 3).toDouble();
    final b1 = 3 * u * math.pow(1 - u, 2).toDouble();
    final b2 = 3 * math.pow(u, 2) * (1 - u).toDouble();
    final b3 = math.pow(u, 3).toDouble();

    final point = (bezier.p0 * b0) + (bezier.p1 * b1) + (bezier.p2 * b2) + (bezier.p3 * b3);
    final dist = points[i].distanceTo(point);

    if (dist > maxDist) {
      maxDist = dist;
      splitPoint = i;
    }
  }

  return (maxDist, splitPoint);
}

Vector2 _computeCenterTangent(List<Vector2> points, int centerIndex) {
  final v1 = (points[centerIndex - 1] - points[centerIndex]).normalized();
  final v2 = (points[centerIndex] - points[centerIndex + 1]).normalized();
  final t = (v1 + v2) / 2.0;
  if (t.length2 < 1e-6) return v1;

  return t..normalize();
}
