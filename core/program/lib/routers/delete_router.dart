part of '../program.dart';

final class DeleteRouter {
  new({
    required this.remove,
    required this.replace,
  });

  final Set<StatementId> remove;
  final Map<StatementId, List<Statement>> replace;
}

extension RouteDelete on Evaluation {
  DeleteRouter routeDelete(Iterable<CellRef> targets) {
    final dissolve = routeDissolve(targets);

    final dead = {...dissolve.owners};
    final work = [
      ...dissolve.deleted,
      for (final s in dissolve.owners) ...productsOf(s).where((r) => !bundle.isLive(r)),
    ];

    while (work.isNotEmpty) {
      final targeting = graph.targeting([work.removeLast()]);
      for (final s in targeting) {
        if (!dead.add(s)) continue;
        work.addAll(productsOf(s).where((r) => !bundle.isLive(r)));
      }
    }

    final gone = {...dissolve.deleted};
    final remap = Remap.empty();

    final bake = <CellRef>{};
    for (final h in dissolve.held) {
      if (!dead.contains(h.statementId)) continue;
      if (h.kind == .frame) {
        gone.add(h);
        final survivor = _survivingFrame(h, gone);
        remap[h] = survivor != null ? [survivor] : [];
      }
      else {
        bake.add(h);
      }
    }

    final baked = routeBake(bake, gone: gone);
    remap.add(baked.remap);

    final remove = <StatementId>{};
    final replace = <StatementId, List<Statement>>{};
    StatementId? placement;

    for (final s in dead) {
      if (ownerOf(s) != s) continue;
      final host = hostOf(s);
      if (host != null) {
        if (dead.contains(host)) continue;
        final h = statement(host)!;
        final modifiers = h.modifiers.where((m) => !dead.contains(m.id)).toList();
        replace[host] = [h.copyWith(modifiers: modifiers)];
      } else {
        remove.add(s);
        if (placement == null || indexOf(s)! < indexOf(placement)!) placement = s;
      }
    }

    if (placement != null && baked.statements.isNotEmpty) {
      remove.remove(placement);
      replace[placement] = baked.statements;
    }

    for (final h in graph.targeting(remap.keys)) {
      if (dead.contains(h)) continue;
      final s = statement(h)!;
      final remapped = s.remap(remap);
      if (remapped == null) throw StateError('failed to remap statement $s');
      if (!identical(s, remapped)) replace[h] = [remapped];
    }

    return .new(remove: remove, replace: replace);
  }

  FrameRef? _survivingFrame(CellRef r, Set<CellRef> gone) {
    for (var f = bundle.parentOf(bundle.handle(r)!); f != null && f != bundle.root; f = bundle.parentOf(f)) {
      final ref = f.ref(bundle);
      if (!gone.contains(ref)) return ref;
    }
    return null;
  }
}
