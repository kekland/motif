part of '../kernel.dart';

final class VertexAdd(
  final VertexRef ref,
  final Vec2 position,
  final CellPlacement placement,
) extends Mutation  {
  @override
  VertexHandle reapply(Transaction txn) => txn.bundle._vertexAdd(
    ref,
    position,
    parent: placement.resolveParent(txn),
  );

  @override
  void unapply(Transaction txn) => txn.bundle._vertexFree(
    txn.vertexFor(ref),
  );
}

final class VertexDelete(
  final VertexRef ref,
  final CellPlacement placement,
) extends Mutation {
  @override
  void reapply(Transaction txn) => txn.bundle._vertexRemove(
    txn.vertexFor(ref),
  );

  @override
  void unapply(Transaction txn) => txn.bundle._vertexRelink(
    txn.vertexFor(ref),
    parent: placement.resolveParent(txn),
  );
}

extension VertexMutationTransaction on Transaction {
  VertexHandle _addVertex(
    Vec2 position, {
    FrameHandle? parent,
  }) {
    _checkOpen();
    final handle = _addCell<VertexHandle>(
      .vertex,
      (ref) => VertexAdd(ref, position, .from(bundle, parent)),
      (ref) => bundle.vertex(ref)!,
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

    _deleteCell(h, VertexDelete(bundle.vertexRef(h), .of(bundle, h)));
  }

  void _setVertexPosition(VertexHandle v, Vec2 position) {
    if (bundle.vertexPosition(v).exactEquals(position)) return;
    _recordGeometry(v);
    bundle._vertexSetPosition(v, position);
    markVertexMoved(v);
  }
}
