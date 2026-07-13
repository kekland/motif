part of '../vector_complex.dart';

/// An edge is a topological unit that represents:
///
/// - A curve connecting two vertices (open edge)
/// - A loop curve with no connections (closed edge)
///
/// Geometrically, an edge is a curve in the plane. The curve is represented by a [CubicSpline2] (a sequence of cubics).
sealed class Edge extends Cell {
  Edge({
    super.id,
    super.complex,
    StrokeWeightParameterProfile? strokeWeight,
    ColorData? color,
    double? strokeWidth,
  }) : _strokeWeight = strokeWeight ?? StrokeWeightParameterProfile.from([(x: 0.0, v: 1.0), (x: 1.0, v: 1.0)]),
       _color = color ?? .white,
       _strokeWidth = strokeWidth ?? 1.0;

  CubicSpline2 get spline;

  StrokeWeightParameterProfile _strokeWeight;
  StrokeWeightParameterProfile get strokeWeight => _strokeWeight;
  set strokeWeight(StrokeWeightParameterProfile p) {
    if (_strokeWeight == p) return;
    _strokeWeight = p;
    complex?.notifyFor(this);
  }

  ColorData _color;
  ColorData get color => _color;
  set color(ColorData c) {
    if (_color == c) return;
    _color = c;
    complex?.notifyFor(this);
  }

  double _strokeWidth;
  double get strokeWidth => _strokeWidth;
  set strokeWidth(double w) {
    if (_strokeWidth == w) return;
    _strokeWidth = w;
    complex?.notifyFor(this);
  }
}

/// An open edge is a curve connecting two vertices.
///
/// Geometrically, it's represented by a cubic spline that:
/// - starts at the position of the `start` vertex with a tangent defined by `c1`
/// - continues with a list of knots
/// - ends at the position of the `end` vertex with a tangent defined by `c2`
final class OpenEdge extends Edge {
  OpenEdge(
    this._start,
    this._end, {
    this.cStart,
    this.cEnd,
    List<CubicKnot2>? interior,
    super.id,
    super.complex,
    super.strokeWeight,
    super.strokeWidth,
    super.color,
  }) : interior = interior ?? [] {
    _start._directStar.add(this);
    _end._directStar.add(this);
  }

  factory OpenEdge.fromSpline(
    Vertex start,
    Vertex end,
    CubicSpline2 spline, {
    String? id,
    VectorComplex? complex,
    StrokeWeightParameterProfile? strokeWeight,
    double? strokeWidth,
    ColorData? color,
  }) {
    final firstKnotPosition = spline.knots.first.p;
    final lastKnotPosition = spline.knots.last.p;

    const eps = 1e-4;
    if (firstKnotPosition.distanceTo(start.position) > eps || lastKnotPosition.distanceTo(end.position) > eps) {
      throw ArgumentError(
        'start and end vertices must match the positions of the first and last knots of the spline.',
      );
    }

    var cStart = spline.knots.first.cOut;
    var cEnd = spline.knots.last.cIn;
    final interior = spline.knots.sublist(1, spline.knots.length - 1).map((k) => k.copy()).toList();

    if (interior.isEmpty && (cStart != null || cEnd != null)) {
      // Check for collinear control points
      final cubic = Cubic2(start.position, end.position, p1: cStart, p2: cEnd);
      if (cubic.isStraightLine) {
        cStart = null;
        cEnd = null;
      }
    }

    return OpenEdge(
      start,
      end,
      cStart: cStart,
      cEnd: cEnd,
      interior: interior,
      id: id,
      complex: complex,
      strokeWeight: strokeWeight,
      strokeWidth: strokeWidth,
      color: color,
    );
  }

  Vertex _start;
  Vertex get start => _start;
  set start(Vertex v) {
    _start._directStar.remove(this);
    _start = v;
    _start._directStar.add(this);
  }

  Vertex _end;
  Vertex get end => _end;
  set end(Vertex v) {
    _end._directStar.remove(this);
    _end = v;
    _end._directStar.add(this);
  }

  Vector2? cStart;
  Vector2? cEnd;
  List<CubicKnot2> interior;

  @override
  CubicSpline2 get spline => .new([
    _EdgeVertexKnot(this, true, start.position, cOut: cStart),
    ...interior,
    _EdgeVertexKnot(this, false, end.position, cIn: cEnd),
  ]);

  @override
  Set<Cell> get directBoundary => {start, end};

  @override
  Aabb2 get boundingBoxApproximate => spline.bbox;
}

/// A closed edge represents a loop curve with no connections.
///
/// Geometrically, it's represented by a cubic spline that forms a closed loop.
final class ClosedEdge extends Edge {
  ClosedEdge(
    this.spline, {
    super.id,
    super.complex,
    super.strokeWeight,
    super.strokeWidth,
    super.color,
  });

  @override
  CubicSpline2 spline;

  @override
  Set<Cell> get directBoundary => <Cell>{};

  @override
  Aabb2 get boundingBoxApproximate => spline.bbox;
}

class _EdgeVertexKnot extends CubicKnot2 {
  _EdgeVertexKnot(this._edge, this.isStart, super.p, {super.cIn, super.cOut});

  final OpenEdge _edge;
  final bool isStart;

  @override
  set cOut(Vector2? c) {
    if (!isStart) return;
    super.cOut = c;
    _edge.cStart = c;
  }

  @override
  set cIn(Vector2? c) {
    if (isStart) return;
    super.cIn = c;
    _edge.cEnd = c;
  }
}
