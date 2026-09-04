part of 'kernel.dart';

extension type const TransactionMark._((int ops, int added, int deleted, int moved, int lineage) _) {
  static const zero = TransactionMark._((0, 0, 0, 0, 0));

  int get ops => _.$1;
  int get added => _.$2;
  int get deleted => _.$3;
  int get moved => _.$4;
  int get lineage => _.$5;
}

enum TransactionMode {
  topology,
  geometry,
}

final class Transaction {
  Transaction(this.bundle, {this._namespace}) {
    bundle._lockTransaction();
    bundle._changeTracker.begin();
  }

  final Bundle bundle;
  final int? _namespace;

  final delta = Delta();

  var _committed = false;
  void _checkOpen() {
    if (_committed) throw StateError('transaction has already been committed');
  }

  var _tag = 0;

  TransactionMode? _mode;
  TransactionMode get mode => _mode!;

  OpRecord? _record;
  var _sub = 0;

  void _bind(OpRecord record) {
    assert(_record == null);
    _record = record;
    _sub = 0;
  }

  void _unbind(OpRecord record) {
    assert(identical(_record, record));
    _record = null;
  }

  OpRecord<O> apply<O extends Op>(O op) {
    _checkOpen();
    final record = OpRecord<O>(op, _tag++);
    _run(record, mode: .topology);
    delta.actions.add(.applied(record));
    return record;
  }

  bool update<O extends Op>(OpRecord<O> record, O op) {
    _checkOpen();
    if (!record.def.topologyEquals(op)) return false;

    final before = record.def;
    record._reshape(op);
    _run(record, mode: .geometry);
    delta.actions.add(.updated(record, before));
    return true;
  }

  void replay(OpRecord record) {
    _checkOpen();
    _replay(record);
    delta.actions.add(.replayed(record));
  }

  void revert(OpRecord record) {
    _checkOpen();
    _revert(record);
    delta.actions.add(.reverted(record));
  }

  R _applyWithResult<R, O extends Op>(O op) {
    _checkOpen();
    final record = OpRecord<O>(op, _tag++);
    final result = _run(record, mode: .topology, produceResult: true) as R;
    delta.actions.add(.applied(record));
    return result;
  }

  // T _cache<T>(CellHandle h, Object key, T Function() compute) {
  //   final ref = h.ref(bundle), version = 1;
  //   final hit = _record!._cache[(ref, key)];
  //   if (hit != null && hit.$1 == version) return hit.$2 as T;
  //   final value = compute();
  //   _record!._cache[(ref, key)] = (version, value);
  //   return value;
  // }

  Object? _run(OpRecord record, {required TransactionMode mode, bool produceResult = false}) {
    assert(_mode == null);
    _mode = mode;
    _bind(record);

    final result = record.def._execute(this, produceResult);

    if (mode == .topology) {
      record._subCount = _sub;
    } else {
      assert(_sub == record._subCount);
    }

    _unbind(record);
    _mode = null;
    return result;
  }

  void _replay(OpRecord record) {
    for (final m in record._mutations) m.reapply(this);
    _run(record, mode: .geometry);
  }

  void _revert(OpRecord record) {
    for (final e in record._geometry.entries) e.value.set(bundle, bundle.handle(e.key)!);
    for (final m in record._mutations.reversed) m.unapply(this);
  }

  CellId _id() {
    return .make(namespace: _namespace!, tag: _record!.tag, sub: _sub++);
  }

  M _recordMutation<M extends Mutation>(M m) {
    _record?._mutations.add(m);
    return m;
  }

  void _recordGeometry(CellHandle h) {
    if (mode == .geometry) return;

    final id = h.id(bundle);
    if (id.namespace != _namespace || id.tag != _record!.tag) {
      _record!._geometry.putIfAbsent(.make(id, h.kind), () => .of(bundle, h));
    }
  }

  void _recordLineage(Lineage l) {
    if (mode == .topology) delta.lineage.add(l);
  }

  Delta commit() {
    _checkOpen();
    _committed = true;
    bundle._endTransaction();
    bundle._version++;

    delta.moved = bundle._changeTracker.take(bundle);
    return delta;
  }

  void abort() {
    _checkOpen();
    try {
      final r = _record;
      if (r != null) {
        final wasGeometry = mode == .geometry;
        _unbind(r);
        _mode = null;
        if (!wasGeometry) _revert(r);
      }

      for (final a in delta.actions.reversed) {
        final _ = switch (a) {
          Applied v => _revert(v.record),
          Reverted v => _replay(v.record),
          Replayed v => _revert(v.record),
          Updated v => _run(v.record.._reshape(v.before), mode: .geometry),
        };
      }
    } finally {
      _committed = true;
      bundle._endTransaction();
      bundle._changeTracker.clear();
    }
  }
}
