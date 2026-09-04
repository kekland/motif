part of 'scene.dart';

final class SceneTransaction {
  SceneTransaction._(this.scene);

  final Scene scene;
  Program get program => scene.program;
  Evaluation get evaluation => scene._evaluation;

  var _closed = false;
  final _entries = <ProgramDelta>[];

  // -------------------------------------------------------------------------------------------------------------------
  // Base ops
  // -------------------------------------------------------------------------------------------------------------------

  void _recordStatementOp(
    ProgramAnchor anchor, {
    required List<Statement> inserted,
    required List<Statement> removed,
  }) {
    final index = anchor.resolve(program);
    if (index == null) throw StateError('anchor $anchor does not resolve for program');

    final ProgramAnchor resolvedAnchor = index == 0 ? .start() : .after(program[index - 1].id);
    final resolvedOp = StatementOp(anchor: resolvedAnchor, inserted: inserted, removed: removed);
    _entries.add(resolvedOp.reapply(evaluation));
  }

  T _resolveStatement<T extends Statement>(StatementId id) {
    final index = program.indexOf(id);
    if (index == null) throw StateError('statement $id does not exist in program');
    return program[index] as T;
  }

  T insert<T extends Statement>(T statement, {ProgramAnchor anchor = const .end()}) {
    _checkOpen();
    _recordStatementOp(anchor, inserted: [statement], removed: []);
    return statement;
  }

  void insertAll(List<Statement> statements, {ProgramAnchor anchor = const .end()}) {
    _checkOpen();
    _recordStatementOp(anchor, inserted: statements, removed: []);
  }

  void remove(StatementId id) {
    _checkOpen();
    _recordStatementOp(.at(id), inserted: [], removed: [_resolveStatement(id)]);
  }

  void replace(StatementId target, List<Statement> statements) {
    _checkOpen();
    _recordStatementOp(.at(target), inserted: statements, removed: [_resolveStatement(target)]);
  }

  T update<T extends Statement>(StatementId target, T Function(T) update) {
    _checkOpen();

    final statement = _resolveStatement<T>(target);
    final updated = update(statement);
    if (statement == updated) return statement;
    replace(target, [updated]);
    return updated;
  }

  void decorate(CellKey key, CellStylePartial decoration) {
    _checkOpen();
    final before = program.styleOverrides.of(key);
    if (before == decoration) return;

    final op = StyleOp(key, before: before, after: decoration);
    _entries.add(op.reapply(evaluation));
  }

  // -------------------------------------------------------------------------------------------------------------------
  // High-level ops
  // -------------------------------------------------------------------------------------------------------------------

  void embed(ProgramSlice slice) {
    _checkOpen();
    final anchor = program.resolveEmbeddingAnchor(slice);
    insertAll(slice.statements, anchor: anchor);
  }

  void attach(StatementId id, Statement modifier) {
    _checkOpen();
    update<Statement>(id, (s) => s.copyWith(modifiers: [...s.modifiers, modifier]));
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------------------------------------------------------

  void _checkOpen() {
    if (_closed) throw StateError('transaction has already been committed or cancelled');
  }

  ProgramDelta _build() => .coalesced(_entries);

  void commit({Object? mergeKey}) {
    _checkOpen();
    _closed = true;
    scene._endTransaction(this);
    // scene.history.commit(_build(), mergeKey: mergeKey);
  }

  void cancel() {
    _checkOpen();
    _closed = true;
    _rollback();
    scene._endTransaction(this);
  }

  void _rollback() {
    for (final entry in _entries.reversed) entry.unapply(evaluation);
    _entries.clear();
  }
}
