part of '../_program.dart';

/// A [Commit] represents a snapshot of captured changes resulting from a [Statement]'s execution.
final class Commit {
  Commit.from(
    this._statement,
    this.ops,
    Delta delta,
    EvalContext context, {
    required this.topologyInputs,
    required this.geometryInputs,
  }) : added = delta.added,
       deleted = delta.deleted,
       lineage = delta.lineage,
       moved = HashSet.of(delta.moved),
       _writes = HashSet.of(delta.writes),
       dependencies = HashSet.of(topologyInputs.map((r) => r.statementId)),
       resolutions = context._resolutions,
       styles = context._styles,
       error = null {
    for (final s in _statement.selectors) dependencies.addAll(s.dependencies);
  }

  Commit.error(this._statement, {required this.topologyInputs, required this.geometryInputs})
    : ops = const [],
      added = const {},
      deleted = const {},
      lineage = const [],
      moved = const {},
      _writes = const {},
      dependencies = HashSet.of(topologyInputs.map((r) => r.statementId)),
      resolutions = const {},
      styles = const {},
      error = Object() {
    for (final s in _statement.selectors) dependencies.addAll(s.dependencies);
  }

  Statement _statement;
  Statement get statement => _statement;

  final List<OpRecord> ops;

  /// Topological inputs of the statement. If any of these cells are added or removed, the statement reruns.
  final Set<CellRef> topologyInputs;

  /// Geometry inputs of the statement. If any of these cells change, the statement refreshes.
  final Set<CellRef> geometryInputs;

  /// List of dependencies for the statement.
  final HashSet<StatementId> dependencies;

  final Map<Selector, Object?> resolutions;
  final Map<CellRef, CellStyle> styles;

  final Set<CellRef> added, deleted;
  final Set<CellRef> moved;
  final List<Lineage> lineage;

  final Object? error;
  bool get failed => error != null;

  final Set<CellRef> _writes;
  Set<CellRef> get writes => _writes;

  /// Refreshes the commit when the statement is refreshed.
  ///
  /// Returns a set of cells that have been moved as a result of the refresh.
  Set<CellRef> refresh(Statement statement, Delta delta, Map<CellRef, CellStyle> styles) {
    _statement = statement;
    this.styles.addAll(styles);

    final newlyMoved = HashSet<CellRef>();
    for (final r in delta.moved) {
      if (moved.add(r)) {
        _writes.add(r);
        newlyMoved.add(r);
      }
    }

    return newlyMoved;
  }
}
