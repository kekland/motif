part of '../program.dart';

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
  ReparentResult routeReparent(Iterable<CellRef> targets, FrameRef into, {StatementId? after}) {
    final destination = bundle.handle(into)?.asFrame;
    if (destination == null) throw StateError('destination frame $into does not exist');

    if (into.statementId.isDerived) return .failure({rootOf(into.statementId)});

    final (:accepted, :flatten) = _resolveReparentTargets(targets);
    if (flatten.isNotEmpty) return .failure(flatten);

    // remove circular references
    accepted.removeWhere((_, r) {
      final f = r.kind == .frame ? bundle.frame(r.asFrame) : null;
      return f != null && bundle.isAncestorOf(destination, ancestor: f);
    });

    if (accepted.isEmpty) return .empty();

    final StatementId? placement;
    if (after != null) {
      assert(() {
        final s = statement<PlacedStatement>(after)!;
        return (s.parent?.ref ?? .root) == into;
      }(), 'after must be a child of the destination frame');

      placement = stackOf(after).last;
    } else if (into == .root) {
      placement = program.statements.lastOrNull?.id;
    } else {
      placement = _endOf(destination, stackOf(into.statementId).last);
    }

    if (placement == null) return .empty();

    final index = indexOf(placement)!;
    final moving = stacksOf(accepted.keys);

    for (final id in moving) {
      for (final d in dependenciesOf(id)) {
        
      }
    }
  }

  ({Map<StatementId, CellRef> accepted, Set<StatementId> flatten}) _resolveReparentTargets(Iterable<CellRef> targets) {
    final accepted = <StatementId, CellRef>{};
    final flatten = <StatementId>{};

    final seen = <Ref>{};
    final work = [...targets];

    while (work.isNotEmpty) {
      final t = work.removeLast();
      if (!seen.add(t)) continue;

      final base = modifier.baseOf(t.statementId);
      final s = statement(base);
      if (s == null) continue;

      final _ = switch (s.routeReparent(t)) {
        AcceptReparentRoute() => accepted[base] = t,
        RefuseReparentRoute() => flatten.add(base),
        ForwardReparentRoute f => work.add(f.to),
      };
    }

    for (final id in accepted.keys.toList()) {
      if (!id.isDerived) continue;
      accepted.remove(id);
      flatten.add(generated.rootOf(id));
    }

    return (accepted: accepted, flatten: flatten);
  }

  /// The last statement under [frame] in program order — where an append lands.
  StatementId _endOf(FrameHandle frame, StatementId last) {
    for (final c in bundle.frameChildren(frame)) {
      final id = stackOf(c.ref(bundle).statementId).last;
      if (indexOf(id)! > indexOf(last)!) last = id;
      if (c.kind == .frame) last = _endOf(c.asFrame, last);
    }

    return last;
  }
}
