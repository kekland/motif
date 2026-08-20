part of '../scene.dart';

final class SceneTransaction {
  SceneTransaction._(this.scene);
  final Scene scene;

  var _closed = false;
  final _entries = <SceneDelta>[];

  Program get program => scene.program;

  // -------------------------------------------------------------------------------------------------------------------
  // Program ops
  // -------------------------------------------------------------------------------------------------------------------

  T insert<T extends Statement>(T statement, {Anchor anchor = const .end()}) {
    _checkOpen();

    final index = anchor.resolve(program);
    if (index == null) throw StateError('anchor $anchor does not resolve for program');
    _recordOp(index, inserted: [statement], removed: []);
    return statement;
  }

  void remove(StatementId id) {
    _checkOpen();

    final index = program.indexOf(id);
    if (index == null) throw StateError('statement $id does not exist in program');
    _recordOp(index, inserted: [], removed: [program[index]]);
  }

  void replace(StatementId target, List<Statement> statements) {
    _checkOpen();

    final index = program.indexOf(target);
    if (index == null) throw StateError('statement $target does not exist in program');
    _recordOp(index, inserted: statements, removed: [program[index]]);
  }

  void update<T extends Statement>(StatementId target, T Function(T) update) {
    _checkOpen();

    final statement = program.byId<T>(target);
    if (statement == null) throw StateError('statement $target does not exist in program');
    final updated = update(statement);
    if (statement == updated) return;
    return replace(target, [updated]);
  }

  void _recordOp(int index, {required List<Statement> inserted, required List<Statement> removed}) {
    final anchor = index == 0 ? const Anchor.start() : Anchor.after(program[index - 1].id);
    final op = ProgramOp(anchor: anchor, removed: removed, inserted: inserted);
    op.reapply(program);
    _entries.add(.program(.new([op])));
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Decoration
  // -------------------------------------------------------------------------------------------------------------------

  void decorate(Ref ref, CellStylePartial decoration) {
    _checkOpen();

    final before = scene.styleOverrides.of(ref);
    if (before == decoration) return;

    final delta = SceneDelta.decoration(ref, before, decoration);
    delta.reapply(scene);
    _entries.add(delta);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------------------------------------------------------

  void preview() {
    _checkOpen();
    scene.evaluate();
  }

  void commit({Object? mergeKey}) {
    _checkOpen();
    _closed = true;
    scene._endTransaction(this);
    scene.history.commit(_build(), mergeKey: mergeKey);
  }

  void cancel() {
    _checkOpen();
    _closed = true;
    _rollback();
    scene._endTransaction(this);
    scene.evaluate();
  }

  void _rollback() {
    for (final entry in _entries.reversed) entry.unapply(scene);
    _entries.clear();
  }

  void _checkOpen() {
    if (_closed) throw StateError('transaction has already been committed or cancelled');
  }

  SceneDelta _build() => .coalesced(_entries);
}
