part of '../_program.dart';

sealed class const ReparentRoute() {
  static const accept = AcceptReparentRoute();
  static const refuse = RefuseReparentRoute();
  const factory forward(CellRef to) = ForwardReparentRoute;
}

final class const AcceptReparentRoute() extends ReparentRoute;
final class const RefuseReparentRoute() extends ReparentRoute;
final class const ForwardReparentRoute(final CellRef to) extends ReparentRoute;

sealed class ReparentResult() {
  factory success(ProgramEdit edit) = ReparentSuccess;
  factory failure(Set<StatementId> flatten) = ReparentFailure;
  factory empty() = ReparentEmpty;
}

final class ReparentSuccess(final ProgramEdit edit) extends ReparentResult;
final class ReparentFailure(final Set<StatementId> flatten) extends ReparentResult;
final class ReparentEmpty() extends ReparentResult;

extension RouteReparent on Evaluation {
  ReparentResult routeGroup(Iterable<CellRef> targets) {
    final (:accepted, :flatten) = _resolveReparentTargets(targets);
    if (flatten.isNotEmpty) return .failure(flatten);
    if (accepted.isEmpty) return .empty();

    final members = accepted.keys.toSet();
    final placement = members.map((m) => indexOf(m)!).reduce(math.min);

    final parents = [for (final r in accepted.values) bundle.parentOf(bundle.handle(r)!) ?? .root];
    final lca = bundle.lcaMany(parents);
    final space = lca.ref(bundle);
    final group = GroupStatement(parent: lca == .root ? null : space);

    return .success(
      .build(this, (edit) {
        edit.insert([group], at: .at(program[placement].id));
        for (final m in members) {
          edit.replace(m, [statement(m)!.absorbReparent(group.frame, _reparentDelta(m, accepted[m]!, space))]);
          for (final m in members) edit.reorder(accepted[m]!, null);
        }
      }),
    );
  }

  ProgramEdit routeUngroup(StatementId group) {
    final g = statement<GroupStatement>(group)!;
    final frame = bundle.frame(g.frame)!;
    final members = {for (final c in bundle.frameChildren(frame)) rootOf(c.ref(bundle).statementId)};

    return .build(this, (edit) {
      for (final m in members) edit.replace(m, [statement(m)!.absorbReparent(g.parent?.ref ?? .root, .identity())]);
      edit.remove(group);
    });
  }

  ReparentResult routeReparent(Iterable<CellRef> targets, FrameRef into, {StatementId? before}) {
    final destination = bundle.handle(into)?.asFrame;
    if (destination == null) throw StateError('destination frame $into does not exist');

    final (:accepted, :flatten) = _resolveReparentTargets(targets);
    if (flatten.isNotEmpty) return .failure(flatten);

    // remove circular references
    accepted.removeWhere((_, r) {
      final f = r.kind == .frame ? bundle.frame(r.asFrame) : null;
      return f != null && bundle.isAncestorOf(destination, ancestor: f);
    });

    if (accepted.isEmpty) return .empty();

    final members = accepted.keys.toSet();
    int placement;

    if (before != null) {
      assert(() {
        final s = statement<PlacedStatement>(before)!;
        return (s.parent?.ref ?? .root) == into;
      }(), 'before must be a child of the destination frame');

      placement = indexOf(before)! - 1;
    } else if (into == .root) {
      placement = program.length - 1;
    } else {
      placement = _endOf(destination, indexOf(rootOf(into.statementId))!);
    }

    for (final m in members) {
      for (final d in dependenciesOf(m)) {
        if (!members.contains(d)) placement = math.max(placement, indexOf(d)!);
      }
    }

    final moving = SplayTreeSet<StatementId>(evalOrder);
    moving.addAll(members);
    moving.addAll(dependentsBefore(members, placement + 1));

    final insertions = <Statement>[];
    for (final o in moving) {
      if (members.contains(o)) {
        insertions.add(statement(o)!.absorbReparent(into, _reparentDelta(o, accepted[o]!, into)));
      } else {
        insertions.add(statement(o)!);
      }
    }

    return .success(
      .build(this, (edit) {
        edit.insert(insertions, at: placement < 0 ? .start : .after(program[placement].id));
        for (final m in members) edit.reorder(accepted[m]!, null);
      }),
    );
  }

  ({Map<StatementId, CellRef> accepted, Set<StatementId> flatten}) _resolveReparentTargets(Iterable<CellRef> targets) {
    final accepted = <StatementId, CellRef>{};
    final flatten = <StatementId>{};

    final seen = <Ref>{};
    final work = [...targets];

    while (work.isNotEmpty) {
      final t = work.removeLast();
      if (!seen.add(t)) continue;

      final root = rootOf(t.statementId);
      final s = statement(root);
      if (s == null) continue;

      final _ = switch (s.routeReparent(t)) {
        AcceptReparentRoute() => accepted[root] = t,
        RefuseReparentRoute() => flatten.add(root),
        ForwardReparentRoute f => work.add(f.to),
      };
    }

    return (accepted: accepted, flatten: flatten);
  }

  /// The index of the last child under [frame].
  int _endOf(FrameHandle frame, int last) {
    for (final c in bundle.frameChildren(frame)) {
      last = math.max(last, indexOf(rootOf(c.ref(bundle).statementId))!);
      if (c.kind == .frame) last = _endOf(c.asFrame, last);
    }

    return last;
  }

  Mat4 _reparentDelta(StatementId id, CellRef ref, FrameRef into) {
    final worldToInto = bundle.query.worldToLocal(into);

    final stmt = statement(id);
    if (stmt is LayoutBoxStatement) {
      final placed = bundle.query.localToWorld(stmt.frame);
      return worldToInto * placed * Mat4.inverse(stmt.transform);
    }

    return worldToInto * bundle.query.localToWorld(ref);
  }
}
