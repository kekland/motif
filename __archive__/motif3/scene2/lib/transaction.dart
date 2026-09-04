// part of 'scene.dart';

// final class SceneTransaction {
//   SceneTransaction._(this.scene);

//   final Scene scene;
//   Program get program => scene.program;

//   var _closed = false;
//   final _ops = <ProgramOp>[];

//   // -------------------------------------------------------------------------------------------------------------------
//   // Base ops
//   // -------------------------------------------------------------------------------------------------------------------

//   void _recordStatementOp(ProgramAnchor anchor, {required List<Statement> inserted, required List<Statement> removed}) {
//     final index = anchor.resolve(program);
//     if (index == null) throw StateError('anchor $anchor does not resolve for program');

//     final ProgramAnchor resolvedAnchor = index == 0 ? .start() : .after(program[index - 1].id);
//     final resolvedOp = StatementOp(anchor: resolvedAnchor, inserted: inserted, removed: removed);
//     resolvedOp.reapply(program);
//     _ops.add(resolvedOp);
//   }

//   T _resolveStatement<T extends Statement>(StatementId id) {
//     final index = program.indexOf(id);
//     if (index == null) throw StateError('statement $id does not exist in program');
//     return program[index] as T;
//   }

//   T insert<T extends Statement>(T statement, {ProgramAnchor anchor = const .end()}) {
//     _checkOpen();
//     _recordStatementOp(anchor, inserted: [statement], removed: []);
//     return statement;
//   }

//   void insertAll(List<Statement> statements, {ProgramAnchor anchor = const .end()}) {
//     _checkOpen();
//     _recordStatementOp(anchor, inserted: statements, removed: []);
//   }

//   void remove(StatementId id) {
//     _checkOpen();
//     _recordStatementOp(.at(id), inserted: [], removed: [_resolveStatement(id)]);
//   }

//   void replace(StatementId target, List<Statement> statements) {
//     _checkOpen();
//     _recordStatementOp(.at(target), inserted: statements, removed: [_resolveStatement(target)]);
//   }

//   T update<T extends Statement>(StatementId target, T Function(T) update) {
//     _checkOpen();

//     final statement = _resolveStatement<T>(target);
//     final updated = update(statement);
//     if (statement == updated) return statement;
//     replace(target, [updated]);
//     return updated;
//   }

//   void decorate(Ref ref, CellStylePartial decoration) {
//     _checkOpen();
//     final before = program.styleOverrides.of(ref);
//     if (before == decoration) return;

//     final op = StyleOp(ref, before: before, after: decoration);
//     op.reapply(program);
//     _ops.add(op);
//   }

//   // -------------------------------------------------------------------------------------------------------------------
//   // High-level ops
//   // -------------------------------------------------------------------------------------------------------------------

//   void embed(ProgramSlice slice) {
//     _checkOpen();
//     final window = program.resolveEmbeddingWindow(slice);
//     if (window == null) throw StateError('slice $slice cannot be embedded in program');
//     insertAll(slice.statements, anchor: .after(program[window.upper - 1].id));
//   }

//   // -------------------------------------------------------------------------------------------------------------------
//   // Lifecycle
//   // -------------------------------------------------------------------------------------------------------------------

//   void _checkOpen() {
//     if (_closed) throw StateError('transaction has already been committed or cancelled');
//   }
// }
