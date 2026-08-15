part of '../../core.dart';

class CutEdgeModifier extends Modifier {
  CutEdgeModifier({
    super.isActive,
    required this.targetId,
    this.anchorPoint,
    this.t,
  });

  final TopologyId targetId;
  final Vector2? anchorPoint;
  final double? t;

  @override
  (Topology, Modifier) apply(ModifierEvaluationContext context, Topology input) {
    Edge? bestEdge = input.maybeGet(targetId);

    late double bestT;
    late Vector2 closestPos;
    var nextTargetId = targetId;

    if (bestEdge != null) {
      if (anchorPoint != null) {
        final result = bestEdge.path.closestTo(anchorPoint!);
        bestT = result.t;
        closestPos = result.point;
      } else {
        bestT = t!;
        closestPos = bestEdge.path.point(bestT);
      }
    } else {
      var minDistSq = double.infinity;
      Edge? fallbackEdge;

      for (final edge in input.edges) {
        final result = edge.path.closestTo(anchorPoint!);

        if (result.distance < minDistSq) {
          minDistSq = result.distance;
          fallbackEdge = edge;
          bestT = result.t;
          closestPos = result.point;
        }
      }

      if (fallbackEdge == null) {
        context.warnings.add('No edge found to cut for targetId $targetId');
        return (input, this);
      }

      bestEdge = fallbackEdge;
      nextTargetId = bestEdge.topologyId;
    }

    bestT = bestT.clamp(1e-6, 1.0 - 1e-6);

    final result = input.cutEdge(bestEdge, bestT);

    final needsUpdate = closestPos != anchorPoint || bestT != t;
    final nextModifier = needsUpdate
        ? CutEdgeModifier(targetId: nextTargetId, anchorPoint: closestPos, t: bestT)
        : this;

    context._addResult(nextModifier, result);
    return (input, nextModifier);
  }
}
