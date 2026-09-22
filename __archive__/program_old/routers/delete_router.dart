part of '../program.dart';

extension RouteDelete on Evaluation {
  ProgramEdit routeDelete(Iterable<CellRef> targets) {
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
    for (final f in bundle.ancestorsOf(bundle.handle(r)!)) {
      final ref = f.ref(bundle);
      if (!gone.contains(ref)) return ref;
    }
    return null;
  }

  ProgramEdit _routeRetire(Set<StatementId> dead, List<Statement> baked, Remap remap) {
    return .build(this, (edit) {
      edit.remap(remap);
      if (dead.isEmpty) return;

      final placement = dead.reduce((a, b) => indexOf(a)! > indexOf(b)! ? a : b);
      final dragged = dependentsBefore(dead, indexOf(placement)!);

      edit.removeAll(dead);
      edit.insert(
        [...baked, ...sorted(dragged).map((id) => statement(id)!)],
        at: .after(placement),
      );
    });
  }
}
