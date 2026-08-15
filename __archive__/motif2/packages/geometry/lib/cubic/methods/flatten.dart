part of '../cubic.dart';

typedef FlattenResult = (Polyline2 polyline, List<double> t);

typedef FlattenCallback = void Function(Vector2 point, double t);
typedef FlattenSegmentsCallback = void Function(LineSegment2 segment, double at, double bt);

FlattenResult _cubicFlattenWithResult(Vector2 p0, Vector2 p1, Vector2 p2, Vector2 p3, double? tolerance) {
  final points = <Vector2>[];
  final tValues = <double>[];

  _cubicFlatten(p0, p1, p2, p3, tolerance ?? _kCubicFlatnessTolerance, (point, t) {
    points.add(point);
    tValues.add(t);
  });

  return (.new(points), tValues);
}

void _cubicFlatten(Vector2 p0, Vector2 p1, Vector2 p2, Vector2 p3, double? tolerance, FlattenCallback callback) {
  callback(p0, 0.0);

  const _maxDepth = 24;
  void recurse(Vector2 a, Vector2 b, Vector2 c, Vector2 d, double t0, double t1, int depth) {
    if (depth >= _maxDepth || _isFlatEnough(a, b, c, d, tolerance ?? _kCubicFlatnessTolerance)) {
      callback(d, t1);
      return;
    }

    final tm = (t0 + t1) / 2;
    final (l, r) = _deCasteljauSplit(a, b, c, d, 0.5);
    recurse(l.p0, l.p1, l.p2, l.p3, t0, tm, depth + 1);
    recurse(r.p0, r.p1, r.p2, r.p3, tm, t1, depth + 1);
  }

  recurse(p0, p1, p2, p3, 0.0, 1.0, 0);
}

bool _isFlatEnough(Vector2 a, Vector2 b, Vector2 c, Vector2 d, double tolerance) {
  return perpendicularDistance(b, a, d) <= tolerance && perpendicularDistance(c, a, d) <= tolerance;
}

FlattenResult _splineFlattenWithResult(CubicSpline2 spline, double? tolerance) {
  final points = <Vector2>[];
  final tValues = <double>[];

  _splineFlatten(spline, tolerance ?? _kCubicFlatnessTolerance, (point, t) {
    points.add(point);
    tValues.add(t);
  });

  return (.new(points), tValues);
}

void _splineFlatten(CubicSpline2 spline, double? tolerance, FlattenCallback callback) {
  if (spline.isEmpty) return;
  callback(spline.knots.first.p, 0.0);

  for (var i = 0; i < spline.segmentCount; i++) {
    final k0 = spline.knots[i];
    final k1 = spline.knots[i + 1];

    var isFirstPoint = true;
    _cubicFlatten(k0.p, k0.cOut, k1.cIn, k1.p, tolerance ?? _kCubicFlatnessTolerance, (point, t) {
      if (isFirstPoint) {
        isFirstPoint = false;
        return;
      }

      final globalT = (i + t) / spline.segmentCount;
      callback(point, globalT);
    });
  }
}

void _splineFlattenToSegments(CubicSpline2 spline, double? tolerance, FlattenSegmentsCallback callback) {
  Vector2? previousPoint;
  double previousT = 0.0;

  _splineFlatten(spline, tolerance ?? _kCubicFlatnessTolerance, (point, t) {
    if (previousPoint != null) callback(.new(previousPoint!, point), previousT, t);
    previousPoint = point;
    previousT = t;
  });
}

void _cubicFlattenToSegments(
  Vector2 p0,
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
  double? tolerance,
  FlattenSegmentsCallback callback,
) {
  Vector2? previousPoint;
  double previousT = 0.0;

  _cubicFlatten(p0, p1, p2, p3, tolerance ?? _kCubicFlatnessTolerance, (point, t) {
    if (previousPoint != null) callback(.new(previousPoint!, point), previousT, t);
    previousPoint = point;
    previousT = t;
  });
}
