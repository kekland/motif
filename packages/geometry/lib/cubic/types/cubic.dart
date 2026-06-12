part of '../cubic.dart';

final class Cubic2 {
  Cubic2(this.p0, this.p3, {Vector2? p1, Vector2? p2}) : p1 = p1 ?? p0, p2 = p2 ?? p3;
  Cubic2.line(this.p0, this.p3) : p1 = p0, p2 = p3;

  Cubic2 copy() => .new(p0.clone(), p3.clone(), p1: p1.clone(), p2: p2.clone());
  Cubic2 reversed() => .new(p3.clone(), p0.clone(), p1: p2.clone(), p2: p1.clone());

  final Vector2 p0;
  final Vector2 p1;
  final Vector2 p2;
  final Vector2 p3;

  bool get isP1Collapsed => p0 == p1;
  bool get isP2Collapsed => p2 == p3;
  bool get isStraightLine {
    if (isP1Collapsed && isP2Collapsed) return true;
    final chord = p3 - p0;
    final scale = chord.length;
    if (scale < 1e-12) return false;

    final eps = 1e-9 * scale;
    return chord.cross(p1 - p0).abs() < eps && chord.cross(p2 - p0).abs() < eps;
  }

  CubicKnot2 get startKnot => .new(p0, cOut: isP1Collapsed ? null : p1);
  CubicKnot2 get endKnot => .new(p3, cIn: isP2Collapsed ? null : p2);

  Aabb2 get bbox => _cubicBbox(this);
  Aabb2 get bboxTight => _ffiCubicBboxTight(this);

  double? _arcLengthCache;
  double get _arcLength {
    // if (_arcLengthCache != null) return _arcLengthCache!;
    _arcLengthCache = _cubicArcLength(this);
    return _arcLengthCache!;
  }

  Vector2 point(double t) => _cubicEvaluate(this, t);
  Vector2 velocity(double t) => _cubicVelocity(this, t);
  Vector2 tangent(double t) => _cubicTangent(this, t);

  Vector2 pointAtDistance(double distance) => _cubicPointAtDistance(this, distance);
  Vector2 velocityAtDistance(double distance) => _cubicVelocityAtDistance(this, distance);
  Vector2 tangentAtDistance(double distance) => _cubicTangentAtDistance(this, distance);

  _CubicArcLengthIndex? _arcLengthIndexCache;
  _CubicArcLengthIndex get _arcLengthIndex {
    // if (_arcLengthIndexCache != null) return _arcLengthIndexCache!;
    _arcLengthIndexCache = .compute(this);
    return _arcLengthIndexCache!;
  }

  double tAtDistance(double distance) => _cubicTAtDistance(this, distance);
  double distanceAtT(double t) => _cubicDistanceAtT(this, t);

  double get arcLength => _arcLength;
  (Cubic2, Cubic2) split(double t) => _cubicSplit(this, t);
  List<Cubic2> splitMultiple(List<double> ts) => _cubicSplitMultiple(this, ts);

  // dart format off
  FlattenResult flatten({double? tolerance}) => _cubicFlattenWithResult(p0, p1, p2, p3, tolerance);
  void forEachSample(FlattenCallback callback, {double? tolerance}) => _cubicFlatten(p0, p1, p2, p3, tolerance, callback);
  void forEachSegment(FlattenSegmentsCallback callback, {double? tolerance}) => _cubicFlattenToSegments(p0, p1, p2, p3, tolerance, callback);

  Intersection? selfIntersect() => _cubicSelfIntersect(this);
  List<Intersection> intersectWith(Cubic2 other) => _cubicIntersect(this, other);
  List<Intersection> intersectWithSpline(CubicSpline2 other) => _splineCubicIntersect(other, this);
  List<Intersection> intersectWithCircle(Circle2 circle) => _cubicCircleIntersect(this, circle);
  // dart format on

  ClosestPointResult closestTo(Vector2 q) => _cubicClosestPoint(this, q);
  List<double> findInflections() => _cubicFindInflections(this);
  List<CubicToQuadResult> toQuads({double tolerance = 1.0}) => _cubicToQuads(this, tolerance: tolerance);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Cubic2) return false;
    return p0 == other.p0 && p1 == other.p1 && p2 == other.p2 && p3 == other.p3;
  }

  @override
  int get hashCode => Object.hash(p0, p1, p2, p3);
}
