part of '../cubic.dart';

Vector2 _cubicEvaluate(Cubic2 cubic, double t) => _bernsteinEvaluate(cubic.p0, cubic.p1, cubic.p2, cubic.p3, t);
Vector2 _cubicVelocity(Cubic2 cubic, double t) => _bernsteinVelocityEvaluate(cubic.p0, cubic.p1, cubic.p2, cubic.p3, t);
Vector2 _cubicTangent(Cubic2 cubic, double t) => _bernsteinTangentEvaluate(cubic.p0, cubic.p1, cubic.p2, cubic.p3, t);

Vector2 _splineEvaluate(CubicSpline2 spline, double t) {
  final (segment, localT) = spline.segmentAt(t);
  return _cubicEvaluate(segment, localT);
}

Vector2 _splineVelocity(CubicSpline2 spline, double t) {
  final (segment, localT) = spline.segmentAt(t);
  return _cubicVelocity(segment, localT);
}

Vector2 _splineTangent(CubicSpline2 spline, double t) {
  final (segment, localT) = spline.segmentAt(t);
  return _cubicTangent(segment, localT);
}
