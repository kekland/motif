part of '../program.dart';

extension RouteSlice on Evaluation {
  ProgramSlice routeSlice(Iterable<CellRef> targets) {
    final roots = <StatementId>{};
    final copies = <StatementId>{};

    for (final t in targets) {
      final owner = ownerOf(t.statementId);
      roots.add(owner);
      for (final s in subtree(owner)) copies.add(s.id);
    }

    final ground = <CellRef>{};
    final gone = <CellRef>{};
    final remap = Remap.empty();

    for (final s in copies) {
      final c = commits[s];
      if (c == null) continue;
      for (final t in c.targets) {
        if (copies.contains(ownerOf(t.statementId))) continue;
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

    final sortedRoots = roots.toList()..sort((a, b) => indexOf(a)!.compareTo(indexOf(b)!));

    final statements = [...baked.statements];
    for (final id in sortedRoots) {
      final s = statement(id)!;
      statements.add(s.remap(remap)!);
    }

    return ProgramSlice(statements: statements);
  }
}
