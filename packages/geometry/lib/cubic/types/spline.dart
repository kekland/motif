part of '../cubic.dart';

class CubicSpline2 {
  CubicSpline2(this.knots);
  CubicSpline2.single(Vector2 p) : knots = [.new(p)];
  CubicSpline2.empty() : knots = [];
  factory CubicSpline2.cubics(List<Cubic2> cubics) => _splineFromCubics(cubics);

  CubicSpline2 copy() => .new(.from(knots.map((k) => k.copy())));
  CubicSpline2 reversed() => .new(.from(knots.reversed.map((k) => k._reversed())));

  List<CubicKnot2> knots;

  int get length => knots.length;
  bool get isEmpty => knots.isEmpty;
  int get segmentCount => length <= 1 ? 0 : length - 1;

  Aabb2 get bbox => _splineBbox(this);
  Aabb2 get bboxTight => _splineBboxTight(this);

  CubicKnot2 knot(int i) => knots[i];
  CubicKnot2 get first => knot(0);
  CubicKnot2 get last => knot(length - 1);
  (CubicKnot2, CubicKnot2) knotsAt(double t) => _splineKnotsAtParameter(this, t);

  Cubic2 segment(int i) => _splineSegment(this, i);
  (Cubic2, double) segmentAt(double t) => _splineSegmentAtParameter(this, t);
  (Cubic2, double) segmentAtDistance(double distance) => _splineSegmentAtDistance(this, distance);
  Iterable<Cubic2> get segments => _splineSegments(this);

  Vector2 point(double t) => _splineEvaluate(this, t);
  Vector2 velocity(double t) => _splineVelocity(this, t);
  Vector2 tangent(double t) => _splineTangent(this, t);

  Vector2 pointAtDistance(double distance) => _splinePointAtDistance(this, distance);
  Vector2 velocityAtDistance(double distance) => _splineVelocityAtDistance(this, distance);
  Vector2 tangentAtDistance(double distance) => _splineTangentAtDistance(this, distance);

  double tAtDistance(double distance) => _splineTAtDistance(this, distance);
  double distanceAtT(double t) => _splineDistanceAtT(this, t);

  _SplineArcLengthIndex? _arcLengthIndexCache;
  _SplineArcLengthIndex get _arcLengthIndex {
    // if (_arcLengthIndexCache != null) return _arcLengthIndexCache!;
    _arcLengthIndexCache = .compute(this);
    return _arcLengthIndexCache!;
  }

  double get arcLength => _arcLengthIndex.totalLength;
  (CubicSpline2, CubicSpline2) split(double t) => _splineSplit(this, t);
  List<CubicSpline2> splitMultiple(List<double> ts) => _splineSplitMultiple(this, ts);

  Vector2 get tangentAtStart => segment(0).tangent(0.0);
  Vector2 get tangentAtEnd => segment(segmentCount - 1).tangent(1.0);

  // dart format off
  FlattenResult flatten({double? tolerance}) => _splineFlattenWithResult(this, tolerance);
  void forEachSample(FlattenCallback callback, {double? tolerance}) => _splineFlatten(this, tolerance, callback);
  void forEachSegment(FlattenSegmentsCallback callback, {double? tolerance}) => _splineFlattenToSegments(this, tolerance, callback);

  List<Intersection> selfIntersect() => _splineSelfIntersect(this);
  List<Intersection> intersectWith(CubicSpline2 other) => _splineIntersect(this, other);
  List<Intersection> intersectWithCubic(Cubic2 other) => _splineCubicIntersect(this, other);
  List<Intersection> intersectWithCircle(Circle2 circle) => _splineCircleIntersect(this, circle);
  // dart format on

  ClosestPointResult closestTo(Vector2 q) => _splineClosestPoint(this, q);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CubicSpline2) return false;
    if (length != other.length) return false;
    for (var i = 0; i < length; i++) {
      if (knot(i) != other.knot(i)) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(knots);
}
