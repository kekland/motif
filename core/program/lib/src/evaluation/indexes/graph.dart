part of '../../_program.dart';

/// A [DependencyGraph] represents the relationships between [Statement]s.
final class DependencyGraph {
  DependencyGraph(this.evaluation);
  final Evaluation evaluation;

  final _topologyReaders = <CellRef, HashSet<StatementId>>{};
  final _geometryReaders = <CellRef, HashSet<StatementId>>{};
  final _writers = <CellRef, HashSet<StatementId>>{};
  final _dependencies = <StatementId, HashSet<StatementId>>{};
  final _dependents = <StatementId, HashSet<StatementId>>{};

  void attach(Commit c) {
    final id = c.statement.id;
    for (final r in c.topologyInputs) _topologyReaders.putIfAbsent(r, HashSet.new).add(id);
    for (final r in c.geometryInputs) _geometryReaders.putIfAbsent(r, HashSet.new).add(id);
    for (final r in c.writes) _writers.putIfAbsent(r, HashSet.new).add(id);
    for (final d in c.dependencies) {
      _dependencies.putIfAbsent(id, HashSet.new).add(d);
      _dependents.putIfAbsent(d, HashSet.new).add(id);
    }
  }

  void detach(Commit c) {
    final id = c.statement.id;
    for (final r in c.topologyInputs) _topologyReaders[r]?.remove(id);
    for (final r in c.geometryInputs) _geometryReaders[r]?.remove(id);
    for (final r in c.writes) _writers[r]?.remove(id);
    for (final d in c.dependencies) {
      _dependencies[id]?.remove(d);
      _dependents[d]?.remove(id);
    }
  }

  void onWrite(StatementId id, Iterable<CellRef> writes) {
    for (final w in writes) _writers.putIfAbsent(w, HashSet.new).add(id);
  }

  Set<StatementId> overlapping(Commit c) {
    final out = <StatementId>{};
    overlappingOf(c, out);
    return out;
  }

  void overlappingOf(Commit c, Set<StatementId> out) {
    for (final r in c.topologyInputs) out.addAll(_writers[r] ?? const {});
    for (final r in c.geometryInputs) out.addAll(_writers[r] ?? const {});
    for (final w in c.writes) {
      out.addAll(_topologyReaders[w] ?? const {});
      out.addAll(_geometryReaders[w] ?? const {});
      out.addAll(_writers[w] ?? const {});
    }
  }

  Set<StatementId> topologyReaders(Iterable<CellRef> cells) {
    final out = <StatementId>{};
    for (final c in cells) {
      final r = _topologyReaders[c];
      if (r != null) out.addAll(r);
    }
    return out;
  }

  Set<StatementId> geometryReaders(Iterable<CellRef> cells) {
    final out = <StatementId>{};
    for (final c in cells) {
      final t = _geometryReaders[c];
      if (t != null) out.addAll(t);
    }
    return out;
  }

  Set<StatementId> dependencies(Iterable<StatementId> ids) {
    final out = <StatementId>{};
    for (final id in ids) {
      final d = _dependencies[id];
      if (d != null) out.addAll(d);
    }
    return out;
  }

  Set<StatementId> dependents(Iterable<StatementId> ids) {
    final out = <StatementId>{};
    for (final id in ids) {
      final d = _dependents[id];
      if (d != null) out.addAll(d);
    }
    return out;
  }

}
