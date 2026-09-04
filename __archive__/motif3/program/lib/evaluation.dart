part of 'program.dart';

final class Evaluation {
  Evaluation(this._program) {
    for (final s in _program.statements) _execute(s);
  }

  Program _program;
  Program get program => _program;
  final bundle = TopologyBundle();
  final style = StyleTable();
  final commits = <StatementId, Commit>{};
  final failures = <StatementId, Object>{};
  final lineage = LineageIndex();
  // final footprint = FootprintIndex();
  final graph = DependencyGraph();

  bool isApplied(StatementId id) => commits.containsKey(id);

  Commit _execute(Statement s) {
    final c = _performExecute(s);
    graph.attach(c);
    return c;
  }

  Commit _performExecute(Statement s) {
    final txn = bundle.beginTransaction(namespace: s.id.value);
    final context = EvalContext(txn, this);
    Iterable<Statement> next;

    try {
      next = s.execute(context).toList();
    } catch (e) {
      txn.abort();
      failures[s.id] = e;

      final commit = Commit(s, txn.delta, const []);
      commits[s.id] = commit;
      return commit;
    }

    final own = txn.commit();
    final reads = <CellKey>{};
    for (final h in context._resolved) {
      reads.add(bundle.key(h));
      for (final n in bundle.neighbors(h)) reads.add(bundle.key(n)); // dependents + dependencies, one ring
      for (var f = bundle.parentOf(h); f != null; f = bundle.parentOf(f)) {
        if (f.index == .root) break;
        reads.add(bundle.frameKey(f));
      }
    }
    own.reads.addAll(reads);

    failures.remove(s.id);
    lineage.add(own);

    final children = [for (final child in next) _performExecute(child)];
    final commit = Commit(s, own, children);
    commits[s.id] = commit;
    return commit;
  }

  Commit? _revert(StatementId id) {
    final c = commits[id];
    if (c == null) return null;
    for (final n in c.subtree) {
      commits.remove(n.statement.id);
      failures.remove(n.statement.id);
    }

    final txn = bundle.beginTransaction();
    for (final op in c.ops.reversed) op.unapply(txn);
    txn.commit();
    lineage.remove(c.delta);
    graph.detach(c);
    return c;
  }

  void _replay(Commit c) {
    final txn = bundle.beginTransaction();
    for (final op in c.ops) op.reapply(txn);
    txn.commit();
    lineage.add(c.delta);
    graph.attach(c);
    for (final child in c.subtree) commits[child.statement.id] = child;
  }

  Set<StatementId> _conflictsAfter(int i, StatementId id) => {
    for (final o in graph.neighboursOf(id))
      if (commits.containsKey(o) && _program.indexOf(o)! > i) o,
  };

  List<StatementId> _closure(Set<StatementId> initial) {
    final out = {...initial};
    final work = [...initial];

    while (work.isNotEmpty) {
      final c = commits[work.removeLast()]!;
      final i = _program.indexOf(c.statement.id)!;
      for (final id in _conflictsAfter(i, c.statement.id)) {
        if (out.add(id)) work.add(id);
      }
    }

    return _program.statements.map((s) => s.id).where(out.contains).toList();
  }
}

final class Commit(
  final Statement statement,
  final TopologyDelta own,
  final List<Commit> children,
) {
  late final TopologyDelta delta = children.isEmpty ? own : .merged(own, children.map((c) => c.delta));

  late final Set<CellKey> reads = delta.reads;
  late final Set<CellKey> writes = delta.writes;
  List<TopologyOp> get ops => delta.ops;

  Iterable<Commit> get subtree sync* {
    yield this;
    for (final child in children) yield* child.subtree;
  }
}
