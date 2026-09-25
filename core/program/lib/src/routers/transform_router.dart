part of '../_program.dart';

sealed class const TransformRoute() {
  const factory forward(List<Ref> to) = ForwardTransformRoute;
  static const absorb = AbsorbTransformRoute();
  static const refuse = RefuseTransformRoute();
}

final class const AbsorbTransformRoute() extends TransformRoute;
final class const ForwardTransformRoute(final List<Ref> to) extends TransformRoute;
final class const RefuseTransformRoute() extends TransformRoute;

final class TransformAbsorb(
  final Statement Function(Mat4 local, bool snapToPixel) absorb, {
  required final CellRef cell,
});

final class TransformAbsorber(
  final Statement Function(Mat4 local, bool snapToPixel) absorb,
  final Mat4 spaceToWorld,
  final Mat4 worldToSpace,
  final Aabb2 hull,
);

final class TransformRouter._(
  final Map<StatementId, TransformAbsorber> absorbers,
  final Set<Ref> refused,
) {
  bool get isEmpty => absorbers.isEmpty;

  Map<StatementId, Statement> apply(Mat4 transform, {bool snapToPixel = false}) => absorbers.map(
    (k, v) => .new(k, v.absorb(v.worldToSpace * transform * v.spaceToWorld, snapToPixel)),
  );
}

extension RouteTransform on Evaluation {
  TransformRouter routeTransform(Iterable<Ref> targets) {
    final refused = HashSet<Ref>();
    final routed = HashSet<Ref>();
    final pending = <StatementId, Set<Ref>>{};
    final absorbed = <StatementId, Set<Ref>>{};

    void add(Ref r) {
      final owner = rootOf(r.statementId);
      if (routed.add(r)) pending.putIfAbsent(owner, () => {}).add(r);
    }

    for (final t in targets) add(t);

    while (pending.isNotEmpty) {
      final id = pending.keys.first;
      final refs = pending.remove(id)!;

      final s = statement(id)!;
      final context = contextFor(id);

      for (final t in refs) {
        final result = s.routeTransform(context, t);
        final _ = switch (result) {
          AbsorbTransformRoute() => absorbed.putIfAbsent(id, () => {}).add(t),
          ForwardTransformRoute(:final to) => to.forEach(add),
          RefuseTransformRoute() => refused.add(t),
        };
      }
    }

    final absorbers = <StatementId, TransformAbsorber>{};
    for (final entry in absorbed.entries) {
      final id = entry.key;
      final refs = entry.value;

      final context = contextFor(entry.key);
      final absorber = statement(id)!.absorbTransform(context, refs, routed);
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
