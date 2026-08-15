part of 'program.dart';

final class ProgramOp {
  ProgramOp({required this.anchor, required this.removed, required this.inserted});

  final Anchor anchor;
  final List<Statement> removed;
  final List<Statement> inserted;

  void reapply(Program program) => _execute(program, remove: removed, insert: inserted);
  void unapply(Program program) => _execute(program, remove: inserted, insert: removed);

  void _execute(Program program, {required List<Statement> remove, required List<Statement> insert}) {
    final index = anchor.resolve(program);
    if (index == null || index + remove.length > program.length) throw StateError('invalid anchor for program op');
    for (var i = 0; i < remove.length; i++) {
      if (program[index + i].id != remove[i].id) throw StateError('invalid anchor for program op');
    }

    for (var i = 0; i < remove.length; i++) program._removeAt(index);
    for (var i = 0; i < insert.length; i++) program._insertAt(index + i, insert[i]);
  }
}

final class ProgramDelta {
  ProgramDelta(this.ops);
  ProgramDelta.single(ProgramOp op) : this([op]);

  final List<ProgramOp> ops;
  bool get isEmpty => ops.isEmpty;

  void reapply(Program program) {
    for (final op in ops) op.reapply(program);
  }

  void unapply(Program program) {
    for (final op in ops.reversed) op.unapply(program);
  }
}
