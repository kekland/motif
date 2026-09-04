part of '../kernel.dart';

final class SetVertexPositionOp extends TopologyOp {
  SetVertexPositionOp(this.id, this.from, this.to);

  final CellId id;
  final Vec2 from, to;

  @override
  void reapply(TopologyTransaction txn) => txn.setVertexPosition(txn.vertexFor(id), to);

  @override
  void unapply(TopologyTransaction txn) => txn.setVertexPosition(txn.vertexFor(id), from);
}

extension MoveVertexTransaction on TopologyTransaction {
  void setVertexPosition(VertexHandle v, Vec2 position) {
    _checkOpen();

    final from = bundle.vertexPosition(v);
    if (from.exactEquals(position)) return;

    bundle._setVertexPosition(v, position);
    ops.add(SetVertexPositionOp(bundle.vertexId(v), from, position));
    markVertexMoved(v);
  }
}
