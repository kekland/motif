part of '../cubic.dart';

int _cubicWinding(Cubic2 c, Vec2 p) {
  final y0 = c.p0.y;
  final y1 = c.p1.y;
  final y2 = c.p2.y;
  final y3 = c.p3.y;

  final roots = _bernsteinCubicRoots(y0 - p.y, y1 - p.y, y2 - p.y, y3 - p.y);

  var winding = 0;
  for (final t in roots) {
    if (t >= 1.0) continue;
    final x = _bernsteinEvaluate1d(c.p0.x, c.p1.x, c.p2.x, c.p3.x, t);
    if (x <= p.x) continue;

    final dy = _bernsteinVelocityEvaluate1d(y0, y1, y2, y3, t);
    winding += dy.sign.toInt();
  }

  return winding;
}

int _splineWinding(CubicSpline2 s, Vec2 p) {
  var winding = 0;

  for (var k = 0; k < s.segmentCount; k++) {
    final y0 = s.p[k].y;
    final y1 = s.cOut[k].y;
    final y2 = s.cIn[k + 1].y;
    final y3 = s.p[k + 1].y;
    final roots = _bernsteinCubicRoots(y0 - p.y, y1 - p.y, y2 - p.y, y3 - p.y);

    for (final t in roots) {
      if (t >= 1.0) continue;
      final x = _bernsteinEvaluate1d(s.p[k].x, s.cOut[k].x, s.cIn[k + 1].x, s.p[k + 1].x, t);
      if (x <= p.x) continue;

      final dy = _bernsteinVelocityEvaluate1d(y0, y1, y2, y3, t);
      winding += dy.sign.toInt();
    }
  }

  return winding;
}
