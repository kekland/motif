import 'dart:math' as math;
import 'dart:typed_data';

import 'package:geometry/geometry.dart';

part 'algorithms/bernstein.dart';
part 'algorithms/de_casteljau.dart';

part 'methods/area.dart';
part 'methods/bbox.dart';
part 'methods/closest_point.dart';
part 'methods/copy.dart';
part 'methods/extrema.dart';
part 'methods/evaluate.dart';
part 'methods/split.dart';
part 'methods/utils.dart';
part 'methods/winding.dart';
part 'methods/arc_length.dart';

extension type const Cubic2._(Vec2List storage) implements Object {
  Cubic2.zero() : storage = .new(4);

  Cubic2(Vec2 p0, Vec2 p3, {Vec2? p1, Vec2? p2}) : storage = .new(4) {
    storage[0] = p0;
    storage[1] = p1 ?? p0;
    storage[2] = p2 ?? p3;
    storage[3] = p3;
  }

  Cubic2.line(Vec2 p0, Vec2 p3) : this(p0, p3, p1: p0 + (p3 - p0).scale(1 / 3), p2: p0 + (p3 - p0).scale(2 / 3));

  Cubic2.view(Vec2List storage) : storage = storage;

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

  Vec2 get p0 => storage[0];
  Vec2 get p1 => storage[1];
  Vec2 get p2 => storage[2];
  Vec2 get p3 => storage[3];

  set p0(Vec2 v) => storage[0] = v;
  set p1(Vec2 v) => storage[1] = v;
  set p2(Vec2 v) => storage[2] = v;
  set p3(Vec2 v) => storage[3] = v;

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

  CubicArcIndex get arcIndex => .of(this);

  double get arcLength => arcIndex.length;
  double arcLengthBetween(double t0, double t1) => arcIndex.distanceBetween(t0, t1);
  double distanceAtT(double t) => arcIndex.distanceAt(t);
  double tAtDistance(double distance) => arcIndex.tAt(distance);

  int winding(Vec2 p) => _cubicWinding(this, p);

  bool containedInAabb(Aabb2 bbox) => _cubicContainedInAabb(this, bbox);
  bool intersectsAabb(Aabb2 bbox) => _cubicIntersectsAabb(this, bbox);

  void reverse() => _cubicReverse(this);
  void transform(Mat4 m) => _cubicTransform(this, m);
  Cubic2 reversed() => copy()..reverse();
  Cubic2 transformed(Mat4 m) => copy()..transform(m);

  Cubic2 copy() => .new(p0, p3, p1: p1, p2: p2);
}
