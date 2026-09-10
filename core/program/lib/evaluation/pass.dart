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
  final movedFrames = HashSet<FrameRef>();
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
    if (h == null) return null;

    final f = bundle.parentOf(h);
    return f == null ? null : bundle.frameRef(f);
  }

  void _rememberFrames(Iterable<CellRef> cells) {
    final bundle = evaluation.bundle;
    for (final r in cells) {
      final h = bundle.handle(r);
      if (h == null) continue;
      final f = bundle.parentOf(h);
      _frameOf[r] = f?.ref(bundle);
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
    movedFrames.clear();
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
    final start = index < program.length ? _index[program[index].id]! : _order.length;
    final end = start + removed.length;
    _replaceRange(pass, start, end, inserted);
    program._replace(index, removed, inserted);
  }

  void drain(EvaluationPass pass) {
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
    while (true) {
      if (layout.isDirty) {
        final relayouted = layout.solve();
        pass.relayouted.addAll(relayouted.keys);
        pass.queue.addAll(relayouted.keys);
      }
      if (pass.queue.isEmpty) return;

      final id = pass.queue.first;
      pass.queue.remove(id);

      final i = _index[id]!;
      final s = _order[i];
      final c = _commits[id];

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

      _retire([c], pass);
      _run(pass, i, s);
    }
  }

  void _retire(List<Commit> roots, EvaluationPass pass) {
    if (roots.isEmpty) return;

    final rootSet = roots.toSet();
    for (final c in _dependents(roots).reversed) {
      if (rootSet.contains(c)) continue;
      _revert(c, pass);
      pass.queue.add(c.statement.id);
    }

    for (final c in roots.reversed) _revert(c, pass);
  }

  void _run(EvaluationPass pass, int i, Statement s) {
    while (true) {
      final c = _apply(pass, s);
      final conflicts = _dependents([c]);
      if (conflicts.isEmpty) {
        pass.onTopologyChanged(c);
        pass.onGeometryChanged(c.moved);
        pass.rerun.add(s.id);
        pass._enqueue(i);
        _expand(pass, i, s);
        return;
      }

      for (final o in conflicts.reversed) {
        _revert(o, pass);
        pass.queue.add(o.statement.id);
      }

      _revert(c, pass);
    }
  }

  List<Commit> _dependents(List<Commit> roots) {
    final out = <Commit>{};
    final work = [...roots];
    final found = <StatementId>{};
    while (work.isNotEmpty) {
      final c = work.removeLast();
      final after = _index[c.statement.id]!;
      found.clear();
      graph.overlapping(c, found);
      for (final id in found) {
        final j = _index[id];
        if (j == null || j <= after) continue;
        final d = _commits[id];
        if (d != null && out.add(d)) work.add(d);
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
    final dependencies = {for (final selector in s.selectors) ...selector.dependencies};
    final targets = HashSet<CellRef>();
    final reads = HashSet<CellRef>();

    if (!s.enabled) {
      return _attach(pass, Commit.disabled(s, dependencies, context._resolutions, context._styles));
    }

    final txn = bundle.beginTransaction(namespace: s.id.namespace);

    try {
      for (final selector in s.selectors) {
        final resolved = selector.resolved(context);
        for (final r in resolved) {
          targets.add(r);
          if (selector is! ParentSelector) {
            reads.add(r);
            reads.addAll(bundle.cellDependencies(r));
          }
        }
      }

      final ops = [for (final op in s.execute(context)) txn.apply(op)];
      final delta = txn.commit();

      final commit = Commit.from(s, ops, delta, targets, reads, dependencies, context._resolutions, context._styles);
      pass.movedFrames.addAll(delta.movedFrames);
      return _attach(pass, commit);
    } catch (e, st) {
      print('APPLY ERROR: $e (at $s)');
      print(st);

      txn.abort();
      for (final selector in s.selectors) targets.addAll(selector.refs);
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
    if (c.failed || !s.enabled || !c.statement.enabled) return false;
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
      pass.movedFrames.addAll(fresh.movedFrames);
      final restyled = context._styles.entries.any((e) => c.styles[e.key] != e.value);
      final newlyMoved = c.refresh(s, fresh, context._styles);
      if (newlyMoved.isNotEmpty) graph.write(s.id, newlyMoved);
      if (restyled) style.resolve(pass, c);
      pass.onGeometryChanged(fresh.moved);
      pass._enqueue(i);
      _expand(pass, i, s);
      return true;
    } catch (e) {
      txn.abort();
      return false;
    }
  }

  void _expand(EvaluationPass pass, int i, Statement s) {
    if (s is! GeneratorStatement) return;
    final generated = s.enabled ? s.generate(_contextFor(s.id)).toList() : const <Statement>[];
    _reconcile(pass, i + 1, _orderEnd(i), generated);
  }

  void _reconcile(EvaluationPass pass, int start, int end, List<Statement> roots) {
    final block = <Statement>[];
    for (final r in roots) {
      block.add(r);
      final j = _index[r.id];
      if (j != null && j >= start && j < end) block.addAll(_order.getRange(j + 1, _orderEnd(j)));
    }
    _replaceRange(pass, start, end, block);
  }

  void _replaceRange(EvaluationPass pass, int start, int end, List<Statement> inserted) {
    final incoming = {for (final s in inserted) s.id};
    final leaving = <Statement>[];
    final gone = <Commit>[];
    for (final s in _order.getRange(start, end)) {
      if (incoming.contains(s.id)) continue;
      leaving.add(s);

      final c = _commits[s.id];
      if (c != null) gone.add(c);
    }

    _retire(gone, pass);
    for (final s in leaving) {
      final id = s.id;
      pass.queue.remove(id);
      if (s is LayoutBox) layout.detach(id);
    }

    _splice(start, end, inserted);
    for (final s in inserted) {
      if (s is LayoutBox) layout.attachOrUpdate(s as LayoutBox);
    }

    pass.queue.addAll(incoming);
  }

  void _revert(Commit c, EvaluationPass pass) {
    pass._rememberFrames(c.added);
    _detach(c);
    pass.deleted.addAll(c.added);
    pass.added.addAll(c.deleted);
    if (c.ops.isEmpty) return;
    final txn = bundle.beginTransaction();
    for (final op in c.ops.reversed) txn.revert(op);
    txn.commit();
  }

  Commit _attach(EvaluationPass pass, Commit c) {
    _commits[c.statement.id] = c;
    lineage.add(c);
    graph.add(c);
    style.resolve(pass, c);
    for (final r in c.added) drawOrder.invalidate(r);
    for (final r in c.deleted) drawOrder.invalidate(r);
    return c;
  }

  void _detach(Commit c) {
    _commits.remove(c.statement.id);
    lineage.remove(c);
    graph.remove(c);
    for (final r in c.added) {
      drawOrder.invalidate(r);
      style._remove(r);
    }
    for (final r in c.deleted) drawOrder.invalidate(r);
  }

  void _initialPass() {
    final pass = EvaluationPass(this);
    _replaceRange(pass, 0, 0, program._statements);
    _drain(pass);
    _onPassComplete(pass);
  }
}
