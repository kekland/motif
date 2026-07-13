part of '../../core.dart';

List<EdgeKnot> _copyKnotList(List<CubicKnot2> knots) => knots.map(EdgeKnot.from).toList();

class EdgePath extends CubicSpline2 {
  EdgePath(List<CubicKnot2> knots, {this._rawStrokePoints}) : super(_copyKnotList(knots)) {
    for (final k in this.knots) k._path = this;
  }

  EdgePath.spline(CubicSpline2 spline, {List<StrokePoint>? rawStrokePoints})
    : this(spline.knots, rawStrokePoints: rawStrokePoints);

  Edge? _edge;
  // void _markNeedsLayout() {
  //   _rawStrokePoints = null;
  //   _edge?._markNeedsLayout();
  // }

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
}
