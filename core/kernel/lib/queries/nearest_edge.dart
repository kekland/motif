part of '../kernel.dart';

typedef NearestEdgeResult = ({EdgeRef edge, double t, double distance});

extension NearestEdgeQuery on TopologyQuery {
  NearestEdgeResult? nearestEdge(Vec2 p, double tolerance) {
    EdgeHandle? best;
    double? bestT;
    var bestD2 = tolerance * tolerance;

    for (final e in bundle.edges) {
      final cubic = bundle.edgeCubic(e, space: .root);
      if (cubic.bbox.distance2To(p) > bestD2) continue;

      final result = cubic.closestPoint(p);
      if (result.distance * result.distance <= bestD2) {
        best = e;
        bestT = result.t;
        bestD2 = result.distance * result.distance;
      }
    }

    if (best == null) return null;
    return (
      edge: best.ref(bundle),
      t: bestT!,
      distance: math.sqrt(bestD2),
    );
  }
}
