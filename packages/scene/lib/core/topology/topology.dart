part of '../core.dart';

class Topology {
  Topology({required this.scene});

  final Scene scene;

  Vertex embedVertexAtHitTest(SceneHitTestResult hitTest, {int? depth}) {
    for (final entry in hitTest.nodes) {
      final node = entry.node;
      if (depth != null && node.depth != depth) continue;

      if (node is Vertex) return node;
      if (node is Edge) {
        final t = (entry as EdgeHitTestEntry).t;
        final result = node.cut(t);
        return result.vertex;
      }

      if (node is MultiChildSceneObject) {
        final position = entry.localPosition;
        final vertex = Vertex(position);
        node.addChild(vertex);
        return vertex;
      }
    }

    unreachable();
  }

  List<CellIntersection> intersectionsWithCubic(
    List<Cell> cells,
    Cubic2 cubic,
  ) => _intersectCellsWithCubic(cells, cubic);

  List<CellIntersection> intersectionsWithSpline(
    List<Cell> cells,
    CubicSpline2 spline,
  ) => _intersectCellsWithSpline(cells, spline);

  EdgeCutResult cutEdge(Edge edge, double t) => _cutEdge(edge, t);
  MultiEdgeCutResult multiCutEdge(Edge edge, List<double> ts) => _multiCutEdge(edge, ts);

  List<Edge> commitStroke(
    MultiChildSceneObject parent,
    EdgePath path, {
    Vertex? startVertex,
    Vertex? endVertex,
  }) => _commitStroke(parent, path, startVertex: startVertex, endVertex: endVertex);
}
