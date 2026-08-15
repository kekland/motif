part of '../kernel.dart';

final class SetFrameClipOp extends TopologyOp {
  SetFrameClipOp(this.id, this.from, this.to);

  final CellId id;
  final CellId? from, to;

  @override
  void reapply(TopologyTransaction txn) => txn.setFrameClip(
    txn.frameFor(id),
    to != null ? txn.faceFor(to!) : null,
  );

  @override
  void unapply(TopologyTransaction txn) => txn.setFrameClip(
    txn.frameFor(id),
    from != null ? txn.faceFor(from!) : null,
  );
}

extension SetFrameClipTransaction on TopologyTransaction {
  void setFrameClip(FrameHandle f, FaceHandle? clip) {
    _checkOpen();

    final old = bundle.frameClip(f);
    bundle._setFrameClip(f, clip);
    ops.add(SetFrameClipOp(bundle.frameId(f), old?.asId(bundle), clip?.asId(bundle)));
    delta.markMoved(bundle.frameKey(f));
  }
}
