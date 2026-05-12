part of '../cubic.dart';

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
