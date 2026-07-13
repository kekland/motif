part of '../core.dart';

extension ComplexHitTestUtils on MutableVectorComplex {
  MutableVertex embedVertexAtHitTest(BoxHitTestEntry hitTest) {
    if (hitTest is VertexHitTestEntry) {
      return hitTest.cell as MutableVertex;
    } else if (hitTest is EdgeHitTestEntry) {
      // final edge = hitTest.cell, t = hitTest.t;
      // final result = cutEdge(edge, t);
      // return result.vertex;
      return hitTest.cell.start as MutableVertex;
    } else {
      final position = hitTest.localPosition;
      return addVertex(.new(position.dx, position.dy));
    }
  }
}
