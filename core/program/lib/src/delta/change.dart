part of '../_program.dart';

sealed class ProgramChange {
  const ProgramChange();

  const factory empty() = EmptyChange;
  factory statement({
    required ProgramAnchor anchor,
    List<Statement> removed,
    List<Statement> inserted,
  }) = StatementChange;

  factory style(
    CellRef ref, {
    CellStylePartial? before,
    required CellStylePartial? after,
  }) = StyleChange;

  factory asset({
    required List<Asset> removed,
    required List<Asset> inserted,
  }) = AssetChange;

  factory settings({
    required ProgramSettings before,
    required ProgramSettings after,
  }) = SettingsChange;

  bool get isEmpty;

  void reapply(EvalPass pass);
  void unapply(EvalPass pass);

  ProgramChange? coalesce(ProgramChange next);
  bool commutesWith(ProgramChange other);
  ProgramChange invert();
}

final class const EmptyChange() extends ProgramChange {
  @override
  bool get isEmpty => true;

  @override
  void reapply(EvalPass pass) {}

  @override
  void unapply(EvalPass pass) {}

  @override
  ProgramChange? coalesce(ProgramChange next) => next;

  @override
  bool commutesWith(ProgramChange other) => true;

  @override
  EmptyChange invert() => this;
}

final class StatementChange extends ProgramChange {
  StatementChange({
    required this.anchor,
    this.removed = const [],
    this.inserted = const [],
  });

  final ProgramAnchor anchor;
  final List<Statement> removed;
  final List<Statement> inserted;

  @override
  bool get isEmpty => removed.isEmpty && inserted.isEmpty;

  @override
  void reapply(EvalPass pass) => _execute(pass, remove: removed, insert: inserted);

  @override
  void unapply(EvalPass pass) => _execute(pass, remove: inserted, insert: removed);

  void _execute(
    EvalPass pass, {
    required List<Statement> remove,
    required List<Statement> insert,
  }) {
    assert(anchor is! EndAnchor, 'ProgramOp cannot have EndAnchor');

    final evaluation = pass.evaluation;
    final program = evaluation.program;
    final index = anchor.resolve(program);
    if (index == null || index + remove.length > program.length) throw StateError('invalid anchor for program op');
    for (var i = 0; i < remove.length; i++) {
      if (program[index + i].id != remove[i].id) throw StateError('invalid anchor for program op');
    }

    pass.edit(index, remove, insert);
  }

  bool get isPureInsert => removed.isEmpty && inserted.length == 1;
  bool get isPureRemove => removed.length == 1 && inserted.isEmpty;
  bool get isPureReplace => removed.length == 1 && inserted.length == 1 && removed.single.id == inserted.single.id;

  StatementId? get insertedId => isPureInsert ? inserted.single.id : null;
  StatementId? get removedId => isPureRemove ? removed.single.id : null;
  StatementId? get replacedId => isPureReplace ? removed.single.id : null;

  @override
  ProgramChange? coalesce(ProgramChange next) {
    if (next is! StatementChange) return null;

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
  bool commutesWith(ProgramChange other) => switch (other) {
    StyleChange _ => true,
    EmptyChange _ => true,
    AssetChange _ => true,
    _ => false,
  };

  @override
  StatementChange invert() => .new(
    anchor: anchor,
    removed: inserted,
    inserted: removed,
  );

  StatementChange copyWith({ProgramAnchor? anchor, List<Statement>? removed, List<Statement>? inserted}) => .new(
    anchor: anchor ?? this.anchor,
    removed: removed ?? this.removed,
    inserted: inserted ?? this.inserted,
  );
}

final class StyleChange extends ProgramChange {
  new(
    this.ref, {
    this.before,
    required this.after,
  });

  final CellRef ref;
  final CellStylePartial? before;
  final CellStylePartial? after;

  @override
  bool get isEmpty => before == after;

  @override
  void reapply(EvalPass pass) {
    pass.program.styles.set(ref, after);
    pass.restyle(ref);
  }

  @override
  void unapply(EvalPass pass) {
    pass.program.styles.set(ref, before);
    pass.restyle(ref);
  }

  @override
  ProgramChange? coalesce(ProgramChange next) {
    if (next is! StyleChange) return null;
    if (next.ref != ref) return null;
    if (before == next.after) return .empty();
    return .style(ref, before: before, after: next.after);
  }

  @override
  bool commutesWith(ProgramChange other) => switch (other) {
    StyleChange d => d.ref != ref,
    _ => true,
  };

  @override
  StyleChange invert() => .new(ref, before: after, after: before);

  StyleChange copyWith({CellRef? ref, CellStylePartial? before, CellStylePartial? after}) => .new(
    ref ?? this.ref,
    before: before ?? this.before,
    after: after ?? this.after,
  );
}

final class AssetChange extends ProgramChange {
  new({required this.removed, required this.inserted});

  final List<Asset> removed;
  final List<Asset> inserted;

  @override
  AssetChange invert() => .new(removed: inserted, inserted: removed);

  @override
  bool get isEmpty => removed.isEmpty && inserted.isEmpty;

  @override
  void reapply(EvalPass pass) {
    pass.program.assetManifest.removeAll(removed);
    pass.program.assetManifest.insertAll(inserted);
  }

  @override
  void unapply(EvalPass pass) {
    pass.program.assetManifest.removeAll(inserted);
    pass.program.assetManifest.insertAll(removed);
  }

  @override
  AssetChange? coalesce(ProgramChange next) {
    if (next is! AssetChange) return null;
    return .new(
      removed: [...removed, ...next.removed],
      inserted: [...inserted, ...next.inserted],
    );
  }

  @override
  bool commutesWith(ProgramChange other) => switch (other) {
    AssetChange _ => false,
    _ => true,
  };
}

final class SettingsChange extends ProgramChange {
  new({
    required this.before,
    required this.after,
  });

  final ProgramSettings before;
  final ProgramSettings after;

  @override
  SettingsChange invert() => .new(before: after, after: before);

  @override
  bool get isEmpty => before == after;

  @override
  void reapply(EvalPass pass) {
    pass.program._settings = after;
  }

  @override
  void unapply(EvalPass pass) {
    pass.program._settings = before;
  }

  @override
  SettingsChange? coalesce(ProgramChange next) {
    if (next is! SettingsChange) return null;
    if (next.before != after) return null;
    return .new(before: before, after: next.after);
  }

  @override
  bool commutesWith(ProgramChange other) => switch (other) {
    SettingsChange d => d.before != after,
    _ => true,
  };
}
