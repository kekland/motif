part of '../kernel.dart';

final class VertexAdd(
  final CellId id,
  final Vec2 position,
  final CellPlacement placement,
) extends Mutation  {
  @override
  VertexHandle reapply(Transaction txn) => txn.bundle._vertexAdd(
    id,
    position,
    parent: placement.resolveParent(txn),
  );

  @override
  void unapply(Transaction txn) => txn.bundle._vertexFree(
    txn.vertexFor(id),
  );
}

final class VertexDelete(
  final CellId id,
  final CellPlacement placement,
) extends Mutation {
  @override
  void reapply(Transaction txn) => txn.bundle._vertexRemove(
    txn.vertexFor(id),
  );

  @override
  void unapply(Transaction txn) => txn.bundle._vertexRelink(
    txn.vertexFor(id),
    parent: placement.resolveParent(txn),
  );
}

extension VertexMutationTransaction on Transaction {
  VertexHandle _addVertex(
    Vec2 position, {
    FrameHandle? parent,
  }) {
    _checkOpen();
    final handle = _addCell(
      (id) => VertexAdd(id, position, .from(bundle, parent)),
      (id) => bundle.vertex(id)!,
    );

    _setVertexPosition(handle, position);
    return handle;
  }

  void _deleteVertex(VertexHandle h, {bool cascade = false}) {
    _checkOpen();
    if (mode != .topology) return;

    if (bundle.vertexHasUses(h)) {
      if (!cascade) throw StateError('cannot delete vertex $h with uses');
      for (final edge in bundle.vertexEdges(h).toSet()) _deleteEdge(edge, cascade: true);
    }

    _deleteCell(h, VertexDelete(bundle.vertexId(h), .of(bundle, h)));
  }

  void _setVertexPosition(VertexHandle v, Vec2 position) {
    if (bundle.vertexPosition(v).exactEquals(position)) return;
    _recordGeometry(v);
    bundle._vertexSetPosition(v, position);
    markVertexMoved(v);
  }
}
