part of '../cubic.dart';

class _ProfileSample<T> {
  const _ProfileSample(this._s, this.value);

  final double _s;
  final T value;
}

abstract class _CubicProfile<T, S extends _ProfileSample<T>, P extends _CubicProfile<T, S, P>> {
  _CubicProfile(this._samples);

  P copy();

  final List<S> _samples;
  double get _totalLength;

  Iterable<S> get samples => _samples;
  double get totalLength => _totalLength;

  T lerp(T a, T b, double t);

  T at(double s) {
    if (s <= 0.0) return _samples.first.value;
    if (s >= _totalLength) return _samples.last.value;

    int lo = 0, hi = _samples.length - 1;
    while (lo + 1 < hi) {
      final m = (lo + hi) ~/ 2;
      if (_samples[m]._s < s) {
        lo = m;
      } else {
        hi = m;
      }
    }

    final a = _samples[lo], b = _samples[hi];
    if (a._s == b._s) return a.value;

    final t = (s - a._s) / (b._s - a._s);
    return lerp(a.value, b.value, t);
  }

  (List<(double, T)>, List<(double, T)>) _splitRaw(double dist) {
    if (dist <= 0.0) return ([(0.0, at(0.0))], _samples.map((s) => (s._s, s.value)).toList());
    if (dist >= _totalLength) return (_samples.map((s) => (s._s, s.value)).toList(), [(0.0, at(_totalLength))]);

    final splitValue = at(dist);
    final leftSamples = <(double, T)>[];
    final rightSamples = <(double, T)>[];

    rightSamples.add((0.0, splitValue));

    for (final sample in _samples) {
      if (sample._s < dist) {
        leftSamples.add((sample._s, sample.value));
      } else if (sample._s > dist) {
        rightSamples.add((sample._s - dist, sample.value));
      }
    }

    leftSamples.add((dist, splitValue));
    return (leftSamples, rightSamples);
  }

  (P, P) split(double dist);

  List<double> _sortAndValidateSplits(List<double> splits);

  List<List<S>> _splitMultipleRaw(List<double> dists) {
    if (dists.isEmpty) return [_samples.toList()];
    final sortedDists = _sortAndValidateSplits(dists);

    final results = <List<S>>[];
    var current = this as P;
    var offset = 0.0;

    for (final dist in sortedDists) {
      final localDist = dist - offset;
      final (left, right) = current.split(localDist);
      results.add(left._samples.toList());
      current = right;
      offset = dist;
    }

    results.add(current._samples.toList());
    return results;
  }

  List<P> splitMultiple(List<double> dists);
}
