part of '../kernel.dart';

final class SetFrameSizeOp extends TopologyOp {
  SetFrameSizeOp(this.id, this.from, this.to);

  final CellId id;
  final Size2? from, to;

  @override
  void reapply(TopologyTransaction txn) => txn.setFrameSize(txn.frameFor(id), to);

  @override
  void unapply(TopologyTransaction txn) => txn.setFrameSize(txn.frameFor(id), from);
}

extension SetFrameSizeTransaction on TopologyTransaction {
  void setFrameSize(FrameHandle f, Size2? size) {
    _checkOpen();

    final old = bundle.frameSize(f);
    bundle._setFrameSize(f, size);
    ops.add(SetFrameSizeOp(bundle.frameId(f), old, size));
    delta.markMoved(bundle.frameKey(f));
  }
}
