part of 'kernel.dart';

final class HistoryEntry {
  HistoryEntry(this.ops, this.delta);

  final List<TopologyOp> ops;
  final TopologyDelta delta;
}

final class TopologyHistory {
  TopologyHistory(this.bundle);
  final TopologyBundle bundle;

  final _entries = <HistoryEntry>[];
  var _cursor = 0;

  int get length => _entries.length;
  bool get canUndo => _cursor > 0;
  bool get canRedo => _cursor < _entries.length;

  TopologyTransaction begin() => ._history(bundle, this);

  void _onCommit(TopologyTransaction txn, TopologyDelta delta) {
    if (txn.ops.isEmpty) return;

    _entries.removeRange(_cursor, _entries.length);
    _entries.add(.new(txn.ops.toList(), delta.copy()));
    _cursor++;
  }

  TopologyDelta? undo() {
    if (!canUndo) return null;
    _cursor--;
    final entry = _entries[_cursor];
    final txn = bundle.beginTransaction();
    for (final op in entry.ops.reversed) op.unapply(txn);
    txn.delta.copyLineageFrom(entry.delta, inverse: true);
    return txn.commit();
  }

  TopologyDelta? redo() {
    if (!canRedo) return null;
    final entry = _entries[_cursor];
    final txn = bundle.beginTransaction();
    for (final op in entry.ops) op.reapply(txn);
    txn.delta.copyLineageFrom(entry.delta);
    _cursor++;
    return txn.commit();
  }
}
