part of '../_program.dart';

extension Evaluator on EvalPass {
  // -------------------------------------------------------------------------------------------------------------------
  // Main entrypoints
  // -------------------------------------------------------------------------------------------------------------------

  void edit(int index, List<Statement> removed, List<Statement> inserted) {
    final incoming = inserted.map((s) => s.id).toList();
    for (final s in removed.reversed) {
      for (final r in graph.dependents([s.id])) {
        final n = tree[r]!;
        n.markDirty();
        n.lastProduced = null;
        queue.add(n.root.id);
      }

      if (incoming.contains(s.id)) continue;

      final node = tree[s.id];
      if (node != null) _drop(node);
      queue.remove(s.id);
    }

    program._replace(index, removed, inserted);
    for (final s in inserted) queue.add(s.id);
  }

  void drain() {
    while (true) {
      _solveLayout();
      if (queue.isEmpty) break;

      _current = queue.first;
      queue.remove(_current);

      final root = tree.root(program.statement(_current!)!);
      _attachLayout([root]);
      _evaluate(root);
    }

    evaluation._onPassComplete(this);
    reset();
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Evaluation loop
  // -------------------------------------------------------------------------------------------------------------------

  /// Evaluates the given [node] and its children.
  void _evaluate(EvalNode node) {
    if (!node.dirty && node.dirtyBelow == 0) return;

    if (node.dirty) {
      _settle(node);
      node.markClean();
    }

    if (node.childrenStale) _attachLayout(_produce(node));
    for (final child in node.children) _evaluate(child);
  }

  /// Settles the given [node] by first trying to refresh it in-place, and if it's not possible, then rerunning it.
  void _settle(EvalNode node) {
    final moved = node.commit != null ? _refresh(node) : null;
    if (moved != null) return _onMoved(moved);

    _retire([node]);
    _rerun(node);
  }

  /// Replaces the [node]'s children with the new products.
  List<EvalNode> _produce(EvalNode node) {
    final statement = node.statement;
    final produced = <Statement>[];
    for (final (i, m) in statement.modifiers.indexed) {
      if (!m.enabled) continue;

      final id = statement.id.derive(.of(0, i));
      final fragment = FragmentSelector(node.id, modifierIndex: i);
      final context = m.createContext(evaluation, id, fragment);
      produced.add(m.produce(context));
    }

    if (statement is GeneratingStatement) {
      produced.addAll(statement.generate(evaluation.contextFor(node.id)));
    }

    for (final old in tree.difference(node, produced)) _drop(old);
    return tree.adopt(node, produced);
  }

  /// Removes [node] and its subtree from the eval tree.
  void _drop(EvalNode node) {
    final gone = tree.subtree(node).toList();
    _retire(gone);
    for (final n in gone) layout.detach(n.id);
    tree.remove(node);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Reruns
  // -------------------------------------------------------------------------------------------------------------------

  /// Runs [node] until it has no conflicts with dependent nodes. Dependent nodes are reverted and the process iterates
  /// until the node can be applied without conflicts.
  void _rerun(EvalNode node) {
    while (true) {
      _install(node, _apply(node));

      final conflicts = _dependents([node]);
      if (conflicts.isEmpty) return _onMoved(node.commit!.moved);

      _uninstall(node);
      _revertAll(conflicts);
    }
  }

  /// Reverts the given root nodes and anything that depends on them.
  void _retire(List<EvalNode> roots) {
    final all = roots.where((r) => r.commit != null).toList();
    all.addAll(_dependents(roots));
    _revertAll(all);
  }

  /// Reverts all given nodes (in reversed order), and adds them to the queue.
  void _revertAll(List<EvalNode> nodes) {
    nodes.sort(tree.order);
    for (final n in nodes.reversed) {
      _uninstall(n);
      if (n.root.id != _current) queue.add(n.root.id);
    }
  }

  /// Returns a list of all dependent nodes that are affected by changes to the given root nodes.
  List<EvalNode> _dependents(List<EvalNode> roots) {
    final out = <EvalNode>[];
    final seen = {...roots};
    final work = roots.where((r) => r.commit != null).toList();

    while (work.isNotEmpty) {
      final current = work.removeLast();
      for (final id in graph.overlapping(current.commit!)) {
        final node = tree[id]!;
        if (node.commit == null || !tree.isAfter(node, current) || !seen.add(node)) continue;
        out.add(node);
        work.add(node);
      }
    }

    return out;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Bookkeeping
  // -------------------------------------------------------------------------------------------------------------------

  void _install(EvalNode node, Commit commit) {
    node.commit = commit;
    evaluation.lineage.attach(commit);
    evaluation.graph.attach(commit);
    evaluation.live.attach(commit);
    restyled.addAll(evaluation.style.attach(commit));
    added.addAll(commit.added);
    deleted.addAll(commit.deleted);
    for (final r in commit.added.followedBy(commit.deleted)) evaluation.drawOrder.invalidateFrame(frameOf(r));
  }

  void _uninstall(EvalNode node) {
    final commit = node.commit!;
    node.commit = null;
    node.markDirty();
    _rememberFrames(commit.added);
    evaluation.lineage.detach(commit);
    evaluation.graph.detach(commit);
    evaluation.live.detach(commit);
    evaluation.style.detach(commit);
    deleted.addAll(commit.added);
    added.addAll(commit.deleted);
    for (final r in commit.added.followedBy(commit.deleted)) evaluation.drawOrder.invalidateFrame(frameOf(r));
    _unapply(commit);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Transactions
  // -------------------------------------------------------------------------------------------------------------------

  /// Performs a fresh application of a statement and returns the resulting [Commit].
  Commit _apply(EvalNode node) {
    final id = node.id;
    final statement = node.statement;
    final context = evaluation.contextFor(id, includeResolutions: false);
    final topologyInputs = HashSet<CellRef>();
    final geometryInputs = HashSet<CellRef>();

    final txn = bundle.beginTransaction(namespace: id.namespace);
    try {
      for (final selector in statement.selectors) {
        topologyInputs.addAll(selector.refs);
        for (final r in selector.resolved(context)) {
          topologyInputs.add(r);
          if (selector is ParentSelector) continue;
          geometryInputs.add(r);
          geometryInputs.addAll(bundle.cellDependencies(r));
        }
      }

      final ops = [for (final op in statement.execute(context)) txn.apply(op)];
      final delta = txn.commit();
      _onDelta(delta);

      return .from(statement, ops, delta, context, topologyInputs: topologyInputs, geometryInputs: geometryInputs);
    } catch (e, st) {
      txn.abort();
      _log.fine('failed to apply statement $id', e, st);
      return .error(statement, topologyInputs: topologyInputs, geometryInputs: geometryInputs);
    }
  }

  /// Performs an incremental refresh of a statement. Returns a list of updated refs if successful, or `null` if the
  /// refresh failed.
  List<CellRef>? _refresh(EvalNode node) {
    final id = node.id;
    final statement = node.statement;
    final commit = node.commit!;

    if (commit.failed) return null;

    final context = evaluation.contextFor(id, includeResolutions: true);
    final txn = bundle.beginTransaction(namespace: id.namespace);

    try {
      final ops = statement.execute(context).toList();
      if (ops.length != commit.ops.length) {
        txn.abort();
        return null;
      }

      for (var i = 0; i < ops.length; i++) {
        if (!txn.update(commit.ops[i], ops[i])) {
          txn.abort();
          return null;
        }
      }

      final delta = txn.commit();
      _onDelta(delta);

      final newlyMoved = commit.refresh(statement, delta, context._styles);
      if (newlyMoved.isNotEmpty) graph.onWrite(node.id, newlyMoved);
      if (context._styles.isNotEmpty) {
        restyled.addAll(evaluation.style.attach(commit));
      }
      return delta.moved;
    } catch (e, st) {
      txn.abort();
      _log.fine('failed to refresh statement $id', e, st);
      return null;
    }
  }

  /// Reverts the changes made by a commit.
  void _unapply(Commit commit) {
    if (commit.ops.isEmpty) return;
    final txn = bundle.beginTransaction(namespace: commit.statement.id.namespace);
    for (final op in commit.ops.reversed) txn.revert(op);
    txn.commit();
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Propagation
  // -------------------------------------------------------------------------------------------------------------------

  void _onDelta(Delta delta) {
    movedFrames.addAll(delta.movedFrames);
  }

  void _onMoved(Iterable<CellRef> cells) {
    moved.addAll(cells);

    final currentIndex = program.indexOf(_current!)!;
    for (final id in graph.geometryReaders(cells)) {
      final node = tree[id]!;
      if (node.root.id == _current) {
        node.markDirty();
      } else if (program.indexOf(node.root.id)! > currentIndex) {
        node.markDirty();
        queue.add(node.root.id);
      }
    }
  }

  void _attachLayout(List<EvalNode> nodes) {
    for (final n in nodes) {
      final statement = n.statement;
      if (statement is LayoutBox) layout.attachOrUpdate(statement as LayoutBox);
    }

    if (nodes.isNotEmpty) _solveLayout(nodes.first);
  }

  void _solveLayout([EvalNode? next]) {
    if (!layout.isDirty) return;

    for (final id in layout.solve().keys) {
      relayouted.add(id);
      final node = tree[id]!;
      node.markDirty();
      if (next != null && node.root == next.root && !tree.isAfter(next, node)) continue;
      queue.add(node.root.id);
    }
  }
}
