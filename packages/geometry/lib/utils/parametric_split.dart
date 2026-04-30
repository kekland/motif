List<T> parametricSplit<T>(T arg, List<double> ts, (T, T) Function(T, double) splitFn) {
  final sorted = ts.toList(growable: false)..sort();
  for (final t in sorted) {
    if (!(t > 0 && t < 1)) throw ArgumentError.value(t, 't', 'must be in range (0, 1)');
  }

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
