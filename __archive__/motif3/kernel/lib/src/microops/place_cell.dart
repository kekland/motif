part of '../kernel.dart';

final class PlaceCellOp extends TopologyOp {
  PlaceCellOp(this.cell, this.from, this.to);

  final CellKey cell;
  final CellPlacement from, to;

  @override
  void reapply(TopologyTransaction txn) => txn.placeCell(
    txn.cellFor(cell),
    parent: to.resolveParent(txn.bundle),
    anchor: to.resolveAnchor(txn.bundle),
  );

  @override
  void unapply(TopologyTransaction txn) => txn.placeCell(
    txn.cellFor(cell),
    parent: from.resolveParent(txn.bundle),
    anchor: from.resolveAnchor(txn.bundle),
  );
}

extension PlaceCellTransaction on TopologyTransaction {
  void placeCell(
    CellHandle cell, {
    FrameHandle? parent,
    SiblingHandleAnchor anchor = const .append(),
  }) {
    _checkOpen();

    if (cell.kind == .frame && cell.asFrame.index == .root) throw StateError('cannot place the root frame');

    final target = parent ?? bundle.parentOf(cell)!;
    if (cell.kind == .frame) {
      final self = cell.asFrame;
      for (FrameHandle? p = target; p != null; p = bundle.frameParent(p)) {
        if (p == self) {
          throw StateError('placing frame ${self.name(bundle)} under its own subtree');
        }
      }
    }

    final ref = bundle.key(cell);
    final from = CellPlacement.of(bundle, cell);

    bundle._setParent(cell.cell, target.index, after: anchor.map((h) => h.cell));
    ops.add(PlaceCellOp(ref, from, .of(bundle, cell)));
    delta.markMoved(ref);
  }
}
