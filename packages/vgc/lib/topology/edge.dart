part of '../vector_complex.dart';

/// An edge is a topological unit that represents:
///
/// - A curve connecting two vertices (open edge)
/// - A loop curve with no connections (closed edge)
///
/// Geometrically, an edge is a curve in the plane. The curve is represented by a [CubicSpline2] (a sequence of cubics).
sealed class Edge extends Cell {
  Edge({super.id});
  CubicSpline2 get spline;
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
  }) : interior = interior ?? [] {
    _start._directStar.add(this);
    _end._directStar.add(this);
  }

  factory OpenEdge.fromSpline(Vertex start, Vertex end, CubicSpline2 spline, {String? id}) {
    if (spline.knots.first.p != start.position || spline.knots.last.p != end.position) {
      throw ArgumentError('Spline start and end positions must match the given vertices');
    }

    final cStart = spline.knots.first.cOut;
    final cEnd = spline.knots.last.cIn;
    final interior = spline.knots.sublist(1, spline.knots.length - 1).map((k) => k.copy()).toList();

    return OpenEdge(start, end, cStart: cStart, cEnd: cEnd, interior: interior, id: id);
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
    .new(start.position, cOut: cStart),
    ...interior,
    .new(end.position, cIn: cEnd),
  ]);

  @override
  Set<Cell> get directBoundary => {start, end};

  @override
  Aabb2 get boundingBoxApproximate => spline.bboxCheap;
}

/// A closed edge represents a loop curve with no connections.
///
/// Geometrically, it's represented by a cubic spline that forms a closed loop.
final class ClosedEdge extends Edge {
  ClosedEdge(this.spline, {super.id});

  @override
  CubicSpline2 spline;

  @override
  Set<Cell> get directBoundary => <Cell>{};

  @override
  Aabb2 get boundingBoxApproximate => spline.bboxCheap;
}
