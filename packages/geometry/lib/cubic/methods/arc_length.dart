part of '../cubic.dart';

double _cubicArcLength(Cubic2 cubic, {double? tolerance}) => _ffiCubicArcLength(cubic);
Vector2 _cubicPointAtDistance(Cubic2 cubic, double distance) => _ffiCubicPosAtDistance(cubic, distance);
Vector2 _cubicTangentAtDistance(Cubic2 cubic, double distance) => _ffiCubicTanAtDistance(cubic, distance).normalized();
Vector2 _cubicVelocityAtDistance(Cubic2 cubic, double distance) => _ffiCubicTanAtDistance(cubic, distance);

double _cubicTAtDistance(Cubic2 cubic, double distance) => distance / cubic.arcLength;
double _cubicDistanceAtT(Cubic2 cubic, double t) => cubic.arcLength * t;

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
    while (lo + 1 < hi) {
      final mid = (lo + hi) ~/ 2;
      if (cumulativeLengths[mid] < s) {
        lo = mid;
      } else {
        hi = mid;
      }
    }

    return (lo, s - cumulativeLengths[lo]);
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
  final segLength = spline._arcLengthIndex.segmentLengths[segIdx];
  if (segLength <= 0) return segIdx / n;
  final localT = segDistance / segLength;
  return (segIdx + localT) / n;
}

double _splineDistanceAtT(CubicSpline2 spline, double t) {
  final n = spline.segmentCount;
  final scaled = t * n;
  final segIdx = math.min(scaled.floor(), n - 1);
  final localT = scaled - segIdx;

  final index = spline._arcLengthIndex;
  return index.cumulativeLengths[segIdx] + localT * index.segmentLengths[segIdx];
}
