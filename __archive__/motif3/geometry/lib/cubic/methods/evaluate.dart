part of '../cubic.dart';

Vec2 _cubicEvaluate(Cubic2 c, double t) => _bernsteinEvaluate(c.p0, c.p1, c.p2, c.p3, t);
Vec2 _cubicVelocity(Cubic2 c, double t) => _bernsteinVelocityEvaluate(c.p0, c.p1, c.p2, c.p3, t);
Vec2 _cubicTangent(Cubic2 c, double t) => _bernsteinTangentEvaluate(c.p0, c.p1, c.p2, c.p3, t);

Vec2 _splineEvaluate(CubicSpline2 s, double t) {
  final (i, localT) = _splineSegmentIndexAtParameter(s, t);
  return _bernsteinEvaluate(s.p[i], s.cOut[i], s.cIn[i + 1], s.p[i + 1], localT);
}

Vec2 _splineVelocity(CubicSpline2 s, double t) {
  final (i, localT) = _splineSegmentIndexAtParameter(s, t);
  return _bernsteinVelocityEvaluate(s.p[i], s.cOut[i], s.cIn[i + 1], s.p[i + 1], localT);
}

Vec2 _splineTangent(CubicSpline2 s, double t) {
  final (i, localT) = _splineSegmentIndexAtParameter(s, t);
  return _bernsteinTangentEvaluate(s.p[i], s.cOut[i], s.cIn[i + 1], s.p[i + 1], localT);
}
