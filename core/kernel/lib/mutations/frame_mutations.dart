part of '../kernel.dart';

final class FrameAdd(
  final CellId id,
  final Mat4 transform,
  final Size2? size,
  final CellPlacement placement,
) extends Mutation {
  @override
  FrameHandle reapply(Transaction txn) => txn.bundle._frameAdd(
    id,
    transform: transform,
    size: size,
    parent: placement.resolveParent(txn),
  );

  @override
  void unapply(Transaction txn) => txn.bundle._frameFree(
    txn.frameFor(id),
  );
}

final class FrameDelete(
  final CellId id,
  final CellPlacement placement,
) extends Mutation {
  @override
  void reapply(Transaction txn) => txn.bundle._frameRemove(
    txn.frameFor(id),
  );

  @override
  void unapply(Transaction txn) => txn.bundle._frameRelink(
    txn.frameFor(id),
    parent: placement.resolveParent(txn),
  );
}

extension FrameMutationTransaction on Transaction {
  FrameHandle _addFrame({
    Mat4? transform,
    Size2? size,
    FrameHandle? parent,
  }) {
    _checkOpen();
    final handle = _addCell(
      (id) => FrameAdd(id, transform ?? Mat4.identity(), size, .from(bundle, parent)),
      (id) => bundle.frame(id)!,
    );

    _setFrameTransform(handle, transform ?? Mat4.identity());
    _setFrameSize(handle, size);
    return handle;
  }

  void _deleteFrame(FrameHandle handle, {bool cascade = false}) {
    _checkOpen();
    if (mode != .topology) return;

    if (handle.index == .root) throw ArgumentError.value(handle, 'handle', 'cannot delete root frame');
    if (bundle.frameHasChildren(handle)) {
      if (!cascade) throw StateError('cannot delete frame with children without cascade');

      while (true) {
        final first = bundle.frameChildren(handle).firstOrNull;
        if (first == null) break;

        final _ = switch (first.kind) {
          .frame => _deleteFrame(first.asFrame, cascade: true),
          .vertex => _deleteVertex(first.asVertex, cascade: true),
          .edge => _deleteEdge(first.asEdge, cascade: true),
          .face => _deleteFace(first.asFace),
        };
      }
    }

    _deleteCell(handle, FrameDelete(bundle.frameId(handle), .of(bundle, handle)));
  }

  void _setFrameTransform(FrameHandle f, Mat4 transform) {
    if (bundle.frameTransform(f).exactEquals(transform)) return;
    _recordGeometry(f);
    bundle._frameSetTransform(f, transform);
    markFrameMoved(f);
  }

  void _setFrameSize(FrameHandle f, Size2? size) {
    final before = bundle.frameSize(f);
    if (before == null && size == null) return;
    if (before != null && size != null && before.exactEquals(size)) return;

    _recordGeometry(f);
    bundle._frameSetSize(f, size);
    markFrameMoved(f);
  }

  void _setFrameClip(FrameHandle f, FaceHandle? clip) {
    if (bundle.frameClip(f) == clip) return;
    _recordGeometry(f);
    bundle._frameSetClip(f, clip);
    markFrameMoved(f);
  }
}
