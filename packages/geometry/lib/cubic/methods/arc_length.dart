part of '../cubic.dart';

double _cubicArcLength(Cubic2 cubic, {double? tolerance}) => _ffiCubicArcLength(cubic);
Vector2 _cubicPointAtDistance(Cubic2 cubic, double distance) => _ffiCubicPosAtDistance(cubic, distance);
Vector2 _cubicTangentAtDistance(Cubic2 cubic, double distance) => _ffiCubicTanAtDistance(cubic, distance).normalized();
Vector2 _cubicVelocityAtDistance(Cubic2 cubic, double distance) => _ffiCubicTanAtDistance(cubic, distance);

double _cubicTAtDistance(Cubic2 cubic, double distance) => cubic._arcLengthIndex.tAtDistance(distance);
double _cubicDistanceAtT(Cubic2 cubic, double t) => cubic._arcLengthIndex.distanceAtT(t);

class _CubicArcLengthIndex {
  _CubicArcLengthIndex._(this._samples, this._totalLength);

  factory _CubicArcLengthIndex.compute(Cubic2 cubic, {double? tolerance}) {
    final _samples = [(0.0, 0.0)];
    var currentLength = 0.0;

    var lastPoint = cubic.p0;
    cubic.forEachSegment((s, t0, t1) {
      currentLength += (s.end - lastPoint).length;
      _samples.add((t1, currentLength));
      lastPoint = s.end;
    });

    return _CubicArcLengthIndex._(_samples, currentLength);
  }

  final List<(double, double)> _samples;
  final double _totalLength;

  double distanceAtT(double t) {
    if (t <= 0.0) return 0.0;
    if (t >= 1.0) return _totalLength;

    var lo = 0, hi = _samples.length - 1;
    while (lo <= hi) {
      final m = (lo + hi) ~/ 2;
      if (_samples[m].$1 == t) return _samples[m].$2;
      if (_samples[m].$1 < t) {
        lo = m + 1;
      } else {
        hi = m - 1;
      }
    }

    final (t0, s0) = _samples[hi];
    final (t1, s1) = _samples[lo];
    final localT = (t - t0) / (t1 - t0);
    return s0 + localT * (s1 - s0);
  }

  double tAtDistance(double distance) {
    if (distance <= 0.0) return 0.0;
    if (distance >= _totalLength) return 1.0;

    var lo = 0, hi = _samples.length - 1;
    while (lo <= hi) {
      final m = (lo + hi) ~/ 2;
      if (_samples[m].$2 == distance) return _samples[m].$1;
      if (_samples[m].$2 < distance) {
        lo = m + 1;
      } else {
        hi = m - 1;
      }
    }

    final (t0, s0) = _samples[hi];
    final (t1, s1) = _samples[lo];
    final localT = (distance - s0) / (s1 - s0);
    return t0 + localT * (t1 - t0);
  }
}

class _SplineArcLengthIndex {
  _SplineArcLengthIndex(this.segmentLengths, this.cumulativeLengths);

  final List<double> segmentLengths;
  final List<double> cumulativeLengths;

  factory _SplineArcLengthIndex.compute(CubicSpline2 spline) {
    final n = spline.segmentCount;
    final lengths = List<double>.filled(n, 0.0);
    final cumulative = List<double>.filled(n, 0.0);
    var sum = 0.0;

    for (var i = 0; i < n; i++) {
      final segLength = _cubicArcLength(spline.segment(i));
      sum += segLength;
      lengths[i] = segLength;
      cumulative[i] = sum;
    }

    return _SplineArcLengthIndex(lengths, cumulative);
  }

  double get totalLength => cumulativeLengths.last;

  /// Returns (segmentIndex, segmentLocalDistance) for a given distance along the spline.
  (int, double) locate(double s) {
    if (s <= 0) return (0, 0);
    if (s >= totalLength) return (segmentLengths.length - 1, segmentLengths.last);

    var lo = 0;
    var hi = cumulativeLengths.length - 1;
    while (lo < hi) {
      final mid = (lo + hi) ~/ 2;
      if (cumulativeLengths[mid] < s) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }

    if (lo == 0) return (lo, s);
    return (lo, s - cumulativeLengths[lo - 1]);
  }
}

(Cubic2, double) _splineSegmentAtDistance(CubicSpline2 spline, double distance) {
  final index = spline._arcLengthIndex.locate(distance);
  return (spline.segment(index.$1), index.$2);
}

Vector2 _splinePointAtDistance(CubicSpline2 spline, double distance) {
  final segInfo = spline._arcLengthIndex.locate(distance);
  final segment = spline.segment(segInfo.$1);
  return segment.pointAtDistance(segInfo.$2);
}

Vector2 _splineTangentAtDistance(CubicSpline2 spline, double distance) {
  final segInfo = spline._arcLengthIndex.locate(distance);
  final segment = spline.segment(segInfo.$1);
  return segment.tangentAtDistance(segInfo.$2);
}

Vector2 _splineVelocityAtDistance(CubicSpline2 spline, double distance) {
  final segInfo = spline._arcLengthIndex.locate(distance);
  final segment = spline.segment(segInfo.$1);
  return segment.velocityAtDistance(segInfo.$2);
}

double _splineTAtDistance(CubicSpline2 spline, double distance) {
  final n = spline.segmentCount;
  final (segIdx, segDistance) = spline._arcLengthIndex.locate(distance);
  final segment = spline.segment(segIdx);
  final localT = segment.tAtDistance(segDistance);
  return (segIdx + localT) / n;
}

double _splineDistanceAtT(CubicSpline2 spline, double t) {
  if (t <= 0.0) return 0.0;
  if (t >= 1.0) return spline.arcLength;

  final n = spline.segmentCount;
  final scaled = t * n;
  final segIdx = math.min(scaled.floor(), n - 1);
  final localT = scaled - segIdx;

  final index = spline._arcLengthIndex;
  final segmentStartLength = segIdx == 0 ? 0.0 : index.cumulativeLengths[segIdx - 1];

  final segment = spline.segment(segIdx);
  final localDistance = segment.distanceAtT(localT);
  return segmentStartLength + localDistance;
}
