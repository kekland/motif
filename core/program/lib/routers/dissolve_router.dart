part of '../program.dart';

final class const DissolveIntent(final Set<CellRef> cells) {
  static const none = DissolveIntent({});
}

final class DissolveRouter {
  new({
    required this.owners,
    required this.deleted,
    required this.held,
  });

  final Set<StatementId> owners;
  final Set<CellRef> deleted;
  final Set<CellRef> held;

  bool get isEmpty => deleted.isEmpty;
}

extension RouteDissolve on Evaluation {
  DissolveRouter routeDissolve(Iterable<CellRef> targets) {
    final owners = <StatementId>{};
    final byOwner = <StatementId, HashSet<CellRef>>{};
    for (final t in targets) {
      final owner = t.statementId;
      byOwner.putIfAbsent(owner, HashSet.new).add(t);
      owners.addAll(groupOf(owner));
    }

    final resolved = <CellRef>{};
    void resolve(CellRef r) {
      for (final d in lineage.descendantsOf(r, bundle)) {
        if (!resolved.add(d)) continue;
        if (d.kind == .frame) {
          for (final c in bundle.frameChildren(bundle.handle(d)!.asFrame)) {
            resolve(c.ref(bundle));
          }
        }
      }
    }

    for (final entry in byOwner.entries) {
      final s = statement(entry.key);
      if (s == null) continue;
      final cells = entry.value;
      for (final r in s.routeDissolve(cells).cells) resolve(r);
    }

    final deleted = {...resolved};

    for (final r in deleted.where((r) => r.kind == .edge).toList()) {
      final e = bundle.handle(r)?.asEdge;
      if (e == null) continue;
      deleted.add(bundle.vertexRef(bundle.edgeStart(e)));
      deleted.add(bundle.vertexRef(bundle.edgeEnd(e)));
    }

    for (final r in deleted) {
      owners.addAll(groupOf(r.statementId));
    }

    bool held(CellRef r) {
      final holders = graph.targeting([r]);
      if (holders.any((h) => !owners.contains(h))) return true;

      for (final d in bundle.cellDirectDependents(r)) {
        if (!deleted.contains(d)) return true;
      }

      return false;
    }

    var changed = true;
    while (changed) {
      final before = deleted.length;
      deleted.removeWhere(held);
      changed = before != deleted.length;
    }

    return DissolveRouter(owners: owners, deleted: deleted, held: resolved.difference(deleted));
  }
}
