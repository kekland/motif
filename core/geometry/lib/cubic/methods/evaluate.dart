part of '../cubic.dart';

@pragma('vm:prefer-inline')
Vec2 _cubicEvaluate(Cubic2 c, double t) => _bernsteinEvaluate(c.p0, c.p1, c.p2, c.p3, t);

@pragma('vm:prefer-inline')
Vec2 _cubicVelocity(Cubic2 c, double t) => _bernsteinVelocityEvaluate(c.p0, c.p1, c.p2, c.p3, t);

@pragma('vm:prefer-inline')
Vec2 _cubicTangent(Cubic2 c, double t) => _bernsteinTangentEvaluate(c.p0, c.p1, c.p2, c.p3, t);
