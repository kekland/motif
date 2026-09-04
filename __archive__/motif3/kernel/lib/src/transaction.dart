part of 'kernel.dart';

extension type const TransactionMark._((int ops, int added, int deleted, int moved, int lineage) _) {
  static const zero = TransactionMark._((0, 0, 0, 0, 0));

  int get ops => _.$1;
  int get added => _.$2;
  int get deleted => _.$3;
  int get moved => _.$4;
  int get lineage => _.$5;
}

class TopologyTransaction {
  TopologyTransaction(this.bundle, {this._namespace}) {
    bundle._lockTransaction(delta);
  }

  final TopologyBundle bundle;
  final String? _namespace;
  var _tag = 0;

  final delta = TopologyDelta();
  List<TopologyOp> get ops => delta.ops;
  Set<CellKey> get writes => delta.writes;

  var _committed = false;
  void _checkOpen() {
    if (_committed) throw StateError('transaction has already been committed');
  }

  CellId createTag(String suffix) {
    final n = _tag++;
    final base = _namespace ?? 'txn';
    return CellId('$base/$suffix/$n');
  }

  TopologyDelta commit() {
    _checkOpen();
    _setReads();
    _committed = true;
    bundle._endTransaction();
    bundle._version++;
    return delta;
  }

  TransactionMark mark() {
    return ._((
      delta.ops.length,
      delta._added.length,
      delta._deleted.length,
      delta._moved.length,
      delta.lineage.length,
    ));
  }

  void rollbackTo(TransactionMark m) {
    _checkOpen();
    for (var i = ops.length - 1; i >= m.ops; i--) ops[i].unapply(this);
    ops.removeRange(m.ops, ops.length);

    final d = delta;
    d._added.removeRange(m.added, d._added.length);
    d._deleted.removeRange(m.deleted, d._deleted.length);
    d._moved.removeAll(d._moved.skip(m.moved).toList());
    for (final l in d.lineage.skip(m.lineage).toList()) {
      d._lineageBySource.remove(l.source);
      for (final p in l.products) {
        if (identical(d._lineageByProduct[p], l)) d._lineageByProduct.remove(p);
      }
    }
    d.lineage.removeRange(m.lineage, d.lineage.length);
  }

  void _setReads() {
    final reads = bundle._reads!;
    for (final handle in reads) {
      final key = delta._deletedHandles[handle] ?? bundle.key(handle);
      delta._reads.add(key);
    }
  }

  void abort() {
    _checkOpen();
    _setReads();
    try {
      rollbackTo(.zero);
    } finally {
      _committed = true;
      bundle._endTransaction();
    }
  }
}
