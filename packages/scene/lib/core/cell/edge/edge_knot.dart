part of '../../core.dart';

sealed class EdgeKnotControlPoint extends Vector2 with SceneNodeImpl implements SceneNode {
  EdgeKnotControlPoint.zero({NodeId? id}) : id = id ?? .generate(), super.zero();
  EdgeKnotControlPoint.fromSnapshot(EdgeKnotControlPointSnapshot snapshot) : id = snapshot.id, super.zero() {
    setFrom(snapshot.position);
  }

  @override
  final NodeId id;

  @override
  EdgeKnot get parent => super.parent as EdgeKnot;
  Edge get edge => parent.parent;

  @override
  EdgeKnot get owner => parent;

  bool get isIn;
  bool get isOut => !isIn;

  @override
  void setFrom(Vector2 other) {
    super.setFrom(other);
    _markNeedsLayout();
  }

  @override
  ReadonlySignal<EdgeKnotControlPoint> call() => _scene!._signalFor(this);

  @override
  Aabb2 get boundingBox => .minMax(this, this);

  @override
  bool get isLayoutBoundary => false;

  @override
  ResolvedSize get resolvedSize => .zero;

  @override
  void transformWith(Matrix4 transform) {
    setFrom(transform.transform2(this));
  }

  @override
  bool hitTest(SceneHitTestResult result, Vector2 localPosition, {Matrix4? globalToScene}) => false;

  @override
  bool hitTestSelf(Vector2 localPosition, {Matrix4? globalToScene}) => false;

  @override
  bool hitTestRect(SceneHitTestResult result, Aabb2 localRect, {HitTestRectMode mode = .normal}) => false;

  @override
  String toString() => '${super.toString()}{$x, $y}';

  @override
  EdgeKnotControlPointSnapshot snapshot() => .new(id: id, position: clone());

  @override
  void applySnapshot(EdgeKnotControlPointSnapshot snapshot) => setFrom(snapshot.position);
}

final class EdgeKnotInControlPoint extends EdgeKnotControlPoint {
  EdgeKnotInControlPoint.zero({super.id}) : super.zero();
  factory EdgeKnotInControlPoint(double x, double y) => .zero()..setValues(x, y);
  factory EdgeKnotInControlPoint.from(Vector2 other) => .zero()..setValues(other.x, other.y);
  EdgeKnotInControlPoint.fromSnapshot(super.snapshot) : super.fromSnapshot();

  @override
  bool get isIn => true;
}

final class EdgeKnotOutControlPoint extends EdgeKnotControlPoint {
  EdgeKnotOutControlPoint.zero({super.id}) : super.zero();
  factory EdgeKnotOutControlPoint(double x, double y) => .zero()..setValues(x, y);
  factory EdgeKnotOutControlPoint.from(Vector2 other) => .zero()..setValues(other.x, other.y);
  EdgeKnotOutControlPoint.fromSnapshot(super.snapshot) : super.fromSnapshot();

  @override
  bool get isIn => false;
}

final class EdgeKnot extends CubicKnot2 with SceneNodeImpl implements SceneNode {
  EdgeKnot(super.p, {Vector2? cIn, Vector2? cOut, NodeId? id})
    : id = id ?? .generate(),
      super(
        cIn: EdgeKnotInControlPoint.from(cIn ?? p),
        cOut: EdgeKnotOutControlPoint.from(cOut ?? p),
      ) {
    _addChildren([this.cIn, this.cOut]);
  }

  EdgeKnot.from(CubicKnot2 k) : this(k.p.clone(), cIn: k.cIn.clone(), cOut: k.cOut.clone());
  EdgeKnot.fromSnapshot(EdgeKnotSnapshot snapshot)
    : id = snapshot.id,
      super(
        snapshot.position.clone(),
        cIn: EdgeKnotInControlPoint.fromSnapshot(snapshot.cIn),
        cOut: EdgeKnotOutControlPoint.fromSnapshot(snapshot.cOut),
      ) {
    _addChildren([cIn, cOut]);
  }

  @override
  final NodeId id;

  // dart format off
  @override EdgeKnotInControlPoint get cIn => super.cIn as EdgeKnotInControlPoint;
  @override EdgeKnotOutControlPoint get cOut => super.cOut as EdgeKnotOutControlPoint;
  // dart format on

  @override
  bool get isLayoutBoundary => false;

  @override
  Edge get parent => super.parent as Edge;

  @override
  Edge get owner => parent;

  @override
  ResolvedSize get resolvedSize => .zero;

  @override
  set p(Vector2 p) {
    if (super.p == p) return;
    if (cIn == super.p) cIn.setFrom(p);
    if (cOut == super.p) cOut.setFrom(p);

    super.p.setFrom(p);
    _markNeedsLayout();
  }

  @override
  set cIn(Vector2? cIn) {
    if (super.cIn == cIn) return;
    this.cIn.setFrom(cIn ?? p);
    _markNeedsLayout();
  }

  @override
  set cOut(Vector2? cOut) {
    if (super.cOut == cOut) return;
    this.cOut.setFrom(cOut ?? p);
    _markNeedsLayout();
  }

  @override
  void layout(LayoutConstraints constraints) {
    cIn.layout(constraints);
    cOut.layout(constraints);
  }

  void setFrom(CubicKnot2 other) {
    p = other.p;
    cIn = other.cIn;
    cOut = other.cOut;
  }

  @override
  Aabb2 get boundingBox => bbox;

  @override
  void transformWith(Matrix4 transform) {
    if (super.p != cIn) cIn.transformWith(transform);
    if (super.p != cOut) cOut.transformWith(transform);
    p = transform.transform2(p);
  }

  @override
  bool hitTest(SceneHitTestResult result, Vector2 localPosition, {Matrix4? globalToScene}) => false;

  @override
  bool hitTestSelf(Vector2 localPosition, {Matrix4? globalToScene}) => false;

  @override
  bool hitTestRect(SceneHitTestResult result, Aabb2 localRect, {HitTestRectMode mode = .normal}) => false;

  @override
  String toString() => '${super.toString()} $p (${cIn.x}, ${cIn.y}) (${cOut.x}, ${cOut.y})';

  @override
  EdgeKnotSnapshot snapshot() => .new(id: id, position: p.clone(), cIn: cIn.snapshot(), cOut: cOut.snapshot());

  @override
  void applySnapshot(EdgeKnotSnapshot snapshot) {
    p = snapshot.position;
    cIn.applySnapshot(snapshot.cIn);
    cOut.applySnapshot(snapshot.cOut);
  }
}

class EdgeKnotControlPointSnapshot extends NodeSnapshot {
  const EdgeKnotControlPointSnapshot({required super.id, required this.position});

  final Vector2 position;
}

class EdgeKnotSnapshot extends NodeSnapshot {
  const EdgeKnotSnapshot({required super.id, required this.position, required this.cIn, required this.cOut});

  final Vector2 position;
  final EdgeKnotControlPointSnapshot cIn;
  final EdgeKnotControlPointSnapshot cOut;
}
