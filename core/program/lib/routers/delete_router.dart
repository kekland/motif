part of '../program.dart';

final class DeleteRouter {
  new({
    required this.remove,
    required this.replace,
    required this.remap,
  });

  final Set<StatementId> remove;
  final Map<StatementId, List<Statement>> replace;
  final Remap remap;
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
    for (final s in dead) {
      for (final r in productsOf(s)) {
        if (!bundle.isLive(r) || gone.contains(r)) continue;
        if (r.kind == .frame) {
          gone.add(r);
          final survivor = _survivingFrame(r, gone);
          remap[r] = survivor != null ? [survivor] : [];
        } else {
          bake.add(r);
        }
      }
    }

    final baked = routeBake(bake, gone: gone);
    remap.add(baked.remap);
    return _routeRetire(dead, baked.statements, remap);
  }

  FrameRef? _survivingFrame(CellRef r, Set<CellRef> gone) {
    for (var f = bundle.parentOf(bundle.handle(r)!); f != null && f != bundle.root; f = bundle.parentOf(f)) {
      final ref = f.ref(bundle);
      if (!gone.contains(ref)) return ref;
    }
    return null;
  }

  DeleteRouter _routeRetire(Set<StatementId> dead, List<Statement> baked, Remap remap) {
    if (dead.isEmpty) return .new(remove: const {}, replace: const {}, remap: remap);

    final remove = <StatementId>{...dead};
    final replace = <StatementId, List<Statement>>{};

    final placement = dead.reduce((a, b) => indexOf(a)! > indexOf(b)! ? a : b);
    final block = [...baked];

    final moved = <(int, Statement)>[];
    for (final h in graph.targeting(remap.keys)) {
      if (dead.contains(h)) continue;
      final s = statement(h)!;
      final remapped = s.remap(remap);
      if (remapped == null) throw StateError('failed to remap statement $s');
      final i = indexOf(h)!;
      if (i < indexOf(placement)!) {
        remove.add(h);
        moved.add((i, remapped));
      } else if (!identical(s, remapped)) {
        replace[h] = [remapped];
      }
    }

    moved.sort((a, b) => a.$1.compareTo(b.$1));
    block.addAll(moved.map((e) => e.$2));

    if (block.isNotEmpty) {
      remove.remove(placement);
      replace[placement] = block;
    }

    return .new(remove: remove, replace: replace, remap: remap);
  }
}
