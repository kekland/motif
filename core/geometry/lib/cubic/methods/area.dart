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
