part of '../program.dart';

extension RouteSlice on Evaluation {
  ProgramSlice routeSlice(Iterable<CellRef> targets) {
    final copies = <StatementId>{};

    for (final t in targets) copies.addAll(groupOf(t.statementId));

    final ground = <CellRef>{};
    final gone = <CellRef>{};
    final remap = Remap.empty();

    for (final s in copies) {
      final c = _commits[s];
      if (c == null) continue;
      for (final t in c.targets) {
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
      statements.add(s.remap(remap)!);
    }

    return ProgramSlice(statements: statements);
  }
}
