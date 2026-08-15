part of '../cubic.dart';

Cubic2 _cubicTransformed(Cubic2 c, Mat4 m) {
  return .new(
    m.transform2(c.p0),
    m.transform2(c.p3),
    p1: m.transform2(c.p1),
    p2: m.transform2(c.p2),
  );
}
