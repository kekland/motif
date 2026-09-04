part of '../cubic.dart';

double _cubicSignedAreaRaw(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3) {
  var result =
      6.0 * p0.cross(p1) +
      3.0 * p0.cross(p2) +
      p0.cross(p3) +
      3.0 * p1.cross(p2) +
      3.0 * p1.cross(p3) +
      6.0 * p2.cross(p3);

  return result / 20.0;
}

double _cubicSignedArea(Cubic2 c) => _cubicSignedAreaRaw(c.p0, c.p1, c.p2, c.p3);

double _splineSignedArea(CubicSpline2 spline) {
  var result = 0.0;
  for (var i = 0; i < spline.segmentCount; i++) {
    final p0 = spline.p[i], p1 = spline.cOut[i], p2 = spline.cIn[i + 1], p3 = spline.p[i + 1];
    result += _cubicSignedAreaRaw(p0, p1, p2, p3);
  }
  return result;
}
