part of '../../core.dart';

List<EdgeKnot> _copyKnotList(List<CubicKnot2> knots) => knots.map(EdgeKnot.from).toList();

final class EdgePath extends CubicSpline2 {
  EdgePath(List<CubicKnot2> knots, {this._rawStrokePoints}) : super(_copyKnotList(knots));

  EdgePath.from(CubicSpline2 spline, {List<StrokePoint>? rawStrokePoints})
    : this(spline.knots, rawStrokePoints: rawStrokePoints);

  EdgePath.fromCubic(Cubic2 cubic, {List<StrokePoint>? rawStrokePoints})
    : this([cubic.startKnot, cubic.endKnot], rawStrokePoints: rawStrokePoints);

  Edge? _edge;
  void _setEdge(Edge edge) {
    if (_edge == edge) return;
    _edge = edge;
    edge._addChildren(knots);
  }

  List<StrokePoint>? get rawStrokePoints => _rawStrokePoints;
  List<StrokePoint>? _rawStrokePoints;

  // dart format off
  @override set knots(List<CubicKnot2> value) {
    if (knots.length == value.length) {
      for (var i = 0; i < knots.length; i++) knot(i).setFrom(value[i]);
      return;
    }

    for (final k in knots) k.detach();
    super.knots = _copyKnotList(value);
    _edge?._addChildren(knots);
  }

  @override List<EdgeKnot> get knots => super.knots.cast<EdgeKnot>();
  @override EdgeKnot knot(int i) => super.knot(i) as EdgeKnot;
  @override EdgePath copy() => .new(_copyKnotList(knots));
  @override EdgeKnot get first => knot(0);
  @override EdgeKnot get last => knot(length - 1);
  // dart format on

  @override
  (EdgePath, EdgePath) split(double t) {
    final (left, right) = super.split(t);
    return (.from(left), .from(right));
  }

  @override
  List<EdgePath> splitMultiple(List<double> ts) => super.splitMultiple(ts).map(EdgePath.from).toList();

  void transformWith(Matrix4 transform) {
    for (final k in knots) k.transformWith(transform);
  }

  void setFrom(EdgePath other) {
    if (knots.length != other.knots.length) {
      knots = _copyKnotList(other.knots);
    } else {
      for (var i = 0; i < knots.length; i++) {
        knot(i).setFrom(other.knot(i));
      }
    }
  }

  void layout() {
    for (final k in knots) k.layout(.new());
  }

  EdgePathSnapshot snapshot() => .new(knots: knots.map((k) => k.snapshot()).toList(), rawStrokePoints: rawStrokePoints);
  void applySnapshot(EdgePathSnapshot snapshot) {
    if (knots.length == snapshot.knots.length) {
      for (var i = 0; i < knots.length; i++) {
        knot(i).applySnapshot(snapshot.knots[i]);
      }
    } else {
      knots = snapshot.knots.map((k) => EdgeKnot.fromSnapshot(k)).toList();
    }

    _rawStrokePoints = snapshot.rawStrokePoints;
  }
}

class EdgePathSnapshot {
  const EdgePathSnapshot({
    required this.knots,
    required this.rawStrokePoints,
  });

  final List<EdgeKnotSnapshot> knots;
  final List<StrokePoint>? rawStrokePoints;
}
