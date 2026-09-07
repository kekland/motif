part of '../program.dart';

sealed class const TransformResult() {
  factory TransformResult.absorb(Statement Function(Mat4 local) absorb, CellRef space) = TransformAbsorb;
  factory TransformResult.forward(List<CellRef> targets) = TransformForward;
  static const refused = TransformRefused();
}

final class TransformAbsorb(final Statement Function(Mat4 local) absorb, final CellRef cell) extends TransformResult;
final class TransformForward(final List<CellRef> targets) extends TransformResult;
final class const TransformRefused() extends TransformResult;

final class TransformAbsorber(
  final Statement Function(Mat4) absorb,
  final Mat4 spaceToWorld,
  final Mat4 worldToSpace,
  final CellRef cell,
);

final class TransformRouter._(
  final Map<StatementId, TransformAbsorber> absorbers,
  final Set<CellRef> refused,
) {
  bool get isEmpty => absorbers.isEmpty;

  Map<StatementId, Statement> apply(Mat4 transform) => absorbers.map(
    (k, v) => .new(k, v.absorb(v.worldToSpace * transform * v.spaceToWorld)),
  );
}

extension RouteTransform on Evaluation {
  TransformRouter routeTransform(Iterable<CellRef> targets) {
    final absorbers = <StatementId, TransformAbsorber>{};
    final refused = HashSet<CellRef>();

    final pending = <StatementId, Set<CellRef>>{};
    final routed = <StatementId, Set<CellRef>>{};

    void add(CellRef r) {
      final owner = ownerOf(r.statementId);
      if (routed[owner]?.contains(r) ?? false) return;
      pending.putIfAbsent(owner, () => {}).add(r);
    }

    for (final t in targets) add(t);

    while (pending.isNotEmpty) {
      final id = pending.keys.first;
      final cells = {...?routed[id], ...?pending.remove(id)};
      routed[id] = cells;

      final s = statement(id);
      if (s == null) continue;

      final context = _contextFor(id);
      final result = s.routeTransform(context, cells);

      if (result is TransformAbsorb) {
        final frame = bundle.parentOf(bundle.handle(result.cell)!)!;
        final spaceToWorld = bundle.frameTransform(frame, space: .root);
        absorbers[id] = .new(result.absorb, spaceToWorld, .inverse(spaceToWorld), result.cell);
      } else if (result is TransformForward) {
        absorbers.remove(id);
        for (final ref in result.targets) add(ref);
      } else if (result is TransformRefused) {
        absorbers.remove(id);
        refused.addAll(cells);
      }
    }

    return ._(absorbers, refused);
  }
}
