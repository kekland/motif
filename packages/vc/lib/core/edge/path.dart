part of '../core.dart';

abstract class EdgeKnotControlPoint extends Vector2 with Selectable {
  EdgeKnotControlPoint.zero() : super.zero();

  bool get isIn;

  @override
  void setFrom(Vector2 other) {
    super.setFrom(other);
    _markAsDirty();
  }

  EdgeKnot? _knot;
  Edge? get _edge => _knot?._edge;
  VectorComplex? get _complex => _knot?._complex;
  void _markAsDirty() => _knot?._markAsDirty();

  @override
  ReadonlySignal<Edge> call() => _complex!._signalFor(_edge!);
}

class EdgeKnotInControlPoint extends EdgeKnotControlPoint {
  EdgeKnotInControlPoint.zero() : super.zero();
  factory EdgeKnotInControlPoint(double x, double y) => .zero()..setValues(x, y);
  factory EdgeKnotInControlPoint.from(Vector2 v) => .zero()..setFrom(v);

  @override
  bool get isIn => true;
}

class EdgeKnotOutControlPoint extends EdgeKnotControlPoint {
  EdgeKnotOutControlPoint.zero() : super.zero();
  factory EdgeKnotOutControlPoint(double x, double y) => .zero()..setValues(x, y);
  factory EdgeKnotOutControlPoint.from(Vector2 v) => .zero()..setFrom(v);

  @override
  bool get isIn => false;
}

class EdgeKnot extends CubicKnot2 with Selectable {
  EdgeKnot(super.p, {Vector2? cIn, Vector2? cOut})
    : super(
        cIn: cIn != null ? EdgeKnotInControlPoint.from(cIn) : null,
        cOut: cOut != null ? EdgeKnotOutControlPoint.from(cOut) : null,
      );

  EdgeKnot.from(CubicKnot2 k) : this(k.p.clone(), cIn: k.cIn?.clone(), cOut: k.cOut?.clone());

  EdgePath? _path;
  Edge? get _edge => _path?._edge;
  VectorComplex? get _complex => _edge?._complex;
  void _markAsDirty() => _path?._markAsDirty();

  @override
  set p(Vector2 p) {
    if (super.p == p) return;
    super.p.setFrom(p);
    _markAsDirty();
  }

  @override
  EdgeKnotInControlPoint? get cIn => super.cIn as EdgeKnotInControlPoint?;

  @override
  set cIn(Vector2? cIn) {
    if (super.cIn == cIn) return;

    if (cIn == null) {
      super.cIn = null;
    } else {
      super.cIn ??= EdgeKnotInControlPoint.zero();
      super.cIn!.setFrom(cIn);
    }

    _markAsDirty();
  }

  @override
  EdgeKnotOutControlPoint? get cOut => super.cOut as EdgeKnotOutControlPoint?;

  @override
  set cOut(Vector2? cOut) {
    if (super.cOut == cOut) return;

    if (cOut == null) {
      super.cOut = null;
    } else {
      super.cOut ??= EdgeKnotOutControlPoint.zero();
      super.cOut!.setFrom(cOut);
    }

    _markAsDirty();
  }

  void shift(Vector2 delta) {
    super.p += delta;
    if (cIn != null) super.cIn = super.cIn! + delta;
    if (cOut != null) super.cOut = super.cOut! + delta;
    _markAsDirty();
  }

  void setFrom(CubicKnot2 k) {
    super.p.setFrom(k.p);
    cIn = k.cIn;
    cOut = k.cOut;
    _markAsDirty();
  }

  @override
  ReadonlySignal<Edge> call() => _complex!._signalFor(_edge!);
}

List<EdgeKnot> _copyKnotList(List<CubicKnot2> knots) => knots.map((k) => EdgeKnot.from(k)).toList();

class EdgePath extends CubicSpline2 with EdgeProperty<EdgePath> {
  EdgePath(List<CubicKnot2> knots, {this._rawStrokePoints}) : super(_copyKnotList(knots)) {
    for (final k in this.knots) k._path = this;
  }

  EdgePath.spline(CubicSpline2 spline, {List<StrokePoint>? rawStrokePoints})
    : this(spline.knots, rawStrokePoints: rawStrokePoints);

  Edge? _edge;
  void _markAsDirty() {
    _rawStrokePoints = null;
    _edge?._markAsDirty();
  }

  List<StrokePoint>? get rawStrokePoints => _rawStrokePoints;
  List<StrokePoint>? _rawStrokePoints;

  // dart format off
  @override List<EdgeKnot> get knots => super.knots.cast<EdgeKnot>();
  @override EdgeKnot knot(int i) => super.knot(i) as EdgeKnot;
  @override EdgePath copy() => .new(_copyKnotList(knots));
  @override EdgeKnot get first => knot(0);
  @override EdgeKnot get last => knot(length - 1);
  EdgePath copyWith({List<CubicKnot2>? knots}) => .new(_copyKnotList(knots ?? this.knots));
  // dart format on

  @override
  (EdgePath, EdgePath) split(double t) {
    final (left, right) = super.split(t);
    return (.spline(left), .spline(right));
  }

  @override
  List<EdgePath> splitMultiple(List<double> ts) => super.splitMultiple(ts).map(EdgePath.spline).toList();

  CubicSpline2 deflate() => .new(knots.copy());
}
