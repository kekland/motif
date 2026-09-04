part of '../kernel.dart';

typedef NearestVertexResult = ({VertexHandle vertex, double distance});

extension NearestVertexQuery on TopologyQuery {
  NearestVertexResult? nearestVertex(Vec2 p, double tolerance) {
    VertexHandle? best;
    var bestD2 = tolerance * tolerance;

    for (final v in bundle.vertices) {
      final position = bundle.vertexPositionWorld(v);
      final d2 = p.distance2To(position);
      if (d2 <= bestD2) {
        best = v;
        bestD2 = d2;
      }
    }

    if (best != null) return (vertex: best, distance: math.sqrt(bestD2));
    return null;
  }
}
