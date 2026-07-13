part of '../cubic.dart';

@pragma('vm:prefer-inline')
void _validateT(double t) {
  if (!(t > 0 && t < 1)) throw ArgumentError.value(t, 't', 'must be in range (0, 1)');
}

(Cubic2, Cubic2) _cubicSplit(Cubic2 cubic, double t) {
  final (left, right) = _deCasteljauSplit(cubic.p0, cubic.p1, cubic.p2, cubic.p3, t);
  return (
    Cubic2(left.p0, left.p3, p1: left.p1, p2: left.p2),
    Cubic2(right.p0, right.p3, p1: right.p1, p2: right.p2),
  );
}

(CubicSpline2, CubicSpline2) _splineSplit(CubicSpline2 spline, double t) {
  final knots = spline.knots;
  final n = spline.segmentCount;

  if (n == 0) throw StateError('Cannot split an empty spline');
  _validateT(t);

  final local = t * n;
  final rounded = local.round();

  // Split point is exactly on a knot.
  if (rounded >= 1 && rounded <= n - 1 && (local - rounded).abs() < 1e-9) {
    final left = knots.take(rounded + 1).map((k) => k.copy()).toList();
    final right = knots.skip(rounded).map((k) => k.copy()).toList();
    left.last.cOut = left.last.p.clone();
    right.first.cIn = right.first.p.clone();
    return (.new(left), .new(right));
  }

  final i = local.floor();
  final u = local - i;
  final (left, right) = spline.segment(i).split(u);

  final leftKnots = knots.take(i).map((k) => k.copy()).toList();
  final leftBoundary = knots[i].copy();
  leftBoundary.cOut = left.p1.clone();
  leftKnots.add(leftBoundary);
  leftKnots.add(left.endKnot);

  final rightKnots = <CubicKnot2>[];
  rightKnots.add(right.startKnot);
  final rightBoundary = knots[i + 1].copy();
  rightBoundary.cIn = right.p2.clone();
  rightKnots.add(rightBoundary);
  rightKnots.addAll(knots.skip(i + 2).map((k) => k.copy()));

  return (.new(leftKnots), .new(rightKnots));
}

// --
// Split multiple
// --

List<Cubic2> _cubicSplitMultiple(Cubic2 cubic, List<double> ts_) {
  if (ts_.isEmpty) return [cubic.copy()];
  final ts = _sortAndValidateTsList(ts_);

  final pieces = <Cubic2>[];
  var current = cubic;
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
  if (spline.segmentCount == 0) throw StateError('Cannot split an empty spline');
  final ts = _sortAndValidateTsList(ts_);

  final n = spline.segmentCount;
  final closeAtKnot = <int>{};
  final splitsBySegment = <int, List<double>>{};
  for (final t in ts) {
    final scaled = t * n;
    final closestKnot = scaled.round();
    if (closestKnot >= 1 && closestKnot <= n - 1 && (scaled - closestKnot).abs() < 1e-9) {
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
