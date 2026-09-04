part of '../program.dart';

final class DependencyGraph {
  // key → applied commits touching it; used only inside attach/detach.
  final _readers = HashMap<CellKey, Set<StatementId>>();
  final _writers = HashMap<CellKey, Set<StatementId>>();

  // The product: statement → statements whose footprint overlaps its own. Symmetric; direction
  // (who must yield to whom) is decided by program order at traversal time.
  final _edges = HashMap<StatementId, Set<StatementId>>();

  void attach(Commit c) {
    final id = c.statement.id;
    final linked = <StatementId>{};
    for (final k in c.writes) {
      linked.addAll(_readers[k] ?? const {}); // they read what it writes
      linked.addAll(_writers[k] ?? const {}); // write-write
    }
    for (final k in c.reads) {
      linked.addAll(_writers[k] ?? const {}); // it reads what they write
    }
    linked.remove(id);

    _edges[id] = linked;
    for (final o in linked) _edges[o]!.add(id);
    for (final k in c.reads) (_readers[k] ??= {}).add(id);
    for (final k in c.writes) (_writers[k] ??= {}).add(id);
  }

  void detach(Commit c) {
    final id = c.statement.id;
    for (final k in c.reads) _readers[k]?.remove(id);
    for (final k in c.writes) _writers[k]?.remove(id);
    for (final o in _edges.remove(id) ?? const <StatementId>{}) _edges[o]?.remove(id);
  }

  Iterable<StatementId> neighboursOf(StatementId id) => _edges[id] ?? const {};
  Set<StatementId> writersOf(Iterable<CellKey> keys) => {
    for (final k in keys) ...?_writers[k],
  };
}
