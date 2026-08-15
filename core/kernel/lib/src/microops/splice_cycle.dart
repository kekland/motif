part of '../kernel.dart';

final class SpliceCycleOp extends TopologyOp {
  SpliceCycleOp(this.face, this.remove, this.insert);

  final CellId face;
  final List<CoedgeRef> remove;
  final List<CoedgeRef> insert;

  @override
  void reapply(TopologyTransaction txn) => txn._spliceCycle(
    txn.faceFor(face),
    remove.map(txn.coedgeFor).toList(),
    insert.map(txn.coedgeFor).toList(),
  );

  @override
  void unapply(TopologyTransaction txn) => txn._spliceCycle(
    txn.faceFor(face),
    insert.map(txn.coedgeFor).toList(),
    remove.map(txn.coedgeFor).toList(),
  );
}

extension SpliceCycleTransaction on TopologyTransaction {
  void _spliceCycle(FaceHandle f, List<Coedge> remove, List<Coedge> insert) {
    _checkOpen();

    bundle._spliceCycle(f, remove, insert);
    ops.add(
      SpliceCycleOp(
        bundle.faceId(f),
        remove.map((c) => c.asRef(bundle)).toList(),
        insert.map((c) => c.asRef(bundle)).toList(),
      ),
    );

    delta.markMoved(bundle.faceKey(f));
  }
}
