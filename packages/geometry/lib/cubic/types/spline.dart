part of '../cubic.dart';

final class CubicSpline2 {
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

  Aabb2 get bboxCheap => _splineBboxCheap(this);

  CubicKnot2 knot(int i) => knots[i];

  Cubic2 segment(int i) => _splineSegment(this, i);
  (Cubic2, double) segmentAt(double t) => _splineSegmentAtParameter(this, t);
  Iterable<Cubic2> get segments => _splineSegments(this);

  Vector2 evaluate(double t) => _splineEvaluate(this, t);
  Vector2 velocity(double t) => _splineVelocity(this, t);
  Vector2 tangent(double t) => _splineTangent(this, t);

  double arcLength({double? tolerance}) => _splineArcLength(this, tolerance: tolerance);
  (CubicSpline2, CubicSpline2) split(double t) => _splineSplit(this, t);
  List<CubicSpline2> splitMultiple(List<double> ts) => _splineSplitMultiple(this, ts);

  Vector2 get tangentAtStart => segment(0).tangent(0.0);
  Vector2 get tangentAtEnd => segment(segmentCount - 1).tangent(1.0);

  FlattenResult flatten({double? tolerance}) => _splineFlattenWithResult(this, tolerance);

  void forEachSample(FlattenCallback callback, {double? tolerance}) => _splineFlatten(this, tolerance, callback);
  void forEachSegment(FlattenSegmentsCallback callback, {double? tolerance}) =>
      _splineFlattenToSegments(this, tolerance, callback);

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
