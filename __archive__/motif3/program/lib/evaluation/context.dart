part of '../program.dart';

final class EvalContext {
  new(this.transaction, this._eval);

  final TopologyTransaction transaction;
  final Evaluation _eval;

  TopologyBundle get bundle => transaction.bundle;
  LineageIndex get lineage => _eval.lineage;

  Statement statement(StatementId id) => _eval._program.statement(id) ?? (throw UnresolvedStatement(id));

  final _resolved = <CellHandle>[];
  H handle<H extends CellHandle>(CellKey key) => maybeHandle<H>(key) ?? (throw UnresolvedCell(key));
  H? maybeHandle<H extends CellHandle>(CellKey key) {
    final h = bundle.handle<H>(key);
    if (h != null) _resolved.add(h);
    return h;
  }

  Iterable<CellKey> createdBy(StatementId id) => _eval.commits[id]?.delta.added ?? const [];
}

final class UnresolvedCell(final CellKey key) implements Exception {
  @override
  String toString() => 'unresolved cell key: $key';
}

final class UnresolvedStatement(final StatementId id) implements Exception {
  @override
  String toString() => 'unresolved statement: $id';
}
