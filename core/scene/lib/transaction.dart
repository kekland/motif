part of 'scene.dart';

final class SceneTransaction {
  SceneTransaction._(this.scene);

  final Scene scene;
  Program get program => scene.program;
  Evaluation get evaluation => scene.evaluation;

  var _closed = false;
  var _dirty = false;
  final _entries = <ProgramChange>[];
  late final _pass = evaluation.beginPass();

  // -------------------------------------------------------------------------------------------------------------------
  // Base ops
  // -------------------------------------------------------------------------------------------------------------------

  void apply(ProgramEdit edit) {
    _checkOpen();
    for (final change in edit.resolve(program).changes) {
      change.reapply(_pass);
      _entries.add(change);
    }
    _dirty = true;
  }

  T _route<T>(T Function() route) {
    _checkOpen();
    flush();
    return route();
  }

  void _edit(void Function(ProgramEditBuilder) build) => apply(.build(evaluation, build));

  T _resolveStatement<T extends Statement>(StatementId id) {
    final index = program.indexOf(id);
    if (index == null) throw StateError('statement $id does not exist in program');
    return program[index] as T;
  }

  T insert<T extends Statement>(T statement, {ProgramAnchor at = .end}) {
    _edit((b) => b.insert([statement], at: at));
    return statement;
  }

  void insertAll(List<Statement> statements, {ProgramAnchor at = .end}) {
    _edit((b) => b.insert(statements, at: at));
  }

  void remove(StatementId id) {
    _edit((b) => b.remove(id));
  }

  void replace(StatementId target, List<Statement> statements) {
    _edit((b) => b.replace(target, statements));
  }

  T update<T extends Statement>(StatementId target, T Function(T) update) {
    _checkOpen();

    final statement = _resolveStatement<T>(target);
    final updated = update(statement);
    if (statement == updated) return statement;
    replace(target, [updated]);
    return updated;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Modifiers
  // -------------------------------------------------------------------------------------------------------------------

  void attach(StatementId host, Modifier modifier) {
    _checkOpen();
    update<Statement>(host, (s) => s.copyWith(modifiers: [...s.modifiers, modifier]));
  }

  void detach(StatementId host, Modifier modifier) {
    _checkOpen();
    update<Statement>(host, (s) => s.copyWith(modifiers: s.modifiers.where((m) => m != modifier).toList()));
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Style/z-order
  // -------------------------------------------------------------------------------------------------------------------

  void decorate(CellRef ref, CellStylePartial decoration) {
    if (program.styles.of(ref) == decoration) return;
    _edit((b) => b.restyle(ref, decoration));
  }

  bool reorder(CellRef ref, ZAnchor anchor) {
    final edit = _route(() => evaluation.routeReorder(ref, anchor));
    if (edit == null) return false;
    apply(edit);
    return true;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // High-level ops
  // -------------------------------------------------------------------------------------------------------------------

  // void dissolve(Iterable<CellRef> targets) {
  //   _checkOpen();
  //   flush();
  //   final router = evaluation.routeDissolve(targets);
  //   if (router.isEmpty) return;
  //   final statement = DissolveStatement(.new(router.deleted));
  //   insert(statement);
  // }

  void delete(Iterable<CellRef> targets) {
    final edit = _route(() => evaluation.routeDelete(targets));
    apply(edit);
  }

  ReparentResult group(Iterable<CellRef> targets) {
    return _reparent(() => evaluation.routeGroup(targets));
  }

  void ungroup(StatementId group) {
    return apply(_route(() => evaluation.routeUngroup(group)));
  }

  Remap flatten(Iterable<StatementId> targets) {
    final edit = _route(() => evaluation.routeFlatten(targets));
    apply(edit);
    return edit.remap;
  }

  ReparentResult reparent(Iterable<CellRef> targets, FrameRef into, {StatementId? before}) {
    return _reparent(() => evaluation.routeReparent(targets, into, before: before));
  }

  ReparentResult _reparent(ReparentResult Function() route) {
    final result = _route(route);
    if (result case ReparentSuccess(:final edit)) apply(edit);
    return result;
  }

  GeneratorStatement wrapGenerator(List<StatementId> ids, {Generator? generator}) {
    final edit = _route(() => evaluation.routeGenerate(ids, generator ?? .empty()));
    apply(edit);
    return edit.created.single as GeneratorStatement;
  }

  // void embed(ProgramSlice slice) {
  //   _checkOpen();
  //   final anchor = program.resolveEmbeddingAnchor(slice);
  //   insertAll(slice.statements, anchor: anchor);
  // }

  void setLocalTransientTransform(StatementId id, Mat4? transform) {
    _checkOpen();
    if (!_pass.setLocalTransientTransform(id, transform)) return;
    _dirty = true;
  }

  void setGlobalTransientTransform(StatementId id, Mat4? transform) {
    _checkOpen();
    if (!_pass.setGlobalTransientTransform(id, transform)) return;
    _dirty = true;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------------------------------------------------------

  void _checkOpen() {
    if (_closed) throw StateError('transaction has already been committed or cancelled');
  }

  ProgramDelta _build() => .coalesced([.new(_entries)]);

  void commit({Object? mergeKey}) {
    _checkOpen();
    flush();
    _closed = true;
    scene._endTransaction(this);
    scene.history.commit(_build(), mergeKey: mergeKey);
  }

  void flush() {
    if (!_dirty) return;
    _pass.drain();
    _dirty = false;
  }

  void cancel() {
    _checkOpen();
    _closed = true;
    _rollback();
    scene._endTransaction(this);
  }

  void _rollback() {
    for (final change in _entries.reversed) change.unapply(_pass);
    _entries.clear();
    _pass.drain();
    _pass.reset();
    _dirty = false;
  }
}
