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

List<Cubic2> _cubicSplitMultiple(Cubic2 cubic, List<double> ts) {
  if (ts.isEmpty) return [cubic.copy()];
  return parametricSplit(cubic, ts, _cubicSplit);
}

List<CubicSpline2> _splineSplitMultiple(CubicSpline2 spline, List<double> ts) {
  if (ts.isEmpty) return [spline.copy()];
  if (spline.segmentCount == 0) throw StateError('Cannot split an empty spline');

  return parametricSplit(spline, ts, _splineSplit);
}
