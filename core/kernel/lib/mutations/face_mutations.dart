part of '../kernel.dart';

final class FaceAdd(
  final CellId id,
  final List<CycleRef> boundary,
  final CellPlacement placement,
) extends Mutation {
  @override
  FaceHandle reapply(Transaction txn) => txn.bundle._faceAdd(
    id,
    boundary: boundary.map(txn.cycleFor).toList(),
    parent: placement.resolveParent(txn),
  );

  @override
  void unapply(Transaction txn) => txn.bundle._faceFree(
    txn.faceFor(id),
  );
}

final class FaceDelete(
  final CellId id,
  final CellPlacement placement,
) extends Mutation {
  @override
  void reapply(Transaction txn) => txn.bundle._faceRemove(
    txn.faceFor(id),
  );

  @override
  void unapply(Transaction txn) => txn.bundle._faceRelink(
    txn.faceFor(id),
    parent: placement.resolveParent(txn),
  );
}

final class FaceSpliceBoundary extends Mutation {
  FaceSpliceBoundary(this.face, this.remove, this.insert);

  final CellId face;
  final List<CoedgeRef> remove;
  final List<CoedgeRef> insert;

  @override
  void reapply(Transaction txn) => txn.bundle._cycleSplice(
    txn.faceFor(face),
    remove.map(txn.coedgeFor).toList(),
    insert.map(txn.coedgeFor).toList(),
  );

  @override
  void unapply(Transaction txn) => txn.bundle._cycleSplice(
    txn.faceFor(face),
    insert.map(txn.coedgeFor).toList(),
    remove.map(txn.coedgeFor).toList(),
  );
}

final class FaceSetBoundary extends Mutation {
  FaceSetBoundary(this.id, this.fromBoundary, this.toBoundary);

  final CellId id;
  final List<CycleRef> fromBoundary;
  final List<CycleRef> toBoundary;

  @override
  void reapply(Transaction txn) => txn.bundle._faceSetBoundary(
    txn.faceFor(id),
    toBoundary.map(txn.cycleFor).toList(),
  );

  @override
  void unapply(Transaction txn) => txn.bundle._faceSetBoundary(
    txn.faceFor(id),
    fromBoundary.map(txn.cycleFor).toList(),
  );
}

extension FaceMutationTransaction on Transaction {
  FaceHandle _addFace(
    List<Cycle> boundary, {
    FrameHandle? parent,
  }) {
    _checkOpen();

    final handle = _addCell((id) {
      if (boundary.isEmpty || boundary.any((c) => c.isEmpty)) {
        throw ArgumentError.value(boundary, 'boundary', 'must be non-empty and contain no empty cycles');
      }

      for (final cycle in boundary) {
        for (var i = 0; i < cycle.length; i++) {
          final u = cycle[i];
          assert(bundle._checkEdge(u.edge));
          final n = cycle[(i + 1) % cycle.length];
          final endV = bundle.coedgeEnd(u);
          final startV = bundle.coedgeStart(n);
          if (endV != startV) throw ArgumentError('cycle $cycle is not closed');
        }
      }

      return FaceAdd(id, boundary.map((c) => c.asRef(bundle)).toList(), .from(bundle, parent));
    }, (id) => bundle.face(id)!);

    return handle;
  }

  void _deleteFace(FaceHandle handle) {
    _checkOpen();
    if (mode != .topology) return;

    _deleteCell(
      handle,
      FaceDelete(
        handle.id(bundle),
        .of(bundle, handle),
      ),
    );
  }

  void _setFaceBoundary(FaceHandle f, List<Cycle> boundary) {
    _checkOpen();
    if (mode != .topology) return;

    final mutation = _recordMutation(
      FaceSetBoundary(
        bundle.faceId(f),
        bundle.faceBoundary(f).map((c) => c.asRef(bundle)).toList(),
        boundary.map((c) => c.asRef(bundle)).toList(),
      ),
    );

    mutation.reapply(this);
    markFaceMoved(f);
  }

  void _spliceFaceBoundary(FaceHandle f, List<Coedge> remove, List<Coedge> insert) {
    _checkOpen();
    if (mode != .topology) return;

    final mutation = _recordMutation(
      FaceSpliceBoundary(
        bundle.faceId(f),
        remove.map((c) => c.asRef(bundle)).toList(),
        insert.map((c) => c.asRef(bundle)).toList(),
      ),
    );

    mutation.reapply(this);
    markFaceMoved(f);
  }
}
