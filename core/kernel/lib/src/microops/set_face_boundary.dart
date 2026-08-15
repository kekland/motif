part of '../kernel.dart';

final class SetFaceBoundaryOp extends TopologyOp {
  SetFaceBoundaryOp(this.id, this.fromBoundary, this.toBoundary);

  final CellId id;
  final List<CycleRef> fromBoundary;
  final List<CycleRef> toBoundary;

  @override
  void reapply(TopologyTransaction txn) => txn._setFaceBoundary(
    txn.faceFor(id),
    toBoundary.map(txn.cycleFor).toList(),
  );

  @override
  void unapply(TopologyTransaction txn) => txn._setFaceBoundary(
    txn.faceFor(id),
    fromBoundary.map(txn.cycleFor).toList(),
  );
}

extension SetFaceBoundaryTransaction on TopologyTransaction {
  void _setFaceBoundary(FaceHandle f, List<Cycle> newBoundary) {
    _checkOpen();

    final oldCycleRefs = bundle.faceBoundary(f).map((c) => c.asRef(bundle)).toList();
    final newCycleRefs = newBoundary.map((c) => c.asRef(bundle)).toList();

    final faceIndex = f.index;
    for (final h in bundle._faceBoundary(faceIndex).toList()) bundle._removeCycle(faceIndex, h);
    for (final c in newBoundary) bundle._addCycle(f, c);

    ops.add(SetFaceBoundaryOp(bundle.faceId(f), oldCycleRefs, newCycleRefs));
    markFaceMoved(f);
  }
}
