part of '../kernel.dart';

final class SetFrameTransformOp extends TopologyOp {
  SetFrameTransformOp(this.id, Mat4 from, Mat4 to) : from = .copy(from), to = .copy(to);

  final CellId id;
  final Mat4 from, to;

  @override
  void reapply(TopologyTransaction txn) => txn.setFrameTransform(txn.frameFor(id), to);

  @override
  void unapply(TopologyTransaction txn) => txn.setFrameTransform(txn.frameFor(id), from);
}

extension SetFrameTransformTransaction on TopologyTransaction {
  void setFrameTransform(FrameHandle f, Mat4 transform) {
    _checkOpen();

    final old = bundle.frameTransform(f);
    bundle._setFrameTransform(f, transform);
    ops.add(SetFrameTransformOp(bundle.frameId(f), old, transform));
    delta.markMoved(bundle.frameKey(f));
  }
}
