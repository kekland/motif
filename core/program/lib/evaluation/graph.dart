part of '../program.dart';

final class Graph {
  final _targeting = <CellRef, HashSet<StatementId>>{};
  final _readers = <CellRef, HashSet<StatementId>>{};
  final _writers = <CellRef, HashSet<StatementId>>{};
  final _dependents = <StatementId, HashSet<StatementId>>{};

  void add(Commit c) {
    final id = c.statement.id;
    for (final t in c.targets) _targeting.putIfAbsent(t, HashSet.new).add(id);
    for (final r in c.reads) _readers.putIfAbsent(r, HashSet.new).add(id);
    for (final w in c.writes) _writers.putIfAbsent(w, HashSet.new).add(id);
    for (final d in c.dependencies) _dependents.putIfAbsent(d, HashSet.new).add(id);
  }

  void remove(Commit c) {
    final id = c.statement.id;
    for (final t in c.targets) _targeting[t]?.remove(id);
    for (final r in c.reads) _readers[r]?.remove(id);
    for (final r in c.writes) _writers[r]?.remove(id);
    for (final d in c.dependencies) _dependents[d]?.remove(id);
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

  void readersOf(Iterable<CellRef> cells, Set<StatementId> out) {
    for (final c in cells) {
      final r = _readers[c];
      if (r != null) out.addAll(r);
    }
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
}
