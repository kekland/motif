part of '../cubic.dart';

extension type const CubicArcIndex._(Float64List _cumulative) implements Object {
  static CubicArcIndex of(Cubic2 cubic, {int segments = 32}) {
    final cumulative = Float64List(segments + 1);
    for (var i = 0; i < segments; i++) {
      cumulative[i + 1] = cumulative[i] + _segmentLength(cubic, i / segments, (i + 1) / segments);
    }
    return CubicArcIndex._(cumulative);
  }

  int get segmentCount => _cumulative.length - 1;
  double get length => _cumulative.last;

  double distanceBetween(double t0, double t1) {
    if (t0 > t1) throw ArgumentError.value(t0, 't0', 'must be <= t1');
    return distanceAt(t1) - distanceAt(t0);
  }

  double distanceAt(double t) {
    if (t <= 0) return 0;
    if (t >= 1) return length;
    final s = t * segmentCount, i = s.floor();
    return _cumulative[i] + (_cumulative[i + 1] - _cumulative[i]) * (s - i);
  }

  double tAt(double distance) {
    if (distance <= 0) return 0;
    if (distance >= length) return 1;
    var lo = 0, hi = segmentCount;
    while (hi - lo > 1) {
      final mid = (lo + hi) >> 1;
      if (_cumulative[mid] <= distance) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    final a = _cumulative[lo], b = _cumulative[hi];
    return (lo + (distance - a) / (b - a)) / segmentCount;
  }

  static double _segmentLength(Cubic2 c, double t0, double t1) {
    final half = (t1 - t0) / 2, mid = (t0 + t1) / 2;
    var sum = 0.0;
    for (var k = 0; k < 5; k++) sum += _gw[k] * c.velocity(mid + half * _gn[k]).length;
    return sum * half;
  }

  static const _gn = [
    -0.9061798459386640,
    -0.5384693101056831,
    0.0,
    0.5384693101056831,
    0.9061798459386640,
  ];

  static const _gw = [
    0.2369268850561891,
    0.4786286704993665,
    0.5688888888888889,
    0.4786286704993665,
    0.2369268850561891,
  ];
}
