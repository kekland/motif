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
    left.last.cOut = null;
    right.first.cIn = null;
    return (.new(left), .new(right));
  }

  final i = local.floor();
  final u = local - i;
  final (left, right) = spline.segment(i).split(u);

  final leftKnots = knots.take(i).map((k) => k.copy()).toList();
  final leftBoundary = knots[i].copy();
  leftBoundary.cOut = left.isP1Collapsed ? null : left.p1.clone();
  leftKnots.add(leftBoundary);
  leftKnots.add(left.endKnot);

  final rightKnots = <CubicKnot2>[];
  rightKnots.add(right.startKnot);
  final rightBoundary = knots[i + 1].copy();
  rightBoundary.cIn = right.isP2Collapsed ? null : right.p2.clone();
  rightKnots.add(rightBoundary);
  rightKnots.addAll(knots.skip(i + 2).map((k) => k.copy()));

  return (.new(leftKnots), .new(rightKnots));
}

// --
// Split multiple
// --

List<T> _splitMultiple<T>(T arg, (T, T) Function(T, double) splitFn, List<double> ts) {
  final sorted = ts.toList(growable: false)..sort();
  for (final t in sorted) _validateT(t);

  for (var i = 1; i < sorted.length; i++) {
    if ((sorted[i] - sorted[i - 1]).abs() < 1e-9) {
      throw ArgumentError.value(ts, 'ts', 'values must be unique (also not near-coincident)');
    }
  }

  final pieces = <T>[];
  var current = arg;
  var remaining = sorted;

  while (remaining.isNotEmpty) {
    final u = remaining.first;
    final (left, right) = splitFn(current, u);
    pieces.add(left);
    current = right;
    final scale = 1.0 - u;
    remaining = [for (final t in remaining.skip(1)) (t - u) / scale];
  }

  pieces.add(current);
  return pieces;
}

List<Cubic2> _cubicSplitMultiple(Cubic2 cubic, List<double> ts) {
  if (ts.isEmpty) return [cubic.copy()];
  return _splitMultiple(cubic, _cubicSplit, ts);
}

List<CubicSpline2> _splineSplitMultiple(CubicSpline2 spline, List<double> ts) {
  if (ts.isEmpty) return [spline.copy()];
  if (spline.segmentCount == 0) throw StateError('Cannot split an empty spline');

  return _splitMultiple(spline, _splineSplit, ts);
}
