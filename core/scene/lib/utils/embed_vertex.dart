part of '../scene.dart';

extension EmbedVertexTransaction on SceneTransaction {
  VertexRef embedVertex(
    SceneHitResult hitTest, {
    bool topological = true,
    bool destructive = true,
    Vec2? position,
  }) {
    if (topological && hitTest.vertices.isNotEmpty) return hitTest.vertices.first.ref;
    if (topological && hitTest.edges.isNotEmpty) {
      final edge = hitTest.edges.first;
      final cut = insert(CutEdgeStatement(edge.ref.selector(), t: edge.t));
      flush();

      var vertex = cut.vertex;
      if (destructive && evaluation.rootStatement(edge.statementId) is EdgeStatement) {
        vertex = flatten([cut.id]).one(vertex).$2;
      }

      return vertex;
    }
    if (hitTest.frames.isNotEmpty) {
      final frame = hitTest.frames.last;
      final point = position ?? frame.point;

      return insert(VertexStatement(point, parent: frame.ref)).ref;
    }

    final point = position ?? hitTest.position;
    return insert(VertexStatement(point)).ref;
  }
}
