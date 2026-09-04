part of '../program.dart';

final class LineageIndex {
  final _bySource = <CellKey, Lineage>{};
  final _byProduct = <CellKey, Lineage>{};

  void add(TopologyDelta d) {
    for (final l in d.lineage) {
      _bySource[l.source] = l;
      for (final p in l.products) _byProduct[p] = l;
    }
  }

  void remove(TopologyDelta d) {
    for (final l in d.lineage) {
      _bySource.remove(l.source);
      for (final p in l.products) _byProduct.remove(p);
    }
  }

  Lineage? of(CellKey source) => _bySource[source];
  Lineage? producerOf(CellKey product) => _byProduct[product];
  bool consumes(CellKey k) => _bySource.containsKey(k);
  bool produces(CellKey k) => _byProduct.containsKey(k);

  Iterable<CellKey> descendantsOf(CellKey key) sync* {
    final l = of(key);
    if (l == null) {
      yield key;
      return;
    }

    for (final p in l.products) yield* descendantsOf(p);
  }

  CellKey ancestorOf(CellKey key) {
    var current = producerOf(key);

    while (current != null) {
      final next = producerOf(current.source);
      if (next == null) return current.source;
      current = next;
    }
    
    return key;
  }
}
