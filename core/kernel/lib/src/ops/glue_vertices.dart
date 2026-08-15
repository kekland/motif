part of '../kernel.dart';

enum GlueVerticesPosition { first, centroid }

final class GlueVerticesOp extends CompositeOp {
  GlueVerticesOp(this.survivor, this.merged, this.position, super.children);

  final CellId survivor;
  final List<CellId> merged;
  final GlueVerticesPosition position;
}

extension GlueVerticesTransaction on TopologyTransaction {
  VertexHandle glueVertices(List<VertexHandle> vertices, {GlueVerticesPosition position = .centroid}) {
    _checkOpen();
    if (vertices.isEmpty) throw ArgumentError.value(vertices, 'vertices', 'cannot be empty');

    // Collect everything into the first vertex
    final survivor = vertices.first;
    final space = bundle.parentOf(survivor)!;
    final merged = vertices.skip(1).where((m) => m != survivor).toSet();
    if (merged.isEmpty) return survivor;

    // Compute target position
    var targetPosition = bundle.vertexPosition(survivor);
    if (position == .centroid) {
      for (final v in merged) targetPosition += bundle.vertexPosition(v, space: space);
      targetPosition /= merged.length + 1;
    }

    // Capture references for lineage
    final survivorRef = bundle.vertexKey(survivor);
    final mergedRefs = [for (final m in merged) bundle.vertexKey(m)];

    return _compositeOp(
      (children) => GlueVerticesOp(
        survivorRef.id,
        mergedRefs.map((r) => r.id).toList(),
        position,
        children,
      ),
      () {
        // Set survivor position, repoint all edges to survivor, delete dangling vertices
        setVertexPosition(survivor, targetPosition);
        for (final m in merged) {
          final uses = bundle.vertexUses(m).toList();
          for (final cv in uses) _repointEdgeEndpoint(cv.edge, isStart: cv.isStart, to: survivor);
          assert(!bundle.vertexHasUses(m), 'vertex ${m.name(bundle)} should have no uses after repointing');
          deleteVertex(m);
        }

        // Record lineage
        for (final r in mergedRefs) delta.addLineage(r, [survivorRef]);

        return survivor;
      },
    );
  }
}
