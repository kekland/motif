part of '../../core.dart';

List<EdgeKnot> _copyKnotList(List<CubicKnot2> knots) => knots.map(EdgeKnot.from).toList();

final class EdgePath extends CubicSpline2 {
  EdgePath(List<CubicKnot2> knots, {this._rawStrokePoints}) : super(_copyKnotList(knots));

  EdgePath.from(CubicSpline2 spline, {List<StrokePoint>? rawStrokePoints})
    : this(spline.knots, rawStrokePoints: rawStrokePoints);

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

  void applyTransform(Matrix4 transform) {
    for (final k in knots) {
      k.applyTransform(transform);
    }
  }

  void setFrom(EdgePath other) {
    if (knots.length != other.knots.length) {
      knots = _copyKnotList(other.knots);
    }
    else {
      for (var i = 0; i < knots.length; i++) {
        knot(i).setFrom(other.knot(i));
      }
    }
  }
}
