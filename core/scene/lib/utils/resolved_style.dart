part of '../scene.dart';

extension ResolvedStyle on ShapeStatement {
  EdgeStylePartial resolvedEdgeStyle(Scene scene) {
    final products = scene.productsOf(id).where((r) => r.kind == .edge);
    final edges = products.map((r) => scene.styleOf(r).asEdge).nonNulls.toList();
    return .fromList(edges);
  }

  FaceStylePartial resolvedFaceStyle(Scene scene) {
    final products = scene.productsOf(id).where((r) => r.kind == .face);
    final faces = products.map((r) => scene.styleOf(r).asFace).nonNulls.toList();
    return .fromList(faces);
  }
}
