part of '../cubic.dart';

CubicSpline2 _splineFromCubics(List<Cubic2> cubics) {
  final knots = <CubicKnot2>[];
  if (cubics.isEmpty) return .empty();

  knots.add(.new(cubics.first.p0, cIn: null, cOut: cubics.first.p1));

  for (var i = 0; i < cubics.length - 1; i++) {
    knots.add(.new(cubics[i].p3, cIn: cubics[i].p2, cOut: cubics[i + 1].p1));
  }

  knots.add(.new(cubics.last.p3, cIn: cubics.last.p2, cOut: null));

  return CubicSpline2(knots);
}

Cubic2 _splineSegment(CubicSpline2 spline, int i) {
  if (i < 0 || i >= spline.segmentCount) throw RangeError.index(i, spline.knots, 'segment', null, spline.segmentCount);
  final k0 = spline.knots[i];
  final k1 = spline.knots[i + 1];
  return .new(k0.p, k1.p, p1: k0.cOut, p2: k1.cIn);
}

(Cubic2, double) _splineSegmentAtParameter(CubicSpline2 spline, double t) {
  if (spline.isEmpty) throw StateError('Cannot get segment of an empty spline');
  if (spline.length == 1) return (.new(spline.knots.first.p, spline.knots.first.p), 0.0);

  final n = spline.segmentCount;
  final clamped = t.clamp(0.0, 1.0) * n;
  if (clamped >= n) return (_splineSegment(spline, n - 1), 1.0);

  final i = clamped.floor();
  return (_splineSegment(spline, i), clamped - i);
}

Iterable<Cubic2> _splineSegments(CubicSpline2 spline) sync* {
  for (var i = 0; i < spline.segmentCount; i++) yield _splineSegment(spline, i);
}
