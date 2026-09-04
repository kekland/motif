part of '../kernel.dart';

sealed class MutateFaceOp extends TopologyOp {
  MutateFaceOp(this.id, this.boundary, {this.placement = .append});

  final CellId id;
  final List<CycleRef> boundary;
  final CellPlacement placement;

  void _add(TopologyTransaction txn) => txn.addFace(
    id,
    boundary.map(txn.cycleFor).toList(),
    parent: placement.resolveParent(txn.bundle),
    anchor: placement.resolveAnchor(txn.bundle),
  );

  void _delete(TopologyTransaction txn) => txn.deleteFace(txn.faceFor(id));
}

final class AddFaceOp extends MutateFaceOp {
  AddFaceOp(super.id, super.boundary, {super.placement});

  @override
  void reapply(TopologyTransaction txn) => _add(txn);

  @override
  void unapply(TopologyTransaction txn) => _delete(txn);
}

final class DeleteFaceOp extends MutateFaceOp {
  DeleteFaceOp(super.id, super.boundary, {super.placement});

  @override
  void reapply(TopologyTransaction txn) => _delete(txn);

  @override
  void unapply(TopologyTransaction txn) => _add(txn);
}

extension MutateFaceTransaction on TopologyTransaction {
  FaceHandle addFace(
    CellId id,
    List<Cycle> boundary, {
    FrameHandle? parent,
    SiblingHandleAnchor anchor = const .append(),
  }) {
    _checkOpen();
    if (boundary.isEmpty || boundary.any((c) => c.isEmpty)) {
      throw ArgumentError.value(boundary, 'cycles', 'must be non-empty and contain no empty cycles');
    }

    for (final cycle in boundary) {
      for (var i = 0; i < cycle.length; i++) {
        final u = cycle[i];
        assert(bundle._checkEdge(u.edge));
        final n = cycle[(i + 1) % cycle.length];
        final endV = bundle.coedgeEnd(u);
        final startV = bundle.coedgeStart(n);
        if (endV != startV) {
          throw ArgumentError(
            'cycle $cycle is not closed: edge ${u.edge.name(bundle)} end vertex ${endV.name(bundle)} does not match next edge ${n.edge.name(bundle)} start vertex ${startV.name(bundle)}',
          );
        }
      }
    }

    final faceHandle = bundle._addFace(id, parent: parent, anchor: anchor);
    for (final cycle in boundary) bundle._addCycle(faceHandle, cycle);

    final cycleRefs = boundary.map((c) => c.asRef(bundle)).toList();
    ops.add(AddFaceOp(id, cycleRefs, placement: .of(bundle, faceHandle)));

    markAdded(faceHandle);
    for (final c in cycleRefs) markCycleMoved(c);

    return faceHandle;
  }

  void deleteFace(FaceHandle f) {
    _checkOpen();

    final id = bundle.faceId(f);
    final cycleRefs = bundle.faceBoundary(f).map((c) => c.asRef(bundle)).toList();
    ops.add(DeleteFaceOp(id, cycleRefs, placement: .of(bundle, f)));

    for (final c in cycleRefs) markCycleMoved(c);
    markDeleted(f);

    bundle._removeFace(f);
  }
}
