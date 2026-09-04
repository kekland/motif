part of '../program.dart';

sealed class ProgramOp {
  const ProgramOp();

  const factory ProgramOp.empty() = EmptyOp;
  factory ProgramOp.statement({
    required ProgramAnchor anchor,
    required List<Statement> removed,
    required List<Statement> inserted,
  }) = StatementOp;

  factory ProgramOp.style(
    Ref ref, {
    required CellStylePartial? before,
    required CellStylePartial? after,
  }) = StyleOp;

  bool get isEmpty;
  void reapply(Program program);
  void unapply(Program program);

  ProgramOp? coalesce(ProgramOp next);
  bool commutesWith(ProgramOp other);
  ProgramOp invert();
}

final class const EmptyOp() extends ProgramOp {
  @override
  bool get isEmpty => true;

  @override
  void reapply(Program program) {}

  @override
  void unapply(Program program) {}

  @override
  ProgramOp? coalesce(ProgramOp next) => next;

  @override
  bool commutesWith(ProgramOp other) => true;

  @override
  EmptyOp invert() => this;
}

final class StatementOp extends ProgramOp {
  StatementOp({required this.anchor, required this.removed, required this.inserted}) {
    assert(anchor is! EndAnchor, 'ProgramOp cannot have EndAnchor');
  }

  final ProgramAnchor anchor;
  final List<Statement> removed;
  final List<Statement> inserted;

  @override
  bool get isEmpty => removed.isEmpty && inserted.isEmpty;

  @override
  void reapply(Program program) => _execute(program, remove: removed, insert: inserted);

  @override
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

  @override
  ProgramOp? coalesce(ProgramOp next) {
    if (next is! StatementOp) return null;

    if (isPureReplace && next.isPureReplace && replacedId == next.replacedId) {
      if (removed.single == next.inserted.single) return .empty();
      return .statement(anchor: next.anchor, removed: removed, inserted: next.inserted);
    }

    if (next.isPureReplace && isPureInsert && insertedId == next.replacedId) {
      return .statement(anchor: anchor, removed: const [], inserted: next.inserted);
    }

    if (isPureInsert && next.isPureRemove && insertedId == next.removedId) {
      return .empty();
    }

    return null;
  }

  @override
  bool commutesWith(ProgramOp other) => switch (other) {
    StyleOp _ => true,
    EmptyOp _ => true,
    _ => false,
  };

  @override
  StatementOp invert() => .new(anchor: anchor, removed: inserted, inserted: removed);

  StatementOp withAnchor(ProgramAnchor anchor) => .new(anchor: anchor, removed: removed, inserted: inserted);
}

final class StyleOp extends ProgramOp {
  new(
    this.ref, {
    required this.before,
    required this.after,
  });

  final Ref ref;
  final CellStylePartial? before;
  final CellStylePartial? after;

  @override
  bool get isEmpty => before == after;

  @override
  void reapply(Program program) => program.styleOverrides.set(ref, after);

  @override
  void unapply(Program program) => program.styleOverrides.set(ref, before);

  @override
  ProgramOp? coalesce(ProgramOp next) {
    if (next is! StyleOp) return null;
    if (next.ref != ref) return null;
    if (before == next.after) return .empty();
    return .style(ref, before: before, after: next.after);
  }

  @override
  bool commutesWith(ProgramOp other) => switch (other) {
    StyleOp d => d.ref != ref,
    StatementOp _ => true,
    EmptyOp _ => true,
  };

  @override
  StyleOp invert() => .new(ref, before: after, after: before);
}
