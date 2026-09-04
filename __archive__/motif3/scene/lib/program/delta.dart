part of 'program.dart';

final class ProgramOp {
  ProgramOp({required this.anchor, required this.removed, required this.inserted}) {
    assert(anchor is! EndAnchor, 'ProgramOp cannot have StartAnchor or EndAnchor');
  }

  ProgramOp.empty({required this.anchor}) : removed = const [], inserted = const [];

  final Anchor anchor;
  final List<Statement> removed;
  final List<Statement> inserted;

  bool get isEmpty => removed.isEmpty && inserted.isEmpty;

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

  bool get isPureInsert => removed.isEmpty && inserted.length == 1;
  bool get isPureRemove => removed.length == 1 && inserted.isEmpty;
  bool get isPureReplace => removed.length == 1 && inserted.length == 1 && removed.single.id == inserted.single.id;

  StatementId? get insertedId => isPureInsert ? inserted.single.id : null;
  StatementId? get removedId => isPureRemove ? removed.single.id : null;
  StatementId? get replacedId => isPureReplace ? removed.single.id : null;

  bool touches(StatementId id) => removed.any((s) => s.id == id) || inserted.any((s) => s.id == id);

  ProgramOp? coalesce(ProgramOp next) {
    if (isPureReplace && next.isPureReplace && replacedId == next.replacedId) {
      if (removed.single == next.inserted.single) return .empty(anchor: anchor);
      return .new(anchor: next.anchor, removed: removed, inserted: next.inserted);
    }

    if (next.isPureReplace && isPureInsert && insertedId == next.replacedId) {
      return .new(anchor: anchor, removed: const [], inserted: next.inserted);
    }

    if (isPureInsert && next.isPureRemove && insertedId == next.removedId) {
      return .empty(anchor: anchor);
    }

    return null;
  }

  bool commutesWith(ProgramOp other) {
    if (isPureReplace && other.isPureReplace) return replacedId != other.replacedId;
    return false;
  }

  ProgramOp invert() => .new(anchor: anchor, removed: inserted, inserted: removed);
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

  ProgramDelta coalesce(ProgramDelta next) {
    final out = [...ops];
    for (final nextOp in next.ops) _fold(out, nextOp);
    return .new(out);
  }

  ProgramDelta invert() => .new(ops.reversed.map((op) => op.invert()).toList());

  static void _fold(List<ProgramOp> ops, ProgramOp op) {
    if (op.isEmpty) return;

    for (var i = ops.length - 1; i >= 0; i--) {
      final merged = ops[i].coalesce(op);
      if (merged != null) {
        if (merged.isEmpty) {
          ops.removeAt(i);
        } else {
          ops[i] = merged;
        }
        return;
      }
      if (!ops[i].commutesWith(op)) break;
    }

    ops.add(op);
  }
}
