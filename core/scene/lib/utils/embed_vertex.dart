part of '../scene.dart';

extension EmbedVertexTransaction on SceneTransaction {
  VertexRef embedVertex(
    SceneHitResult hitTest, {
    bool topological = true,
    bool destructive = true,
    Vec2? globalPosition,
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
      for (final f in hitTest.frames) {
        final statement = evaluation.statement(f.statementId);
        if (statement == null) continue;
        if (statement is FramedStatement && !statement.isLeaf) {
          final Vec2 point;

          if (globalPosition != null) {
            point = scene.bundle.query.worldToLocal(f.ref).transform2(globalPosition);
          } else {
            point = f.point;
          }

          return insert(VertexStatement(point, parent: f.ref)).ref;
        }
      }
    }

    final point = globalPosition ?? hitTest.position;
    return insert(VertexStatement(point)).ref;
  }
}
