part of '../_program.dart';

extension RouteSlice on Evaluation {
  ProgramSlice routeSlice(Iterable<CellRef> targets) {
    final cells = <CellRef>{};

    void walkCell(CellRef cell) {
      cells.add(cell);
      if (cell.kind != .frame) return;
      final handle = bundle.frame(cell.asFrame)!;
      final children = bundle.frameChildren(handle);
      for (final child in children) walkCell(child.ref(bundle));
    }

    final resolvedTargets = targets.toSet();
    for (final t in targets) {
      final dependents = bundle.cellDirectDependents(t.cell);
      resolvedTargets.removeAll(dependents);

      for (final parent in bundle.query.ancestorChain(t.cell)) {
        if (resolvedTargets.contains(parent)) {
          resolvedTargets.remove(t.cell);
          break;
        }
      }
    }

    for (final c in resolvedTargets) walkCell(c);

    final copies = <StatementId>{};
    final children = <StatementId>{};
    for (final t in cells) {
      final obj = object.of(t.statementId);
      if (obj == null) continue;

      final statement = obj.statement;
      if (statement is PrefabInstanceStatement) {
        children.addAll(object.subtree(obj.id).skip(1).map((n) => n.id));
      }

      copies.add(obj.id);
    }

    copies.removeAll(children);

    final ground = <CellRef>{};
    final gone = <CellRef>{};
    final remap = Remap.empty();

    for (final s in copies) {
      final c = commitOf(s);
      if (c == null) continue;
      for (final t in c.topologyInputs) {
        if (copies.contains(t.statementId)) continue;
        if (t.kind == .frame) {
          remap[t] = const [];
          gone.add(t);
        } else {
          ground.add(t);
        }
      }
    }

    final baked = routeBake(ground, closed: true, ghosts: true, gone: gone);
    remap.add(baked.remap);

    final sorted = copies.toList()..sort((a, b) => indexOf(a)!.compareTo(indexOf(b)!));

    final statements = [...baked.statements];
    for (final id in sorted) {
      final s = statement(id)!;
      statements.add(s.remap(remap));
    }

    return ProgramSlice(statements: statements);
  }
}
