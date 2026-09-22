part of '../program.dart';

final class Graph {
  Graph(this._evaluation);
  final Evaluation _evaluation;

  final _targeting = <CellRef, HashSet<StatementId>>{};
  final _readers = <CellRef, HashSet<StatementId>>{};
  final _writers = <CellRef, HashSet<StatementId>>{};
  final _dependencies = <StatementId, HashSet<StatementId>>{};
  final _dependents = <StatementId, HashSet<StatementId>>{};

  void add(Commit c) {
    final id = c.statement.id;
    for (final t in c.targets) _targeting.putIfAbsent(t, HashSet.new).add(id);
    for (final r in c.reads) _readers.putIfAbsent(r, HashSet.new).add(id);
    for (final w in c.writes) _writers.putIfAbsent(w, HashSet.new).add(id);
    for (final d in c.dependencies) {
      _dependencies.putIfAbsent(id, HashSet.new).add(d);
      _dependents.putIfAbsent(d, HashSet.new).add(id);
    }
  }

  void remove(Commit c) {
    final id = c.statement.id;
    for (final t in c.targets) _targeting[t]?.remove(id);
    for (final r in c.reads) _readers[r]?.remove(id);
    for (final r in c.writes) _writers[r]?.remove(id);
    for (final d in c.dependencies) {
      _dependents[d]?.remove(id);
      _dependencies[id]?.remove(d);
    }
  }

  void write(StatementId id, Iterable<CellRef> writes) {
    for (final w in writes) _writers.putIfAbsent(w, HashSet.new).add(id);
  }

  void overlapping(Commit c, Set<StatementId> out) {
    for (final r in c.reads) {
      final w = _writers[r];
      if (w != null) out.addAll(w);
    }

    for (final w in c.writes) {
      final t = _targeting[w];
      final r = _readers[w];
      final x = _writers[w];
      if (t != null) out.addAll(t);
      if (r != null) out.addAll(r);
      if (x != null) out.addAll(x);
    }

    final d = _dependents[c.statement.id];
    if (d != null) out.addAll(d);
  }

  Set<StatementId> readers(Iterable<CellRef> cells) {
    final out = <StatementId>{};
    readersOf(cells, out);
    return out;
  }

  void readersOf(Iterable<CellRef> cells, Set<StatementId> out) {
    for (final c in cells) {
      final r = _readers[c];
      if (r != null) out.addAll(r);
    }
  }

  Set<StatementId> targeting(Iterable<CellRef> cells) {
    final out = <StatementId>{};
    targetingOf(cells, out);
    return out;
  }

  void targetingOf(Iterable<CellRef> cells, Set<StatementId> out) {
    for (final c in cells) {
      final t = _targeting[c];
      if (t != null) out.addAll(t);
    }
  }

  void dependentsOf(StatementId id, Set<StatementId> out) {
    final d = _dependents[id];
    if (d != null) out.addAll(d);
  }

  Set<StatementId> dependents(Iterable<StatementId> ids) {
    final out = <StatementId>{};
    for (final id in ids) dependentsOf(id, out);
    return out;
  }

  /// Returns the dependents of given statements that appear before the specified top index.
  Set<StatementId> dependentsBefore(Set<StatementId> ids, int top) {
    final out = <StatementId>{};
    final work = [...ids];

    while (work.isNotEmpty) {
      final deps = dependents([work.removeLast()]);
      for (final d in deps) {
        final root = _evaluation.rootOf(d);
        final index = _evaluation.indexOf(root);
        if (index == null || index > top || ids.contains(root)) continue;
        if (out.add(root)) work.add(root);
      }
    }

    return out;
  }

  void dependenciesOf(StatementId id, Set<StatementId> out) {
    final d = _dependencies[id];
    if (d != null) out.addAll(d);
  }

  Set<StatementId> dependencies(Iterable<StatementId> ids) {
    final out = <StatementId>{};
    for (final id in ids) dependenciesOf(id, out);
    return out;
  }

  /// Returns the dependencies of given statements that appear after the specified bottom index.
  Set<StatementId> dependenciesAfter(Set<StatementId> ids, int bottom) {
    final out = <StatementId>{};
    final work = [...ids];

    while (work.isNotEmpty) {
      final deps = dependencies([work.removeLast()]);
      for (final d in deps) {
        final root = _evaluation.rootOf(d);
        final index = _evaluation.indexOf(root);
        if (index == null || index <= bottom || ids.contains(root)) continue;
        if (out.add(root)) work.add(root);
      }
    }

    return out;
  }
}
