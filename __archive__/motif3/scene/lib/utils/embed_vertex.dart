part of '../scene.dart';

extension EmbedVertexTransaction on SceneTransaction {
  VertexRef embedVertex(SceneHitResult hitTest) {
    if (hitTest.vertices.isNotEmpty) return hitTest.vertices.first.ref;
    if (hitTest.edges.isNotEmpty) {
      final entry = hitTest.edges.first;
      return insert(CutEdgeStatement(entry.ref, t: entry.t)).vertex;
    }
    if (hitTest.frames.isNotEmpty) {
      final frame = hitTest.frames.last;
      return insert(VertexStatement(frame.point, parent: frame.ref)).vertex;
    }

    return insert(VertexStatement(hitTest.position)).vertex;
  }
}
