part of '../scene.dart';

final class SceneTransaction {
  SceneTransaction._(this.scene);
  final Scene scene;

  final _ops = <ProgramOp>[];

  Program get program => scene.program;

  T insert<T extends Statement>(T statement, {Anchor anchor = const .end()}) {
    final index = anchor.resolve(program);
    if (index == null) throw StateError('anchor $anchor does not resolve for program');
    _record(index, inserted: [statement], removed: []);
    return statement;
  }

  void remove(StatementId id) {
    final index = program.indexOf(id);
    if (index == null) throw StateError('statement $id does not exist in program');
    _record(index, inserted: [], removed: [program[index]]);
  }

  void replace(StatementId target, List<Statement> statements) {
    final index = program.indexOf(target);
    if (index == null) throw StateError('statement $target does not exist in program');
    _record(index, inserted: statements, removed: [program[index]]);
  }

  void _rollback() {
    for (final op in _ops.reversed) op.unapply(program);
    _ops.clear();
  }

  void _record(int index, {required List<Statement> inserted, required List<Statement> removed}) {
    final anchor = index == 0 ? const Anchor.start() : Anchor.after(program[index - 1].id);
    final op = ProgramOp(anchor: anchor, removed: removed, inserted: inserted);
    op.reapply(program);
    _ops.add(op);
  }

  SceneDelta _build() => .program(.new(_ops));
}
