part of '../vector_complex.dart';

/// A half edge represents an edge along with a direction.
final class HalfEdge {
  HalfEdge(this.edge, this.direction);

  final Edge edge;
  final bool direction;

  HalfEdge reversed() => HalfEdge(edge, !direction);

  Vertex get start {
    assert(this.edge is OpenEdge);
    final edge = this.edge as OpenEdge;
    return direction ? edge.start : edge.end;
  }

  Vertex get end {
    assert(this.edge is OpenEdge);
    final edge = this.edge as OpenEdge;
    return direction ? edge.end : edge.start;
  }

  Vector2 get startPosition {
    final spline = edge.spline;
    return direction ? spline.knots.first.p : spline.knots.last.p;
  }

  Vector2 get endPosition {
    final spline = edge.spline;
    return direction ? spline.knots.last.p : spline.knots.first.p;
  }
}
