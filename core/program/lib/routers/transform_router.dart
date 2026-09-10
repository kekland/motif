part of '../program.dart';

sealed class const TransformRoute() {
  const factory TransformRoute.forward(List<Ref> to) = ForwardTransformRoute;
  static const absorb = AbsorbTransformRoute();
  static const refuse = RefuseTransformRoute();
}

final class const AbsorbTransformRoute() extends TransformRoute;
final class const ForwardTransformRoute(final List<Ref> to) extends TransformRoute;
final class const RefuseTransformRoute() extends TransformRoute;

final class TransformAbsorb(
  final Statement Function(Mat4 local) absorb, {
  required final CellRef cell,
});

final class TransformAbsorber(
  final Statement Function(Mat4) absorb,
  final Mat4 spaceToWorld,
  final Mat4 worldToSpace,
  final Aabb2 hull,
);

final class TransformRouter._(
  final Map<StatementId, TransformAbsorber> absorbers,
  final Set<Ref> refused,
) {
  bool get isEmpty => absorbers.isEmpty;

  Map<StatementId, Statement> apply(Mat4 transform) => absorbers.map(
    (k, v) => .new(k, v.absorb(v.worldToSpace * transform * v.spaceToWorld)),
  );
}

extension RouteTransform on Evaluation {
  TransformRouter routeTransform(Iterable<Ref> targets) {
    final refused = HashSet<Ref>();
    final pending = <StatementId, Set<Ref>>{};
    final absorbed = <StatementId, Set<Ref>>{};
    final routed = <StatementId, Set<Ref>>{};

    void add(Ref r) {
      final owner = rootOf(r.statementId);
      if (routed[owner]?.contains(r) ?? false) return;
      pending.putIfAbsent(owner, () => {}).add(r);
    }

    for (final t in targets) add(t);

    while (pending.isNotEmpty) {
      final id = pending.keys.first;
      final refs = pending.remove(id)!;
      routed[id] ??= {};
      routed[id]!.addAll(refs);

      final s = statement(id);
      if (s == null) {
        refused.addAll(refs);
        continue;
      }

      final context = _contextFor(id);

      for (final t in refs) {
        final result = s.routeTransform(context, t);
        final _ = switch (result) {
          AbsorbTransformRoute() => (absorbed[id] ??= {}).add(t),
          ForwardTransformRoute(:final to) => to.forEach(add),
          RefuseTransformRoute() => refused.add(t),
        };
      }
    }

    final moving = {for (final refs in routed.values) ...refs};
    final absorbers = <StatementId, TransformAbsorber>{};

    for (final entry in absorbed.entries) {
      final id = entry.key;
      final refs = entry.value;
      final s = statement(id)!;

      final context = _contextFor(entry.key);
      final absorber = s.absorbTransform(context, refs, moving);
      if (absorber == null) {
        refused.addAll(refs);
        continue;
      }

      final spaceToWorld = bundle.query.localToWorld(absorber.cell);
      final hull = bundle.query.bbox(absorber.cell, space: bundle.query.localFrame(absorber.cell))!;
      absorbers[id] = .new(absorber.absorb, spaceToWorld, .inverse(spaceToWorld), hull);
    }

    return ._(absorbers, refused);
  }
}
