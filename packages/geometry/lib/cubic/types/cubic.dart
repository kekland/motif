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
  bool get isStraightLine => isP1Collapsed && isP2Collapsed;

  CubicKnot2 get startKnot => .new(p0, cOut: p1);
  CubicKnot2 get endKnot => .new(p3, cIn: p2);

  Aabb2 get bboxCheap => _cubicBboxCheap(this);

  Vector2 evaluate(double t) => _cubicEvaluate(this, t);
  Vector2 velocity(double t) => _cubicVelocity(this, t);
  Vector2 tangent(double t) => _cubicTangent(this, t);

  double arcLength({double? tolerance}) => _cubicArcLength(this, tolerance: tolerance);
  (Cubic2, Cubic2) split(double t) => _cubicSplit(this, t);
  List<Cubic2> splitMultiple(List<double> ts) => _cubicSplitMultiple(this, ts);

  FlattenResult flatten({double? tolerance}) => _cubicFlattenWithResult(p0, p1, p2, p3, tolerance);

  void forEachSample(FlattenCallback callback, {double? tolerance}) =>
      _cubicFlatten(p0, p1, p2, p3, tolerance, callback);
  void forEachSegment(FlattenSegmentsCallback callback, {double? tolerance}) =>
      _cubicFlattenToSegments(p0, p1, p2, p3, tolerance, callback);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Cubic2) return false;
    return p0 == other.p0 && p1 == other.p1 && p2 == other.p2 && p3 == other.p3;
  }

  @override
  int get hashCode => Object.hash(p0, p1, p2, p3);
}
