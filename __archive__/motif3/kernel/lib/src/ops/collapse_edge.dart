part of '../kernel.dart';

final class CollapseEdgeOp extends CompositeOp {
  CollapseEdgeOp(this.edge, this.position, super.children);

  final CellId edge;
  final GlueVerticesPosition position;
}

extension CollapseEdgeTransaction on TopologyTransaction {
  VertexHandle collapseEdge(EdgeHandle e, {GlueVerticesPosition position = .centroid}) {
    _checkOpen();

    final start = bundle.edgeStart(e), end = bundle.edgeEnd(e);
    final edgeId = bundle.edgeId(e);
    final edgeRef = bundle.edgeKey(e);

    return _compositeOp(
      (children) => CollapseEdgeOp(edgeId, position, children),
      () {
        final v = start == end ? start : glueVertices([start, end], position: position);
        _eraseEdgeUses(e);
        deleteEdge(e);
        return (
          v,
          [
            .edge(edgeRef, reduced: [bundle.vertexKey(v)]),
          ],
        );
      },
    );
  }
}
