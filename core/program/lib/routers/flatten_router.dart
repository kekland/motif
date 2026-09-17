part of '../program.dart';

extension RouteFlatten on Evaluation {
  DeleteRouter routeFlatten(Iterable<StatementId> ids) {
    final dead = <StatementId>{};
    final work = [...ids];
    final descendants = <CellRef, List<CellRef>>{};

    while (work.isNotEmpty) {
      final id = work.removeLast();
      if (!dead.add(id)) continue;

      for (final consumed in consumedOf(id)) {
        final owner = rootOf(consumed.statementId);
        if (!dead.contains(owner)) work.add(owner);
        descendants[consumed] = lineage.descendantsOf(consumed, bundle).where(bundle.isLive).toList();
      }
    }

    final bake = <CellRef>{};
    for (final s in dead) {
      bake.addAll(productsOf(s).where(bundle.isLive));
    }

    final baked = routeBake(bake);
    final remap = Remap.empty()..add(baked.remap);
    for (final entry in descendants.entries) {
      remap[entry.key] = [for (final p in entry.value) baked.remap[p]?.single ?? p];
    }

    return _routeRetire(dead, baked.statements, remap);
  }
}
