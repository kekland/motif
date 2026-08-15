part of '../core.dart';

extension TopologyGlueVertices on Topology {
  Vertex glueVertices(List<Vertex> vertices) {
    if (vertices.isEmpty) throw ArgumentError('Cannot glue an empty list of vertices.');
    if (vertices.length == 1) return vertices.first;

    final survivor = vertices.first;
    if (survivor.owner != null) {
      throw UnimplementedError();
    }

    final center = Vector2.zero();
    for (final v in vertices) center.add(v.position);
    center.scale(1 / vertices.length);

    survivor.position = center.clone();

    for (var i = 1; i < vertices.length; i++) {
      final target = vertices[i];
      final connectedEdges = target.star.whereType<Edge>().toList();

      for (final edge in connectedEdges) {
        if (edge.startId == target.id) edge.start = survivor;
        if (edge.endId == target.id) edge.end = survivor;
      }

      remove(target);
    }

    return survivor;
  }
}
