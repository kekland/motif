part of '../kernel.dart';

sealed class MutateVertexOp extends TopologyOp {
  MutateVertexOp(this.id, this.position, {this.placement = .append});

  final CellId id;
  final Vec2 position;
  final CellPlacement placement;

  void _add(TopologyTransaction txn) => txn.addVertex(
    id,
    position,
    parent: placement.resolveParent(txn.bundle),
    anchor: placement.resolveAnchor(txn.bundle),
  );

  void _delete(TopologyTransaction txn) => txn.deleteVertex(txn.vertexFor(id));
}

final class AddVertexOp extends MutateVertexOp {
  AddVertexOp(super.id, super.position, {super.placement});

  @override
  void reapply(TopologyTransaction txn) => _add(txn);

  @override
  void unapply(TopologyTransaction txn) => _delete(txn);
}

final class DeleteVertexOp extends MutateVertexOp {
  DeleteVertexOp(super.id, super.position, {super.placement});

  @override
  void reapply(TopologyTransaction txn) => _delete(txn);

  @override
  void unapply(TopologyTransaction txn) => _add(txn);
}

extension MutateVertexTransaction on TopologyTransaction {
  VertexHandle addVertex(
    CellId id,
    Vec2 position, {
    FrameHandle? parent,
    SiblingHandleAnchor anchor = const .append(),
  }) {
    _checkOpen();
    final handle = bundle._addVertex(id, position, parent: parent, anchor: anchor);
    ops.add(AddVertexOp(id, position, placement: .of(bundle, handle)));
    markAdded(handle);
    return handle;
  }

  void deleteVertex(VertexHandle v, {bool cascade = false}) {
    _checkOpen();

    if (bundle.vertexHasUses(v)) {
      if (!cascade) throw StateError('vertex ${v.name(bundle)} has uses and cannot be deleted');
      for (final e in bundle.vertexEdges(v).toSet()) deleteEdge(e, cascade: true);
    }

    final id = bundle.vertexId(v);
    final pos = bundle.vertexPosition(v);
    ops.add(DeleteVertexOp(id, pos, placement: .of(bundle, v)));
    markDeleted(v);
    bundle._removeVertex(v);
  }
}
