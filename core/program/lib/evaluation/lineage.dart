part of '../program.dart';

final class LineageIndex {
  final _bySource = <CellRef, Lineage>{};
  final _byProduct = <CellRef, Lineage>{};

  void add(Commit c) {
    for (final l in c.lineage) {
      _bySource[l.source] = l;
      for (final p in l.products) _byProduct[p] = l;
    }
  }

  void remove(Commit c) {
    for (final l in c.lineage) {
      _bySource.remove(l.source);
      for (final p in l.products) _byProduct.remove(p);
    }
  }

  Lineage? producerOf(CellRef product) => _byProduct[product];

  Iterable<CellRef> descendantsOf(CellRef ref, Bundle bundle) sync* {
    if (bundle.isLive(ref)) {
      yield ref;
      return;
    }

    final l = _bySource[ref];
    if (l == null) return;
    for (final p in l.products) yield* descendantsOf(p, bundle);
  }

  // CellRef ancestorOf(CellRef key) {
  //   var current = key;

  //   while (true) {
  //     final entry = _byProduct[current];
  //     if (entry == null) return current;
  //     current = entry.$1.source;
  //   }
  // }
}
