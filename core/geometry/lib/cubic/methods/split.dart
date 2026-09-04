part of '../cubic.dart';

(Cubic2, Cubic2) _cubicSplit(Cubic2 c, double t) {
  if (c.isStraightLine) {
    final p = c.point(t);
    return (.new(c.p0, p), .new(p, c.p3));
  }

  final left = Cubic2.zero(), right = Cubic2.zero();
  _deCasteljauSplit(c.p0, c.p1, c.p2, c.p3, t, left, right);
  return (left, right);
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

  if (c.isStraightLine) {
    final pts = [c.p0, for (final t in ts) c.point(t), c.p3];
    return [for (var i = 0; i < pts.length - 1; i++) .new(pts[i], pts[i + 1])];
  }

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
