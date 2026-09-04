part of 'kernel.dart';

final class TopologyDelta {
  TopologyDelta();

  factory TopologyDelta.merged(TopologyDelta base, Iterable<TopologyDelta> deltas) {
    final out = base.copy();
    for (final d in deltas) out.fold(d);
    return out;
  }

  final ops = <TopologyOp>[];

  final _added = <CellKey>[];
  final _deletedHandles = <CellHandle, CellKey>{};
  final _deleted = <CellKey>[];
  final _moved = <CellKey>{};

  Iterable<CellKey> get added => _added;
  Iterable<CellKey> get deleted => _deleted;
  Iterable<CellKey> get moved => _moved;

  final lineage = <Lineage>[];
  final _lineageBySource = <CellKey, Lineage>{};
  final _lineageByProduct = <CellKey, Lineage>{};

  final _reads = <CellKey>{};
  var _readsAll = false;
  Set<CellKey> get reads => _reads;
  bool get readsAll => _readsAll;
  Set<CellKey> get writes => {..._added, ..._deleted, ..._moved};

  Lineage? lineageOf<H extends CellHandle>(CellKey<H> key) => _lineageBySource[key];
  Lineage? sourceOf<H extends CellHandle>(CellKey<H> key) => _lineageByProduct[key];

  void markAdded(CellKey ref) => _added.add(ref);
  void markMoved(CellKey ref) => _moved.add(ref);
  void markDeleted(CellHandle handle, CellKey key) {
    assert(!_deleted.contains(key), 'duplicate deletion of $key');
    _deleted.add(key);
    _deletedHandles[handle] = key;
  }

  void record(Lineage l) {
    assert(_deleted.contains(l.source), 'lineage source ${l.source} must be deleted');
    assert(_lineageBySource[l.source] == null, 'duplicate lineage for ${l.source}');
    lineage.add(l);
    _lineageBySource[l.source] = l;
    for (final p in l.products) _lineageByProduct[p] = l;
  }

  void recordAll(Iterable<Lineage> ls) => ls.forEach(record);

  void fold(TopologyDelta other) {
    ops.addAll(other.ops);
    _added.addAll(other._added);
    _deleted.addAll(other._deleted);
    _moved.addAll(other._moved);
    reads.addAll(other.reads);
    _readsAll |= other.readsAll;

    for (final l in other.lineage) {
      lineage.add(l);
      _lineageBySource[l.source] = l;
      for (final p in l.products) _lineageByProduct[p] = l;
    }
  }

  TopologyDelta copy() {
    final out = TopologyDelta();
    out._added.addAll(_added);
    out._deletedHandles.addAll(_deletedHandles);
    out._deleted.addAll(_deleted);
    out._moved.addAll(_moved);
    out._reads.addAll(_reads);
    out._readsAll = _readsAll;
    for (final l in lineage) out.record(l);
    return out;
  }
}
