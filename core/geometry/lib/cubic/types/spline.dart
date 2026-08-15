part of '../cubic.dart';

final class CubicSpline2 {
  CubicSpline2.view(this._storage) : p = ._(_storage), cIn = ._(_storage), cOut = ._(_storage);
  CubicSpline2.withCapacity(int capacity) : this.view(Vec2List(capacity * 3));
  CubicSpline2.sublistView(Vec2List data, {int start = 0, int? end})
    : this.view(
        .sublistView(
          data,
          start * 3,
          end != null ? end * 3 : null,
        ),
      );

  factory CubicSpline2.knots(Iterable<CubicKnot2> knots) {
    final spline = CubicSpline2.withCapacity(knots.length);
    var i = 0;
    for (final knot in knots) knot._writeToSplineStorage(spline._storage, i++);
    return spline;
  }

  factory CubicSpline2.cubics(List<Cubic2> cubics) {
    if (cubics.isEmpty) return .empty();
    final knotCount = cubics.length + 1;
    final storage = Vec2List(knotCount * 3);

    cubics.first.startKnot._writeToSplineStorage(storage, 0);
    for (var i = 0; i < cubics.length - 1; i++) {
      storage[(i + 1) * 3] = cubics[i].p3;
      storage[(i + 1) * 3 + 1] = cubics[i].p2;
      storage[(i + 1) * 3 + 2] = cubics[i + 1].p1;
    }
    cubics.last.endKnot._writeToSplineStorage(storage, cubics.length);
    return .view(storage);
  }

  factory CubicSpline2.line(Vec2 p0, Vec2 p1) {
    final spline = CubicSpline2.withCapacity(2);
    for (var i = 0; i < 3; i++) spline._storage[i] = p0;
    for (var i = 3; i < 6; i++) spline._storage[i] = p1;
    return spline;
  }

  factory CubicSpline2.empty() => .withCapacity(0);

  final Vec2List _storage;
  Vec2List get storage => _storage;

  int get length => _storage.length ~/ 3;
  bool get isEmpty => _storage.isEmpty;
  bool get isNotEmpty => _storage.isNotEmpty;

  final Spline2KnotPositions p;
  final Spline2CInPositions cIn;
  final Spline2COutPositions cOut;

  CubicKnot2 knot(int i) => .splineView(_storage, i);
  CubicKnot2 get first => knot(0);
  CubicKnot2 get last => knot(length - 1);
  (CubicKnot2, CubicKnot2) knotsAt(double t) => _splineKnotsAtParameter(this, t);
  Iterable<CubicKnot2> get knots => _splineKnots(this);

  int get segmentCount => length <= 1 ? 0 : length - 1;
  Cubic2 segment(int i) => _splineSegment(this, i);
  (Cubic2, double) segmentAt(double t) => _splineSegmentAtParameter(this, t);
  Iterable<Cubic2> get segments => _splineSegments(this);

  Vec2 point(double t) => _splineEvaluate(this, t);
  Vec2 velocity(double t) => _splineVelocity(this, t);
  Vec2 tangent(double t) => _splineTangent(this, t);

  (CubicSpline2, CubicSpline2) split(double t) => _splineSplit(this, t);
  List<CubicSpline2> splitMultiple(List<double> ts) => _splineSplitMultiple(this, ts);
  
  Aabb2 get bbox => _splineBbox(this);
  double get signedAreaIntegral => _splineSignedArea(this);
  ClosestPointResult closestPoint(Vec2 q) => _splineClosestPoint(this, q);

  int winding(Vec2 p) => _splineWinding(this, p);

  CubicSpline2 reversed() => _splineReversed(this);
  CubicSpline2 join(CubicSpline2 other) => _splineJoin(this, other);

  CubicSpline2 copy() => .view(.fromList(_storage));
}

extension type Spline2KnotPositions._(Vec2List storage) {
  @pragma('vm:prefer-inline')
  Vec2 operator [](int i) => storage[i * 3];

  @pragma('vm:prefer-inline')
  void operator []=(int i, Vec2 value) => storage[i * 3] = value;
}

extension type Spline2CInPositions._(Vec2List storage) {
  @pragma('vm:prefer-inline')
  Vec2 operator [](int i) => storage[i * 3 + 1];

  @pragma('vm:prefer-inline')
  void operator []=(int i, Vec2 value) => storage[i * 3 + 1] = value;
}

extension type Spline2COutPositions._(Vec2List storage) {
  @pragma('vm:prefer-inline')
  Vec2 operator [](int i) => storage[i * 3 + 2];

  @pragma('vm:prefer-inline')
  void operator []=(int i, Vec2 value) => storage[i * 3 + 2] = value;
}
