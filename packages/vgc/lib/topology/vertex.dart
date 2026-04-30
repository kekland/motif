part of '../vector_complex.dart';

/// A vertex is a topological unit that represents a point in the plane. It can be connected to other vertices by edges.
///
/// Geometrically a vertex is also a single point on a plane.
final class Vertex extends Cell {
  Vertex(this.position, {super.id});
  Vector2 position;

  @override
  Set<Cell> get directBoundary => <Cell>{};

  @override
  Aabb2 get boundingBoxApproximate => .minMax(position, position);

  Iterable<HalfEdge> get outgoingHalfEdges sync* {
    for (final cell in directStar) {
      if (cell is OpenEdge) {
        if (cell.start == this) yield .new(cell, true);
        if (cell.end == this) yield .new(cell, false);
      }
    }
  }
}
