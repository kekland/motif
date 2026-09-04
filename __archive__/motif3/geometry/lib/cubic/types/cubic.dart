part of '../cubic.dart';

sealed class Cubic2 {
  Cubic2._();
  factory Cubic2(Vec2 p0, Vec2 p3, {Vec2? p1, Vec2? p2}) = RegularCubic2;
  factory Cubic2.line(Vec2 p0, Vec2 p3) = RegularCubic2.line;
  factory Cubic2.view(Vec2List storage) = RegularCubic2.from;
  factory Cubic2.splineView(Vec2List data, int i) = SplineCubic2View;
  factory Cubic2.empty() = RegularCubic2.empty;

  Vec2 get p0;
  Vec2 get p1;
  Vec2 get p2;
  Vec2 get p3;

  set p0(Vec2 value);
  set p1(Vec2 value);
  set p2(Vec2 value);
  set p3(Vec2 value);

  CubicKnot2 get startKnot;
  CubicKnot2 get endKnot;

  bool get isP1Collapsed => p0.equals(p1);
  bool get isP2Collapsed => p2.equals(p3);
  bool get isStraightLine {
    if (isP1Collapsed && isP2Collapsed) return true;
    final chord = p3 - p0;
    final scale = chord.length;
    if (scale < 1e-12) return false;

    final eps = 1e-9 * scale;
    return chord.cross(p1 - p0).abs() < eps && chord.cross(p2 - p0).abs() < eps;
  }

  Vec2 point(double t) => _cubicEvaluate(this, t);
  Vec2 velocity(double t) => _cubicVelocity(this, t);
  Vec2 tangent(double t) => _cubicTangent(this, t);

  (Cubic2, Cubic2) split(double t) => _cubicSplit(this, t);
  List<Cubic2> splitMultiple(List<double> ts) => _cubicSplitMultiple(this, ts);

  List<double> get extrema => _cubicExtrema(this);
  List<Cubic2> get monotonePieces => _cubicMonotonePieces(this);

  Aabb2 get bbox => _cubicBbox(this);
  Aabb2 get bboxTight => _cubicBboxTight(this);
  double get signedAreaIntegral => _cubicSignedArea(this);
  ClosestPointResult closestPoint(Vec2 q) => _cubicClosestPoint(this, q);

  double get arcLength => _cubicArcLength(this);
  double arcLengthBetween(double t0, double t1) => _cubicArcLength(this, t0, t1);
  double distanceAtT(double t) => _cubicDistanceAtT(this, t);
  double tAtDistance(double distance) => _cubicTAtDistance(this, distance);

  int winding(Vec2 p) => _cubicWinding(this, p);

  bool containedInAabb(Aabb2 bbox) => _cubicContainedInAabb(this, bbox);
  bool intersectsAabb(Aabb2 bbox) => _cubicIntersectsAabb(this, bbox);

  Cubic2 reversed() => _cubicReversed(this);
  Cubic2 transformed(Mat4 m) => _cubicTransformed(this, m);

  Cubic2 copy() => .new(p0, p3, p1: p1, p2: p2);
}

final class SplineCubic2View extends Cubic2 {
  SplineCubic2View(Vec2List data, int i) : _storage = .sublistView(data, i * 3, (i + 2) * 3), super._();

  final Vec2List _storage;

  // dart format off 
  @override Vec2 get p0 => _storage[0]; // k0.p
  @override Vec2 get p1 => _storage[2]; // k0.cOut
  @override Vec2 get p2 => _storage[4]; // k1.cIn
  @override Vec2 get p3 => _storage[3]; // k1.p

  @override set p0(Vec2 value) => _storage[0] = value;
  @override set p1(Vec2 value) => _storage[2] = value;
  @override set p2(Vec2 value) => _storage[4] = value;
  @override set p3(Vec2 value) => _storage[3] = value;
  
  @override CubicKnot2 get startKnot => .splineView(_storage, 0);
  @override CubicKnot2 get endKnot => .splineView(_storage, 1);
  // dart format on
}

final class RegularCubic2 extends Cubic2 {
  RegularCubic2(Vec2 p0, Vec2 p3, {Vec2? p1, Vec2? p2}) : _storage = Vec2List(4), super._() {
    _storage[0] = p0;
    _storage[1] = p1 ?? p0;
    _storage[2] = p2 ?? p3;
    _storage[3] = p3;
  }

  RegularCubic2.line(Vec2 p0, Vec2 p3)
    : this(
        p0,
        p3,
        p1: p0 + (p3 - p0).scale(1 / 3),
        p2: p0 + (p3 - p0).scale(2 / 3),
      );

  RegularCubic2.empty() : _storage = Vec2List(4), super._();
  RegularCubic2.from(this._storage) : super._();

  final Vec2List _storage;

  // dart format off
  @override Vec2 get p0 => _storage[0];
  @override Vec2 get p1 => _storage[1];
  @override Vec2 get p2 => _storage[2];
  @override Vec2 get p3 => _storage[3];

  @override set p0(Vec2 value) => _storage[0] = value;
  @override set p1(Vec2 value) => _storage[1] = value;
  @override set p2(Vec2 value) => _storage[2] = value;
  @override set p3(Vec2 value) => _storage[3] = value;

  @override CubicKnot2 get startKnot => .cubicView(_storage, true);
  @override CubicKnot2 get endKnot => .cubicView(_storage, false);
  // dart format on
}
