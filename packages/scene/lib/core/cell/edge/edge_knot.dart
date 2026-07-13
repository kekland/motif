part of '../../core.dart';

sealed class EdgeKnotControlPoint extends Vector2 with SceneNodeImpl implements SceneNode {
  EdgeKnotControlPoint.zero({NodeId? id}) : id = id ?? .generate(), super.zero();

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
  void applyTransform(Matrix4 transform) {}

  @override
  bool hitTest(SceneHitTestResult result, Vector2 localPosition, {Matrix4? globalToScene}) => false;

  @override
  bool hitTestSelf(Vector2 localPosition, {Matrix4? globalToScene}) => false;

  @override
  bool hitTestRect(SceneHitTestResult result, Aabb2 localRect, {RectHitTestMode mode = .normal}) => false;
}

final class EdgeKnotInControlPoint extends EdgeKnotControlPoint {
  EdgeKnotInControlPoint.zero({super.id}) : super.zero();
  factory EdgeKnotInControlPoint(double x, double y) => .zero()..setValues(x, y);
  factory EdgeKnotInControlPoint.from(Vector2 other) => .zero()..setValues(other.x, other.y);

  @override
  bool get isIn => true;
}

final class EdgeKnotOutControlPoint extends EdgeKnotControlPoint {
  EdgeKnotOutControlPoint.zero({super.id}) : super.zero();
  factory EdgeKnotOutControlPoint(double x, double y) => .zero()..setValues(x, y);
  factory EdgeKnotOutControlPoint.from(Vector2 other) => .zero()..setValues(other.x, other.y);

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

  @override
  final NodeId id;

  // dart format off
  @override EdgeKnotInControlPoint get cIn => super.cIn as EdgeKnotInControlPoint;
  @override EdgeKnotOutControlPoint get cOut => super.cOut as EdgeKnotOutControlPoint;
  // dart format on

  @override
  Edge get parent => super.parent as Edge;

  @override
  Edge get owner => parent;

  @override
  set p(Vector2 p) {
    if (super.p == p) return;
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

  // void applyTransform(Matrix4 transform) {
  //   p = transform.transform2(p);
  //   cIn = transform.transform2(cIn);
  //   cOut = transform.transform2(cOut);
  // }

  void setFrom(EdgeKnot other) {
    p = other.p;
    cIn = other.cIn;
    cOut = other.cOut;
  }

  @override
  Aabb2 get boundingBox => bbox;

  @override
  void applyTransform(Matrix4 transform) {
    // p = transform.transform2(p);
    // cIn = transform.transform2(cIn);
    // cOut = transform.transform2(cOut);
  }

  @override
  bool hitTest(SceneHitTestResult result, Vector2 localPosition, {Matrix4? globalToScene}) => false;

  @override
  bool hitTestSelf(Vector2 localPosition, {Matrix4? globalToScene}) => false;

  @override
  bool hitTestRect(SceneHitTestResult result, Aabb2 localRect, {RectHitTestMode mode = .normal}) => false;
}
