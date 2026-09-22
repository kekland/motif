part of 'kernel.dart';

enum TransactionMode {
  topology,
  geometry,
}

final class Transaction {
  Transaction(this.bundle, {required this.namespace}) {
    bundle._lockTransaction();
    bundle._changeTracker.begin();
  }

  final Bundle bundle;
  final U64 namespace;

  final delta = Delta();
  var _committed = false;
  void _checkOpen() {
    if (_committed) throw StateError('transaction has already been committed');
  }

  var _opIndex = 0;
  var _subIndex = 0;
  var _captureIndex = 0;

  TransactionMode? _mode;
  TransactionMode get mode => _mode!;

  OpRecord? _record;

  void _bind(OpRecord record) {
    assert(_record == null);
    _record = record;
    _subIndex = 0;
  }

  void _unbind(OpRecord record) {
    assert(identical(_record, record));
    _record = null;
  }

  OpRecord<O> apply<O extends Op>(O op) {
    _checkOpen();
    final record = OpRecord<O>(op, namespace, _opIndex++);
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
    final record = OpRecord<O>(op, namespace, _opIndex++);
    final result = _run(record, mode: .topology, produceResult: true) as R;
    delta.actions.add(.applied(record));
    return result;
  }

  Object? _run(OpRecord record, {required TransactionMode mode, bool produceResult = false}) {
    assert(_mode == null);
    _mode = mode;
    _bind(record);

    final result = record.def._execute(this, produceResult);

    if (mode == .topology) {
      record._subCount = _subIndex;
    } else {
      assert(_subIndex == record._subCount);
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

  CellRef<H> _ref<H extends CellHandle>(CellKind kind) {
    return .make(
      namespace: _record!.namespace,
      op: _record!.index,
      sub: _subIndex++,
      kind: kind,
    );
  }

  T _capture<T>(T Function() resolve) {
    final record = _record!;
    if (mode == .topology) {
      final value = resolve();
      record._captured.add(value);
      return value;
    }

    return record._captured[_captureIndex++] as T;
  }

  M _recordMutation<M extends Mutation>(M m) {
    _record?._mutations.add(m);
    return m;
  }

  void _recordGeometry(CellHandle h) {
    if (mode == .geometry) return;

    final ref = h.ref(bundle);
    if (ref.namespace != _record!.namespace || ref.op != _record!.index) {
      _record!._geometry.putIfAbsent(ref, () => .of(bundle, h));
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

    final (moved, movedFrames) = bundle._changeTracker.take(bundle);
    delta.moved = moved;
    delta.movedFrames = movedFrames;
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
