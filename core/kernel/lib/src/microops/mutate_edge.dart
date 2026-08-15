part of '../kernel.dart';

sealed class MutateEdgeOp extends TopologyOp {
  MutateEdgeOp(this.id, this.start, this.end, this.startTangent, this.endTangent, {this.placement = .append});

  final CellId id;
  final CellId start, end;
  final Vec2? startTangent, endTangent;
  final CellPlacement placement;

  void _add(TopologyTransaction txn) => txn.addEdge(
    id,
    txn.vertexFor(start),
    txn.vertexFor(end),
    startTangent: startTangent,
    endTangent: endTangent,
    parent: placement.resolveParent(txn.bundle),
    anchor: placement.resolveAnchor(txn.bundle),
  );

  void _delete(TopologyTransaction txn) => txn.deleteEdge(txn.edgeFor(id));
}

final class AddEdgeOp extends MutateEdgeOp {
  AddEdgeOp(super.id, super.start, super.end, super.startTangent, super.endTangent, {super.placement});

  @override
  void reapply(TopologyTransaction txn) => _add(txn);

  @override
  void unapply(TopologyTransaction txn) => _delete(txn);
}

final class DeleteEdgeOp extends MutateEdgeOp {
  DeleteEdgeOp(super.id, super.start, super.end, super.startTangent, super.endTangent, {super.placement});

  @override
  void reapply(TopologyTransaction txn) => _delete(txn);

  @override
  void unapply(TopologyTransaction txn) => _add(txn);
}

extension MutateEdgeTransaction on TopologyTransaction {
  EdgeHandle addEdge(
    CellId id,
    VertexHandle start,
    VertexHandle end, {
    Vec2? startTangent,
    Vec2? endTangent,
    FrameHandle? parent,
    SiblingHandleAnchor anchor = const .append(),
  }) {
    _checkOpen();
    final handle = bundle._addEdge(id, start, end, t0: startTangent, t1: endTangent, parent: parent, anchor: anchor);
    ops.add(
      AddEdgeOp(
        id,
        bundle.vertexId(start),
        bundle.vertexId(end),
        startTangent,
        endTangent,
        placement: .of(bundle, handle),
      ),
    );
    delta.markAdded(.edge(id));
    return handle;
  }

  void deleteEdge(EdgeHandle e, {bool cascade = false}) {
    _checkOpen();

    if (bundle.edgeHasUses(e)) {
      if (!cascade) throw StateError('edge ${e.name(bundle)} has uses and cannot be deleted');
      for (final face in bundle.edgeFaces(e).toSet()) deleteFace(face);
    }

    final id = bundle.edgeId(e);
    ops.add(
      DeleteEdgeOp(
        id,
        bundle.vertexId(bundle.edgeStart(e)),
        bundle.vertexId(bundle.edgeEnd(e)),
        bundle.edgeStartTangent(e),
        bundle.edgeEndTangent(e),
        placement: .of(bundle, e),
      ),
    );

    delta.markDeleted(.edge(id));
    bundle._removeEdge(e);
  }
}
