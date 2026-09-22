part of '../../_program.dart';

/// A [LineageIndex] keeps track of the cell lineage produced by [Statement]s.
final class LineageIndex {
  LineageIndex(this.evaluation);
  final Evaluation evaluation;

  final _bySource = <CellRef, Lineage>{};
  final _byProduct = <CellRef, Lineage>{};

  void attach(Commit c) {
    for (final l in c.lineage) {
      _bySource[l.source] = l;
      for (final p in l.products) _byProduct[p] = l;
    }
  }

  void detach(Commit c) {
    for (final l in c.lineage) {
      _bySource.remove(l.source);
      for (final p in l.products) _byProduct.remove(p);
    }
  }

  /// Returns the [Lineage] that produced the given [product], if any.
  Lineage? producerOf(CellRef product) => _byProduct[product];

  /// Returns all live descendant references of the given [ref].
  Iterable<R> descendantsOf<R extends Ref>(R ref) => switch (ref) {
    CellRef c => cellDescendantsOf(c) as Iterable<R>,
    CovertexRef e => covertexDescendantsOf(e) as Iterable<R>,
  };

  /// Returns all live descendant cells of the given [ref].
  Iterable<CellRef> cellDescendantsOf(CellRef ref) sync* {
    if (evaluation.bundle.isLive(ref)) {
      yield ref;
      return;
    }

    final l = _bySource[ref];
    if (l == null) return;
    for (final p in l.products) yield* cellDescendantsOf(p);
  }

  /// Returns all live descendant covertices of the given [ref].
  Iterable<CovertexRef> covertexDescendantsOf(CovertexRef ref) sync* {
    if (evaluation.bundle.isLive(ref.edge)) {
      yield ref;
      return;
    }

    final l = _bySource[ref.edge];
    if (l == null) return;
    final next = ref.isStart ? l.products.first : l.products.last;
    yield* covertexDescendantsOf(.new(next.asEdge, isStart: ref.isStart));
  }
}
