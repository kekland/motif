part of '../../core.dart';

abstract class EdgeKnotControlPoint extends Vector2 implements SelectableObject {
  EdgeKnotControlPoint.zero() : super.zero();

  bool get isIn;
  bool get isOut => !isIn;

  @override
  void setFrom(Vector2 other) {
    super.setFrom(other);
    _markNeedsLayout();
  }

  EdgeKnot? _knot;
  Edge? get _edge => _knot?._edge;
  void _markNeedsLayout() => _edge?._markNeedsLayout();

  @override
  Aabb2 get bbox => .centerAndHalfExtents(this, .zero());

  @override
  int get depth => _edge!.depth;

  @override
  SceneObject get sceneObject => _edge!;

  @override
  bool isAncestorOf(SelectableObject object) => false;

  @override
  bool isDescendantOf(SelectableObject object) => object == _knot || object == _edge || _edge!.isDescendantOf(object);

  @override
  ReadonlySignal<Edge> call() => _edge!();
}

class EdgeKnotInControlPoint extends EdgeKnotControlPoint {
  EdgeKnotInControlPoint.zero() : super.zero();
  factory EdgeKnotInControlPoint(double x, double y) => .zero()..setValues(x, y);
  factory EdgeKnotInControlPoint.from(Vector2 other) => .zero()..setFrom(other);

  @override
  bool get isIn => true;
}

class EdgeKnotOutControlPoint extends EdgeKnotControlPoint {
  EdgeKnotOutControlPoint.zero() : super.zero();
  factory EdgeKnotOutControlPoint(double x, double y) => .zero()..setValues(x, y);
  factory EdgeKnotOutControlPoint.from(Vector2 other) => .zero()..setFrom(other);

  @override
  bool get isIn => false;
}

class EdgeKnot extends CubicKnot2 implements SelectableObject {
  EdgeKnot(super.p, {Vector2? cIn, Vector2? cOut})
    : super(
        cIn: cIn != null ? EdgeKnotInControlPoint.from(cIn) : null,
        cOut: cOut != null ? EdgeKnotOutControlPoint.from(cOut) : null,
      ) {
    this.cIn?._knot = this;
    this.cOut?._knot = this;
  }

  EdgeKnot.from(CubicKnot2 k) : this(k.p.clone(), cIn: k.cIn?.clone(), cOut: k.cOut?.clone());

  EdgePath? _path;
  Edge? get _edge => _path?._edge;
  void _markNeedsLayout() => _edge?._markNeedsLayout();

  @override
  EdgeKnotInControlPoint? get cIn => super.cIn as EdgeKnotInControlPoint?;

  @override
  EdgeKnotOutControlPoint? get cOut => super.cOut as EdgeKnotOutControlPoint?;

  @override
  set p(Vector2 p) {
    if (super.p == p) return;
    super.p.setFrom(p);
    _markNeedsLayout();
  }

  @override
  set cIn(Vector2? cIn) {
    if (super.cIn == cIn) return;

    if (cIn == null) {
      super.cIn = null;
    } else {
      super.cIn ??= EdgeKnotInControlPoint.zero();
      super.cIn!.setFrom(cIn);
    }

    _markNeedsLayout();
  }

  @override
  set cOut(Vector2? cOut) {
    if (super.cOut == cOut) return;

    if (cOut == null) {
      super.cOut = null;
    } else {
      super.cOut ??= EdgeKnotOutControlPoint.zero();
      super.cOut!.setFrom(cOut);
    }

    _markNeedsLayout();
  }

  void setFrom(CubicKnot2 k) {
    super.p.setFrom(k.p);
    cIn = k.cIn;
    cOut = k.cOut;
    _markNeedsLayout();
  }

  @override
  int get depth => throw UnimplementedError();

  @override
  bool isAncestorOf(SelectableObject object) => object == cIn || object == cOut;

  @override
  bool isDescendantOf(SelectableObject object) => object == _edge || _edge!.isDescendantOf(object);

  @override
  SceneObject get sceneObject => _edge!;

  @override
  ReadonlySignal<Edge> call() => _edge!();
}
