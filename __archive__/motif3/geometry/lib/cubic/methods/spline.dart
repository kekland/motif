part of '../cubic.dart';

Cubic2 _splineSegment(CubicSpline2 spline, int i) {
  if (i < 0 || i >= spline.segmentCount) throw RangeError.range(i, 0, spline.segmentCount - 1);
  return .splineView(spline._storage, i);
}

(int, double) _splineSegmentIndexAtParameter(CubicSpline2 spline, double t) {
  if (spline.isEmpty) throw StateError('cannot get segment from empty spline');
  if (spline.length == 1) throw StateError('cannot get segment from spline with only one knot');

  final n = spline.segmentCount;
  final clamped = t.clamp(0.0, 1.0) * n;
  if (clamped >= n) return (n - 1, 1.0);

  final i = clamped.floor();
  return (i, clamped - i);
}

(Cubic2, double) _splineSegmentAtParameter(CubicSpline2 spline, double t) {
  final (i, localT) = _splineSegmentIndexAtParameter(spline, t);
  return (.splineView(spline._storage, i), localT);
}

(CubicKnot2, CubicKnot2) _splineKnotsAtParameter(CubicSpline2 spline, double t) {
  if (spline.length == 1) return (spline.knot(0), spline.knot(0));

  final (i, _) = _splineSegmentIndexAtParameter(spline, t);
  if (i == spline.segmentCount - 1) return (spline.knot(i), spline.knot(i));
  return (spline.knot(i), spline.knot(i + 1));
}

Iterable<CubicKnot2> _splineKnots(CubicSpline2 spline) sync* {
  for (var i = 0; i < spline.length; i++) yield .splineView(spline._storage, i);
}

Iterable<Cubic2> _splineSegments(CubicSpline2 spline) sync* {
  for (var i = 0; i < spline.segmentCount; i++) yield .splineView(spline._storage, i);
}

CubicSpline2 _splineReversed(CubicSpline2 spline) {
  final length = spline.length;
  final out = CubicSpline2.withCapacity(length);
  for (var i = 0; i < length; i++) {
    final j = length - i - 1;
    out.p[i] = spline.p[j];
    out.cIn[i] = spline.cOut[j];
    out.cOut[i] = spline.cIn[j];
  }
  return out;
}

CubicSpline2 _splineJoin(CubicSpline2 a, CubicSpline2 b) {
  if (a.isEmpty) return b.copy();
  if (b.isEmpty) return a.copy();

  final last = a.last.p, first = b.first.p;
  if (!last.equals(first)) throw ArgumentError('cannot join splines: anchors $last != $first');

  final n = a.length + b.length - 1;
  final out = CubicSpline2.withCapacity(n);
  out.storage.setRange(0, a.length * 3, a.storage);
  out.cOut[a.length - 1] = b.cOut[0];
  out.storage.setRange(a.length * 3, n * 3, b.storage, 3);
  return out;
}
