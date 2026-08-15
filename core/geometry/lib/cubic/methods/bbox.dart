part of '../cubic.dart';

Aabb2 _knotBbox(CubicKnot2 knot) {
  final bbox = Aabb2.point(knot.p);
  bbox.hullPoint(knot.cIn);
  bbox.hullPoint(knot.cOut);
  return bbox;
}

Aabb2 _cubicBbox(Cubic2 cubic) {
  final bbox = Aabb2.point(cubic.p0);
  bbox.hullPoint(cubic.p1);
  bbox.hullPoint(cubic.p2);
  bbox.hullPoint(cubic.p3);
  return bbox;
}

Aabb2 _splineBbox(CubicSpline2 spline) {
  if (spline.isEmpty) return Aabb2.point(.zero());

  final storage = spline.storage;
  final count = storage.length;

  if (count <= 3) return .point(storage[0]);
  
  final bbox = Aabb2.point(storage[0]);
  for (var i = 2; i < count - 1; i++) bbox.hullPoint(storage[i]);
  return bbox;
}
