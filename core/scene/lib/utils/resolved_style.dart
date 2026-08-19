part of '../scene.dart';

extension ResolvedStyle on ShapeStatement {
  EdgeStylePartial resolvedEdgeStyle(Scene scene) {
    final edges = products.edges.map((r) => scene.style.ofEdge(r)).nonNulls.toList();
    return .fromList(edges);
  }

  FaceStylePartial resolvedFaceStyle(Scene scene) {
    final faces = products.faces.map((r) => scene.style.ofFace(r)).nonNulls.toList();
    return .fromList(faces);
  }
}
