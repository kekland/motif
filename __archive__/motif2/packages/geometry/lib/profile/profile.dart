import 'dart:math' as math;
import 'package:geometry/geometry.dart';

part 'arc_length_profile.dart';
part 'parameter_profile.dart';

typedef ProfileSample = ({
  double x,
  double v,
  double dv,
});

typedef RawProfileSample = ({
  double x,
  double v,
});

abstract class ValueProfile<P extends ValueProfile<P>> {
  ValueProfile(this._totalLength) : _samples = [], _dvs = [];
  ValueProfile.from(this._samples, this._totalLength) : _dvs = [] {
    _computeDvs();
  }

  P copy();

  final List<RawProfileSample> _samples;
  List<double> _dvs;

  double _totalLength;
  double get totalLength => _totalLength;
  set totalLength(double v) {
    if (_totalLength == v) return;
    _totalLength = v;
  }

  Iterable<RawProfileSample> get rawSamples => _samples;
  Iterable<ProfileSample> get samples sync* {
    for (var i = 0; i < _samples.length; i++) {
      yield _sampleAt(i);
    }
  }

  bool get isEmpty => _samples.isEmpty;
  bool get isNotEmpty => _samples.isNotEmpty;
  double get min => _samples.map((s) => s.v).reduce(math.min);
  double get max => _samples.map((s) => s.v).reduce(math.max);
  double get dvMin => _dvs.reduce(math.min);
  double get dvMax => _dvs.reduce(math.max);

  void _computeDvs() {
    _dvs = hermiteTangents(_samples);
  }

  ProfileSample _sampleAt(int i) => (x: _samples[i].x, v: _samples[i].v, dv: _dvs[i]);

  ProfileSample _interpolate(ProfileSample a, ProfileSample b, double t) => hermiteInterpolate(a, b, t);

  (int, int) _search(double x) {
    var lo = 0, hi = _samples.length - 1;
    while (lo + 1 < hi) {
      final m = (lo + hi) ~/ 2;
      if (_samples[m].x < x) {
        lo = m;
      } else {
        hi = m;
      }
    }

    return (lo, hi);
  }

  int? maybeIndexAt(double x, {double? tolerance}) {
    final (lo, hi) = _search(x);
    final a = _samples[lo], b = _samples[hi];
    if (tolerance != null) {
      final da = (x - a.x).abs();
      final db = (x - b.x).abs();
      if (da > tolerance && db > tolerance) return null;
      if (da <= db) return lo;
      return hi;
    }

    if (a.x == x) return lo;
    if (b.x == x) return hi;
    return null;
  }

  ProfileSample? maybeAt(double x, {double? tolerance}) {
    final idx = maybeIndexAt(x, tolerance: tolerance);
    if (idx == null) return null;
    return _sampleAt(idx);
  }

  ProfileSample at(double x) {
    if (x <= 0.0) return _sampleAt(0);
    if (x >= totalLength) return _sampleAt(_samples.length - 1);

    final (lo, hi) = _search(x);
    final a = _sampleAt(lo), b = _sampleAt(hi);
    if (a.x == b.x) return a;

    final t = (x - a.x) / (b.x - a.x);
    return _interpolate(a, b, t);
  }

  (List<RawProfileSample>, List<RawProfileSample>) _split(double x) {
    if (isEmpty) return ([], []);
    if (x <= 0.0) return ([_samples.first], _samples);
    if (x >= totalLength) return (_samples, [_samples.last]);

    final splitSample = at(x);
    final left = <RawProfileSample>[];
    final right = <RawProfileSample>[];

    right.add((x: 0.0, v: splitSample.v));

    for (final s in _samples) {
      if (s.x < x) {
        left.add(s);
      } else if (s.x > x) {
        right.add((x: s.x - x, v: s.v));
      }
    }

    left.add((x: x, v: splitSample.v));
    return (left, right);
  }

  bool hasSampleAt(double x, {double? tolerance}) => maybeAt(x, tolerance: tolerance) != null;
  void insert(double x, double v, {double? tolerance}) {
    final existingIdx = maybeIndexAt(x, tolerance: tolerance);
    if (existingIdx != null) {
      _samples[existingIdx] = (x: x, v: v);
    } else {
      final (lo, hi) = _search(x);
      _samples.insert(hi, (x: x, v: v));
    }

    _computeDvs();
  }

  void remove(double x, {double? tolerance}) {
    final idx = maybeIndexAt(x, tolerance: tolerance);
    if (idx != null) {
      _samples.removeAt(idx);
      _computeDvs();
    }
  }

  (P, P) split(double x);
  List<P> splitMultiple(List<double> xs);
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
