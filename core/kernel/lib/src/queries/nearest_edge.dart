part of '../kernel.dart';

typedef NearestEdgeResult = ({EdgeHandle edge, double t, double distance});

extension NearestEdgeQuery on TopologyQuery {
  NearestEdgeResult? nearestEdge(Vec2 p, double tolerance) {
    NearestEdgeResult? best;

    var bound = tolerance;
    for (final e in bundle.edges) {
      final cubic = bundle.edgeCubicWorld(e);
      if (cubic.bbox.distance2To(p) > bound * bound) continue;

      final result = cubic.closestPoint(p);
      if (result.distance <= bound) {
        bound = result.distance;
        best = (edge: e, t: result.t, distance: result.distance);
      }
    }

    return best;
  }
}
