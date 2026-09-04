part of '../cubic.dart';

Aabb2 _cubicBbox(Cubic2 cubic) {
  final bbox = Aabb2.point(cubic.p0);
  bbox.hullPoint(cubic.p1);
  bbox.hullPoint(cubic.p2);
  bbox.hullPoint(cubic.p3);
  return bbox;
}
