part of '../cubic.dart';

@pragma('vm:prefer-inline')
void _validateT(double t) {
  if (!(t > 0 && t < 1)) throw ArgumentError.value(t, 't', 'must be in range (0, 1)');
}

(Cubic2, Cubic2) _cubicSplit(Cubic2 c, double t) {
  if (c.isStraightLine) {
    final p = c.point(t);
    return (.new(c.p0, p), .new(p, c.p3));
  }

  final (left, right) = _deCasteljauSplit(c.p0, c.p1, c.p2, c.p3, t);
  return (
    .new(left.p0, left.p3, p1: left.p1, p2: left.p2),
    .new(right.p0, right.p3, p1: right.p1, p2: right.p2),
  );
}

(CubicSpline2, CubicSpline2) _splineSplit(CubicSpline2 spline, double t) {
  final knots = spline.knots.toList();
  final n = spline.segmentCount;

  if (n == 0) throw StateError('cannot split empty spline');
  _validateT(t);

  final local = t * n;
  final rounded = local.round();

  // Split point exactly on a knot
  if (rounded >= 1 && rounded <= n - 1 && (local - rounded).abs() < 1e-9) {
    final left = knots.take(rounded + 1).copy();
    final right = knots.skip(rounded).copy();
    left.last.cOut = left.last.p;
    right.first.cIn = right.first.p;
    return (.knots(left), .knots(right));
  }

  final i = local.floor();
  final u = local - i;
  final (left, right) = spline.segment(i).split(u);

  final leftKnots = knots.take(i).copy();
  final leftBoundary = knots[i].copy();
  leftBoundary.cOut = left.p1;
  leftKnots.add(leftBoundary);
  leftKnots.add(left.endKnot);

  final rightKnots = <CubicKnot2>[];
  rightKnots.add(right.startKnot);
  final rightBoundary = knots[i + 1].copy();
  rightBoundary.cIn = right.p2;
  rightKnots.add(rightBoundary);
  rightKnots.addAll(knots.skip(i + 2).copy());

  return (.knots(leftKnots), .knots(rightKnots));
}

List<double> _sortAndValidateSplitsList(List<double> v, double min, double max, double tolerance) {
  final sorted = v.toList(growable: false)..sort();
  for (final t in sorted) {
    if (!(t > min && t < max)) throw ArgumentError.value(t, 't', 'must be in range ($min, $max)');
  }

  for (var i = 1; i < sorted.length; i++) {
    if ((sorted[i] - sorted[i - 1]).abs() < tolerance) {
      throw ArgumentError.value(sorted, 'v', 'values must be unique (also not near-coincident)');
    }
  }

  return sorted;
}

List<double> _sortAndValidateTsList(List<double> ts) {
  return _sortAndValidateSplitsList(ts, 0.0, 1.0, 1e-9);
}

List<Cubic2> _cubicSplitMultiple(Cubic2 c, List<double> ts_) {
  if (ts_.isEmpty) return [c.copy()];
  final ts = _sortAndValidateTsList(ts_);

  final pieces = <Cubic2>[];
  var current = c;
  var remaining = ts;

  while (remaining.isNotEmpty) {
    final u = remaining.first;
    final (left, right) = _cubicSplit(current, u);
    pieces.add(left);
    current = right;
    final scale = 1.0 - u;
    remaining = [for (final t in remaining.skip(1)) (t - u) / scale];
  }

  pieces.add(current);
  return pieces;
}

List<CubicSpline2> _splineSplitMultiple(CubicSpline2 spline, List<double> ts_) {
  if (ts_.isEmpty) return [spline.copy()];
  if (spline.segmentCount == 0) throw StateError('cannot split empty spline');
  final ts = _sortAndValidateTsList(ts_);

  final n = spline.segmentCount;
  final closeAtKnot = <int>{};
  final splitsBySegment = <int, List<double>>{};
  for (final t in ts) {
    final scaled = t * n;
    final closestKnot = scaled.round();
    if (closestKnot >= 1 && closestKnot <= n - 1 && (scaled - closestKnot).abs() < 2e-9) {
      closeAtKnot.add(closestKnot);
      continue;
    }

    final segIdx = math.min(scaled.floor(), n - 1);
    splitsBySegment[segIdx] ??= [];
    splitsBySegment[segIdx]!.add(scaled - segIdx);
  }

  for (final key in splitsBySegment.keys) splitsBySegment[key]!.sort();

  final result = <CubicSpline2>[];
  final current = <Cubic2>[];
  void flush() {
    if (current.isNotEmpty) {
      result.add(.cubics(current));
      current.clear();
    }
  }

  for (var segIdx = 0; segIdx < n; segIdx++) {
    final cubicTs = splitsBySegment[segIdx] ?? [];
    var cubic = spline.segment(segIdx);
    var prev = 0.0;

    for (final t in cubicTs) {
      final (left, right) = _cubicSplit(cubic, (t - prev) / (1 - prev));
      current.add(left);
      flush();

      cubic = right;
      prev = t;
    }

    current.add(cubic);

    if (segIdx < n - 1 && closeAtKnot.contains(segIdx + 1)) {
      flush();
    }
  }

  flush();
  return [...result];
}
