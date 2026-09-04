part of '../cubic.dart';

void _cubicTransform(Cubic2 c, Mat4 m) {
  c.p0 = m.transform2(c.p0);
  c.p1 = m.transform2(c.p1);
  c.p2 = m.transform2(c.p2);
  c.p3 = m.transform2(c.p3);
}

void _cubicReverse(Cubic2 c) {
  final p0 = c.p0, p1 = c.p1, p2 = c.p2, p3 = c.p3;
  c.p0 = p3;
  c.p1 = p2;
  c.p2 = p1;
  c.p3 = p0;
}
