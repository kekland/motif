part of '../program.dart';

final class EvaluationPass {
  EvaluationPass(this.evaluation) : queue = .new((a, b) => evaluation._index[a]!.compareTo(evaluation._index[b]!));

  final Evaluation evaluation;
  Program get program => evaluation.program;

  final SplayTreeSet<StatementId> queue;
  final added = HashSet<CellRef>();
  final deleted = HashSet<CellRef>();
  final changed = HashSet<CellRef>();
  final moved = HashSet<CellRef>();
  final relayouted = HashSet<StatementId>();
  final restyled = HashSet<CellRef>();
  final reordered = HashSet<CellRef>();
  final rerun = HashSet<StatementId>();
  final _found = <StatementId>{};
  final _frameOf = <CellRef, FrameRef?>{};

  FrameRef? frameOf(CellRef r) {
    if (_frameOf.containsKey(r)) return _frameOf[r];
    final bundle = evaluation.bundle;
    final h = bundle.handle(r);
    return h == null ? null : bundle.parentOf(h)?.ref(bundle);
  }

  void _rememberFrames(Iterable<CellRef> cells) {
    final bundle = evaluation.bundle;

    for (final r in cells) {
      final h = bundle.handle(r);
      if (h != null) _frameOf[r] = bundle.parentOf(h)?.ref(bundle);
    }
  }

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

  void reset() {
    queue.clear();
    added.clear();
    deleted.clear();
    changed.clear();
    moved.clear();
    relayouted.clear();
    restyled.clear();
    reordered.clear();
    rerun.clear();
    _found.clear();
    _frameOf.clear();
  }
}

extension EvaluationPassImpl on Evaluation {
  // -------------------------------------------------------------------------------------------------------------------
  // Edits
  // -------------------------------------------------------------------------------------------------------------------

  EvaluationPass beginPass() => EvaluationPass(this);

  void edit(EvaluationPass pass, int index, List<Statement> removed, List<Statement> inserted) {
    final start = index < program.length ? _index[program[index].id]! : order.length;
    final end = start + removed.fold(0, (p, s) => p + _span[s.id]!).toInt();

    final flattened = <Statement>[], spans = <int>[], owners = <StatementId>[], hosts = <StatementId?>[];
    for (final s in inserted) _flattenInto(s, flattened, spans, owners, hosts);

    final incoming = {for (final s in flattened) s.id};
    final gone = <Commit>[];
    for (final s in order.getRange(start, end)) {
      if (incoming.contains(s.id)) continue;

      final c = commits[s.id];
      if (c != null) gone.add(c);
    }

    _retire(start - 1, gone, pass);
    for (final s in order.getRange(start, end)) {
      if (!incoming.contains(s.id)) pass.queue.remove(s.id);
    }

    for (final c in gone) {
      if (c.statement is LayoutBox) layoutTree.detach(c.statement.id);
    }

    program._replace(index, removed, inserted);
    _splice(start, end, flattened, spans, owners, hosts);
    for (final s in flattened) {
      if (s is LayoutBox) layoutTree.attachOrUpdate(s as LayoutBox);
    }

    pass.queue.addAll(incoming);
  }

  void drain(EvaluationPass pass) {
    final relayouted = layoutTree.solve();
    pass.relayouted.addAll(relayouted.keys);
    pass.queue.addAll(relayouted.keys);
    _drain(pass);
    _onPassComplete(pass);
    pass.reset();
  }

  void apply(int index, List<Statement> removed, List<Statement> inserted) {
    final pass = beginPass();
    edit(pass, index, removed, inserted);
    drain(pass);
  }

  void _drain(EvaluationPass pass) {
    while (pass.queue.isNotEmpty) {
      final id = pass.queue.first;
      pass.queue.remove(id);

      final i = _index[id]!;
      final s = order[i];
      final c = commits[id];

      if (c == null) {
        _run(pass, i, s);
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
      _run(pass, i, s);
    }
  }

  void _retire(int from, List<Commit> roots, EvaluationPass pass) {
    if (roots.isEmpty) return;

    final rootSet = roots.toSet();
    for (final c in _dependentsAfter(from, roots).reversed) {
      if (rootSet.contains(c)) continue;
      _revert(c, pass);
      pass.queue.add(c.statement.id);
    }

    for (final c in roots.reversed) _revert(c, pass);
  }

  void _run(EvaluationPass pass, int i, Statement s) {
    while (true) {
      final c = _apply(pass, s);
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

  Commit _apply(EvaluationPass pass, Statement s) {
    final context = _contextFor(s.id, includeResolutions: false);
    final dependencies = {for (final s in s.selectors) ...s.dependencies};
    final txn = bundle.beginTransaction(namespace: s.id.namespace);

    final targets = HashSet<CellRef>();
    final reads = HashSet<CellRef>();

    try {
      for (final s in s.selectors) {
        final resolved = s.resolved(context);
        for (final r in resolved) {
          targets.add(r);
          if (s is! ParentSelector) {
            reads.add(r);
            reads.addAll(bundle.cellDependencies(r));
          }
        }
      }

      final ops = [for (final op in s.execute(context)) txn.apply(op)];
      final delta = txn.commit();

      final commit = Commit.from(s, ops, delta, targets, reads, dependencies, context._resolutions, context._styles);
      return _attach(pass, commit);
    } catch (e, st) {
      print('APPLY ERROR: $e (at $s)');
      print(st);

      txn.abort();
      for (final sel in s.selectors) targets.addAll(sel.refs);
      final commit = Commit.from(
        s,
        [],
        .new(),
        targets,
        reads,
        dependencies,
        context._resolutions,
        context._styles,
        error: e,
      );
      return _attach(pass, commit);
    }
  }

  bool _refresh(int i, Statement s, Commit c, EvaluationPass pass) {
    if (c.failed) return false;
    final context = _contextFor(s.id);
    final txn = bundle.beginTransaction(namespace: s.id.namespace);

    try {
      final ops = s.execute(context).toList();
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
      final newlyMoved = c.refresh(s, fresh, context._styles);
      if (newlyMoved.isNotEmpty) graph.write(s.id, newlyMoved);
      _resolveStyles(pass, c);
      pass.onGeometryChanged(fresh.moved);
      pass._enqueue(i);
      return true;
    } catch (e) {
      txn.abort();
      return false;
    }
  }

  void _revert(Commit c, EvaluationPass pass) {
    pass._rememberFrames(c.added);
    _detach(c);
    pass.deleted.addAll(c.added);
    pass.added.addAll(c.deleted);
    if (c.failed) return;
    final txn = bundle.beginTransaction();
    for (final op in c.ops.reversed) txn.revert(op);
    txn.commit();
  }

  Commit _attach(EvaluationPass pass, Commit c) {
    commits[c.statement.id] = c;
    lineage.add(c);
    graph.add(c);
    _resolveStyles(pass, c);
    for (final r in c.added) _invalidateDrawOrder(r);
    for (final r in c.deleted) _invalidateDrawOrder(r);
    return c;
  }

  void _detach(Commit c) {
    commits.remove(c.statement.id);
    lineage.remove(c);
    graph.remove(c);
    for (final r in c.added) {
      _invalidateDrawOrder(r);
      _styles.remove(r);
    }
    for (final r in c.deleted) _invalidateDrawOrder(r);
  }

  void _initialPass() {
    final flattened = <Statement>[], spans = <int>[], owners = <StatementId>[], hosts = <StatementId?>[];
    for (final s in program.statements) _flattenInto(s, flattened, spans, owners, hosts);
    _splice(0, 0, flattened, spans, owners, hosts);

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
