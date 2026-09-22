part of '_program.dart';

/// A proposed edit to a program. Produced by routers.
final class ProgramEdit {
  ProgramEdit({
    this.changes = const [],
    this.created = const [],
    Remap? remap,
  }) : remap = remap ?? .empty();

  ProgramEdit.empty() : this();

  static ProgramEditBuilder builder(Evaluation evaluation) => .new(evaluation);
  static ProgramEdit build(Evaluation evaluation, void Function(ProgramEditBuilder) build) {
    final builder = ProgramEdit.builder(evaluation);
    build(builder);
    return builder.build();
  }

  final List<ProgramChange> changes;
  final List<Statement> created;
  final Remap remap;

  ProgramChange _resolveChange(Program projection, ProgramChange c) => switch (c) {
    StatementChange c => _resolveStatementChange(projection, c),
    StyleChange c => _resolveStyleChange(projection, c),
    ZOrderChange c => _resolveZOrderChange(projection, c),
    EmptyChange() => c,
  };

  StatementChange _resolveStatementChange(Program projection, StatementChange c) {
    final index = c.anchor.resolve(projection);
    if (index == null) throw StateError('anchor ${c.anchor} does not resolve for projected program');

    final removed = <Statement>[];
    for (var i = 0; i < c.removed.length; i++) {
      final s = projection[index + i];
      if (s.id != c.removed[i].id) throw StateError('removed run does not match projected program');
      removed.add(s);
    }

    final resolved = c.copyWith(
      anchor: switch (index) {
        0 => .start,
        _ => .after(projection[index - 1].id),
      },
      removed: removed,
    );

    projection._replace(index, removed, c.inserted);
    return resolved;
  }

  StyleChange _resolveStyleChange(Program projection, StyleChange c) {
    final before = projection.styles.of(c.key);
    projection.styles.set(c.key, c.after);
    return c.copyWith(before: before);
  }

  ZOrderChange _resolveZOrderChange(Program projection, ZOrderChange c) {
    final before = projection.zOrders.of(c.key);
    projection.zOrders.set(c.key, c.after);
    return c.copyWith(before: before);
  }

  ProgramDelta resolve(Program program) {
    final projection = program.clone();
    final resolvedChanges = changes.map((c) => _resolveChange(projection, c)).toList();
    return ProgramDelta(resolvedChanges);
  }
}

/// A builder for program edits.
final class ProgramEditBuilder {
  ProgramEditBuilder(this._evaluation);

  final Evaluation _evaluation;
  Program get _program => _evaluation.program;

  final _removed = <StatementId>{};
  final _changes = <ProgramChange>[];
  final _remap = Remap.empty();

  void insert(List<Statement> statements, {ProgramAnchor at = .end}) {
    for (final s in statements) {
      if (_program.contains(s.id)) _removed.add(s.id);
    }

    _changes.add(.statement(anchor: at, inserted: statements));
  }

  void replace(StatementId target, List<Statement> statements) {
    final current = _statement(target);
    if (statements.length == 1 && identical(statements.single, current)) return;
    _changes.add(.statement(anchor: .at(target), removed: [_statement(target)], inserted: statements));
  }

  void remove(StatementId id) => _removed.add(id);
  void removeAll(Iterable<StatementId> ids) => _removed.addAll(ids);

  void restyle(CellRef ref, CellStylePartial? style) => _changes.add(.style(ref, after: style));
  void reorder(CellRef ref, ZAnchor? after) => _changes.add(.zOrder(ref, after: after));

  void remap(Remap remap) => _remap.add(remap);

  ProgramEdit build() {
    assert(
      _changes.whereType<StatementChange>().every((c) => c.removed.every((s) => !_removed.contains(s.id))),
      'a statement cannot be both replaced and removed',
    );

    final changes = <ProgramChange>[];
    final created = <Statement>[];

    for (final run in _removalRuns()) {
      changes.add(.statement(anchor: .at(run.first.id), removed: run));
    }

    for (final c in _changes) {
      if (c is! StatementChange) {
        changes.add(c);
        continue;
      }

      final inserted = c.inserted.map((s) => s.remap(_remap)).toList();
      changes.add(c.copyWith(anchor: _resolvedAnchor(c.anchor), inserted: inserted));
      for (final s in c.inserted) {
        if (!_program.contains(s.id)) created.add(s);
      }
    }

    for (final h in _evaluation.graph.topologyReaders(_remap.cells)) {
      if (_removed.contains(h)) continue;
      final s = _program.statement(h);
      if (s == null) continue;
      final r = s.remap(_remap);
      if (!identical(r, s)) changes.add(.statement(anchor: .at(h), removed: [s], inserted: [r]));
    }

    return ProgramEdit(changes: changes, created: created, remap: _remap);
  }

  ProgramAnchor _resolvedAnchor(ProgramAnchor anchor) {
    final id = switch (anchor) {
      AtAnchor a => a.id,
      AfterAnchor a => a.id,
      _ => null,
    };

    if (id == null || !_removed.contains(id)) return anchor;
    for (var i = _index(id) - 1; i >= 0; i--) {
      final previous = _program[i].id;
      if (!_removed.contains(previous)) return .after(previous);
    }

    return .start;
  }

  List<List<Statement>> _removalRuns() {
    final removedIndices = [for (final id in _removed) _index(id)];
    removedIndices.sort();

    final runs = <List<Statement>>[];
    for (var i = 0; i < removedIndices.length;) {
      final run = <Statement>[];
      var index = removedIndices[i];
      do {
        run.add(_program[index]);
        i++;
        index++;
      } while (i < removedIndices.length && removedIndices[i] == index);
      runs.add(run);
    }

    return runs;
  }

  int _index(StatementId id) => _program.indexOf(id) ?? (throw StateError('$id not found in program'));
  Statement _statement(StatementId id) => _program[_index(id)];
}
