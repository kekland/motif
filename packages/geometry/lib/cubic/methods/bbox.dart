part of '../cubic.dart';

Aabb2 _knotBboxCheap(CubicKnot2 knot) {
  Vector2 min = knot.p.clone(), max = knot.p.clone();

  if (knot.cIn != null) {
    Vector2.min(min, knot.cIn!, min);
    Vector2.max(max, knot.cIn!, max);
  }

  if (knot.cOut != null) {
    Vector2.min(min, knot.cOut!, min);
    Vector2.max(max, knot.cOut!, max);
  }

  return Aabb2.minMax(min, max);
}

Aabb2 _cubicBboxCheap(Cubic2 cubic) {
  Vector2 min = cubic.p0.clone(), max = cubic.p0.clone();

  Vector2.min(min, cubic.p1, min);
  Vector2.max(max, cubic.p1, max);

  Vector2.min(min, cubic.p2, min);
  Vector2.max(max, cubic.p2, max);

  Vector2.min(min, cubic.p3, min);
  Vector2.max(max, cubic.p3, max);

  return Aabb2.minMax(min, max);
}

Aabb2 _splineBboxCheap(CubicSpline2 spline) {
  if (spline.isEmpty) return Aabb2();
  final first = spline.knots.first;
  var min = first.p.clone(), max = first.p.clone();

  for (final knot in spline.knots) {
    final aabb = knot.bboxCheap;
    Vector2.min(min, aabb.min, min);
    Vector2.max(max, aabb.max, max);
  }

  return Aabb2.minMax(min, max);
}
