part of '../kernel.dart';

final class RepointEdgeOp extends TopologyOp {
  RepointEdgeOp(this.edge, this.start, this.end);

  final CellId edge;
  final ({CellId from, CellId to})? start;
  final ({CellId from, CellId to})? end;

  @override
  void reapply(TopologyTransaction txn) => txn._repointEdge(
    txn.edgeFor(edge),
    start: start?.to != null ? txn.vertexFor(start!.to) : null,
    end: end?.to != null ? txn.vertexFor(end!.to) : null,
  );

  @override
  void unapply(TopologyTransaction txn) => txn._repointEdge(
    txn.edgeFor(edge),
    start: start?.from != null ? txn.vertexFor(start!.from) : null,
    end: end?.from != null ? txn.vertexFor(end!.from) : null,
  );
}

extension RepointEdgeTransaction on TopologyTransaction {
  void _repointEdge(
    EdgeHandle e, {
    VertexHandle? start,
    VertexHandle? end,
  }) {
    _checkOpen();

    final startFrom = bundle.edgeStart(e);
    final endFrom = bundle.edgeEnd(e);

    if (start == startFrom) start = null;
    if (end == endFrom) end = null;
    if (start == null && end == null) return;

    bundle._repointEdge(e, start: start, end: end);
    ops.add(
      RepointEdgeOp(
        bundle.edgeId(e),
        start != null ? (from: bundle.vertexId(startFrom), to: bundle.vertexId(start)) : null,
        end != null ? (from: bundle.vertexId(endFrom), to: bundle.vertexId(end)) : null,
      ),
    );

    markEdgeMoved(e);
  }

  void _repointEdgeEndpoint(EdgeHandle e, {required bool isStart, required VertexHandle to}) {
    return _repointEdge(
      e,
      start: isStart ? to : null,
      end: isStart ? null : to,
    );
  }
}
