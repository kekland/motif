part of '../kernel.dart';

typedef NearestVertexResult = ({VertexRef vertex, double distance});

extension NearestVertexQuery on TopologyQuery {
  NearestVertexResult? nearestVertex(Vec2 p, double tolerance) {
    VertexHandle? best;
    var bestD2 = tolerance * tolerance;

    for (final v in bundle.vertices) {
      final position = bundle.vertexPosition(v, space: .root);
      final d2 = p.distance2To(position);
      if (d2 <= bestD2) {
        best = v;
        bestD2 = d2;
      }
    }

    if (best == null) return null;
    return (vertex: bundle.vertexRef(best), distance: math.sqrt(bestD2));
  }
}
