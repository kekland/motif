part of 'kernel.dart';

final class TopologyDelta {
  TopologyDelta();

  final added = <CellKey>[];
  final deleted = <CellKey>[];

  final moved = <CellKey>[];
  final _movedSeen = <CellKey>{};

  final lineage = <CellKey, List<CellKey>>{};

  void markAdded(CellKey ref) => added.add(ref);
  void markDeleted(CellKey ref) => deleted.add(ref);
  void markMoved(CellKey ref) {
    if (_movedSeen.add(ref)) moved.add(ref);
  }

  void addLineage(CellKey source, List<CellKey> produced) {
    lineage[source] ??= [];
    lineage[source]!.addAll(produced);
  }

  void fold(TopologyDelta later) {
    final removedNow = later.deleted.toSet();
    added.removeWhere((r) {
      if (removedNow.contains(r)) {
        removedNow.remove(r);
        return true;
      }

      return false;
    });

    added.addAll(later.added);
    deleted.addAll(removedNow);

    final gone = deleted.toSet();
    moved.removeWhere(gone.contains);
    _movedSeen.removeWhere(gone.contains);

    for (final m in later.moved) markMoved(m);
    later.lineage.forEach(addLineage);
  }

  TopologyDelta copy() {
    final out = TopologyDelta();
    out.added.addAll(added);
    out.deleted.addAll(deleted);
    for (final m in moved) out.markMoved(m);
    lineage.forEach(out.addLineage);
    return out;
  }

  void copyLineageFrom(TopologyDelta other, {bool inverse = false}) {
    for (final entry in other.lineage.entries) {
      final source = entry.key;
      final products = entry.value;

      if (inverse) {
        for (final p in products) {
          if (p != source) addLineage(p, [source]);
        }
      } else {
        addLineage(source, products);
      }
    }
  }
}
