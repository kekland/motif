part of '../program.dart';

final class EvaluationPass {
  EvaluationPass(this.evaluation) : queue = .new((a, b) => evaluation._index[a]!.compareTo(evaluation._index[b]!));

  final Evaluation evaluation;
  final SplayTreeSet<StatementId> queue;
  final added = HashSet<CellRef>();
  final deleted = HashSet<CellRef>();
  final changed = HashSet<CellRef>();
  final moved = HashSet<CellRef>();
  final relayouted = HashSet<StatementId>();
  final rerun = HashSet<StatementId>();
  final _found = <StatementId>{};

  void _enqueue(int after) {
    for (final id in _found) {
      final j = evaluation._index[id];
      if (j != null && j > after) queue.add(id);
    }
    _found.clear();
  }

  void onTopologyChanged(Commit c) {
    added.addAll(c.added);
    deleted.addAll(c.deleted);
    changed.addAll(c.added);
    changed.addAll(c.deleted);
    evaluation.graph.targetingOf(c.added, _found);
    evaluation.graph.targetingOf(c.deleted, _found);
    evaluation.graph.dependentsOf(c.statement.id, _found);
  }

  void onGeometryChanged(Iterable<CellRef> cells) {
    moved.addAll(cells);
    evaluation.graph.readersOf(cells, _found);
  }
}

extension EvaluationPassImpl on Evaluation {
  // -------------------------------------------------------------------------------------------------------------------
  // Edits
  // -------------------------------------------------------------------------------------------------------------------

  void apply(int index, List<Statement> removed, List<Statement> inserted) {
    final start = index < program.length ? _index[program[index].id]! : order.length;
    final end = start + removed.fold(0, (p, s) => p + _span[s.id]!).toInt();

    final flattened = <Statement>[], spans = <int>[], owners = <StatementId>[];
    for (final s in inserted) _flattenInto(s, flattened, spans, owners);

    final incoming = {for (final s in flattened) s.id};
    final gone = <Commit>[];
    for (final s in order.getRange(start, end)) {
      if (incoming.contains(s.id)) continue;

      final c = commits[s.id];
      if (c != null) gone.add(c);
    }

    final pass = EvaluationPass(this);
    _retire(end - 1, gone, pass);
    for (final c in gone) {
      if (c.statement is LayoutBox) layoutTree.detach(c.statement.id);
    }

    program._replace(index, removed, inserted);
    _splice(start, end, flattened, spans, owners);
    for (final s in flattened) {
      if (s is LayoutBox) layoutTree.attachOrUpdate(s as LayoutBox);
    }

    final relayouted = layoutTree.solve();
    pass.relayouted.addAll(relayouted.keys);
    pass.queue.addAll(incoming);
    pass.queue.addAll(relayouted.keys);

    _drain(pass);
    _onPassComplete(pass);
  }

  void _drain(EvaluationPass pass) {
    while (pass.queue.isNotEmpty) {
      final id = pass.queue.first;
      pass.queue.remove(id);

      final i = _index[id];
      if (i == null) continue;
      final s = order[i];
      final c = commits[id];

      if (c == null) {
        _run(i, s, pass);
        continue;
      }

      final topologyChanged = c.targets.any(pass.changed.contains) || c.dependencies.any(pass.rerun.contains);
      if (!topologyChanged) {
        final isIdentical = identical(s, c.statement);
        final readsChanged = c.reads.any(pass.moved.contains);
        final relayouted = pass.relayouted.contains(s.id);

        if (isIdentical && !readsChanged && !relayouted) continue;
        if (_refresh(i, s, c, pass)) continue;
      }

      _retire(i, [c], pass);
      _run(i, s, pass);
    }
  }

  void _retire(int from, List<Commit> roots, EvaluationPass pass) {
    if (roots.isEmpty) return;
    for (final c in _dependentsAfter(from, roots).reversed) {
      _revert(c, pass);
      pass.queue.add(c.statement.id);
    }
    for (final c in roots.reversed) _revert(c, pass);
  }

  void _run(int i, Statement s, EvaluationPass pass) {
    while (true) {
      final c = _apply(s);
      final conflicts = _dependentsAfter(i, [c]);
      if (conflicts.isEmpty) {
        pass.onTopologyChanged(c);
        pass.onGeometryChanged(c.moved);
        pass.rerun.add(s.id);
        pass._enqueue(i);
        return;
      }

      for (final o in conflicts.reversed) {
        _revert(o, pass);
        pass.queue.add(o.statement.id);
      }

      _revert(c, pass);
    }
  }

  List<Commit> _dependentsAfter(int from, List<Commit> roots) {
    final out = <Commit>{};
    final work = [...roots];
    final found = <StatementId>{};
    while (work.isNotEmpty) {
      found.clear();
      graph.overlapping(work.removeLast(), found);
      for (final id in found) {
        final j = _index[id];
        if (j == null || j <= from) continue;
        final c = commits[id];
        if (c != null && out.add(c)) work.add(c);
      }
    }

    final sorted = out.toList();
    sorted.sort((a, b) => _index[a.statement.id]!.compareTo(_index[b.statement.id]!));
    return sorted;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Single statement
  // -------------------------------------------------------------------------------------------------------------------

  Commit _apply(Statement s) {
    final context = _contextFor(s.id, includeResolutions: false);
    final dependencies = {for (final s in s.selectors) ...s.dependencies};
    final txn = bundle.beginTransaction(namespace: s.id.namespace);

    final targets = HashSet<CellRef>();
    final reads = HashSet<CellRef>();
    for (final s in s.selectors) {
      final resolved = s.resolved(context);
      for (final r in resolved) {
        targets.add(r);
        if (s is! ParentSelector) reads.addAll(bundle.cellDependencies(r));
      }
    }

    try {
      final ops = [for (final op in s.ops(context)) txn.apply(op)];
      final delta = txn.commit();

      final commit = Commit.from(s, ops, delta, targets, reads, dependencies, context._resolutions);
      return _attach(commit);
    } catch (e, st) {
      print('APPLY ERROR: $e (at $s)');
      print(st);
      txn.abort();
      final commit = Commit.from(s, [], .new(), targets, reads, dependencies, context._resolutions, error: e);
      return _attach(commit);
    }
  }

  bool _refresh(int i, Statement s, Commit c, EvaluationPass pass) {
    if (c.failed) return false;
    final context = _contextFor(s.id);
    final txn = bundle.beginTransaction(namespace: s.id.namespace);

    try {
      final ops = s.ops(context).toList();
      if (ops.length != c.ops.length) {
        txn.abort();
        return false;
      }

      for (var i = 0; i < ops.length; i++) {
        if (!txn.update(c.ops[i], ops[i])) {
          txn.abort();
          return false;
        }
      }

      final fresh = txn.commit();
      final newlyMoved = c.refresh(s, fresh);
      if (newlyMoved.isNotEmpty) graph.write(s.id, newlyMoved);
      pass.onGeometryChanged(fresh.moved);
      pass._enqueue(i);
      return true;
    } catch (e) {
      print('REFRESH ERROR: $e');
      txn.abort();
      return false;
    }
  }

  void _revert(Commit c, EvaluationPass pass) {
    _detach(c);
    if (c.failed) return;
    final txn = bundle.beginTransaction();
    for (final op in c.ops.reversed) txn.revert(op);
    txn.commit();
  }

  Commit _attach(Commit c) {
    commits[c.statement.id] = c;
    lineage.add(c);
    graph.add(c);
    return c;
  }

  void _detach(Commit c) {
    commits.remove(c.statement.id);
    lineage.remove(c);
    graph.remove(c);
  }

  void _initialPass() {
    final flattened = <Statement>[], spans = <int>[], owners = <StatementId>[];
    for (final s in program.statements) _flattenInto(s, flattened, spans, owners);
    _splice(0, 0, flattened, spans, owners);

    final pass = EvaluationPass(this);
    for (final s in flattened) {
      if (s is LayoutBox) layoutTree.attach(s as LayoutBox);
      pass.queue.add(s.id);
    }

    layoutTree.solve();
    _drain(pass);
    _onPassComplete(pass);
  }
}
