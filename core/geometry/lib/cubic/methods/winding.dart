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
