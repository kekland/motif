part of '../core.dart';

extension VectorComplexHitTestUtils on VectorComplex {
  Vertex embedVertexAtHitTest(BoxHitTestEntry hitTest) {
    if (hitTest is VertexHitTestEntry) {
      return hitTest.cell;
    } else if (hitTest is EdgeHitTestEntry) {
      final edge = hitTest.cell, t = hitTest.t;
      final result = cutEdge(edge, t);
      return result.vertex;
    } else {
      final position = hitTest.localPosition;
      return addVertex(.new(position.dx, position.dy));
    }
  }
}
