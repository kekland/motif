part of '../kernel.dart';

sealed class MutateFrameOp extends TopologyOp {
  MutateFrameOp(
    this.id,
    Mat4 transform,
    this.size,
    this.placement,
  ) : transform = .copy(transform);

  final CellId id;
  final Mat4 transform;
  final Size2? size;
  final CellPlacement placement;

  void _add(TopologyTransaction txn) => txn.addFrame(
    id,
    transform: transform,
    parent: placement.resolveParent(txn.bundle),
    anchor: placement.resolveAnchor(txn.bundle),
  );

  void _delete(TopologyTransaction txn) => txn.deleteFrame(txn.frameFor(id));
}

final class AddFrameOp extends MutateFrameOp {
  AddFrameOp(super.id, super.transform, super.size, super.placement);

  @override
  void reapply(TopologyTransaction txn) => _add(txn);

  @override
  void unapply(TopologyTransaction txn) => _delete(txn);
}

final class DeleteFrameOp extends MutateFrameOp {
  DeleteFrameOp(super.id, super.transform, super.size, super.placement);

  @override
  void reapply(TopologyTransaction txn) => _delete(txn);

  @override
  void unapply(TopologyTransaction txn) => _add(txn);
}

extension MutateFrameTransaction on TopologyTransaction {
  FrameHandle addFrame(
    CellId id, {
    Mat4? transform,
    Size2? size,
    FrameHandle? parent,
    SiblingHandleAnchor anchor = const .append(),
  }) {
    _checkOpen();
    final handle = bundle._addFrame(id, transform: transform, size: size, parent: parent, anchor: anchor);
    ops.add(AddFrameOp(id, bundle.frameTransform(handle), size, .of(bundle, handle)));
    markAdded(handle);
    return handle;
  }

  void deleteFrame(FrameHandle h) {
    _checkOpen();
    if (h.index == .root) throw ArgumentError.value(h, 'h', 'cannot delete root frame');
    if (bundle.frameHasChildren(h)) throw ArgumentError.value(h, 'h', 'cannot delete frame with children');
    final id = bundle.frameId(h);
    ops.add(DeleteFrameOp(id, bundle.frameTransform(h), bundle.frameSize(h), .of(bundle, h)));
    markDeleted(h);
    bundle._removeFrame(h);
  }
}
