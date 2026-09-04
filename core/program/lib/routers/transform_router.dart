part of '../program.dart';

sealed class const TransformResult() {
  factory TransformResult.absorb(Statement Function(Mat4 local) absorb, CellRef space) = TransformAbsorb;
  factory TransformResult.forward(List<CellRef> targets) = TransformForward;
  static const refused = TransformRefused();
}

final class TransformAbsorb(final Statement Function(Mat4 local) absorb, final CellRef cell) extends TransformResult;
final class TransformForward(final List<CellRef> targets) extends TransformResult;
final class const TransformRefused() extends TransformResult;

final class _Absorber(
  final Statement Function(Mat4) absorb,
  final Mat4 spaceToWorld,
  final Mat4 worldToSpace,
);

final class TransformRouter._(
  final Map<StatementId, _Absorber> _absorbers,
  final Set<CellRef> refused,
) {
  bool get isEmpty => _absorbers.isEmpty;

  Map<StatementId, Statement> apply(Mat4 transform) => _absorbers.map(
    (k, v) => .new(k, v.absorb(v.worldToSpace * transform * v.spaceToWorld)),
  );
}

extension RouteTransform on Evaluation {
  TransformRouter routeTransform(Iterable<CellRef> targets) {
    final absorbers = <StatementId, _Absorber>{};
    final refused = HashSet<CellRef>();

    final work = [...targets], seen = HashSet<CellRef>();
    while (work.isNotEmpty) {
      final ref = work.removeLast();
      if (!seen.add(ref)) continue;

      final owner = statement(ownerOf(ref.statementId));
      if (owner == null) continue;

      final context = _contextFor(owner.id);
      final result = owner.routeTransform(context, ref);

      if (result is TransformAbsorb) {
        if (absorbers.containsKey(owner.id)) continue;
        final frame = bundle.parentOf(bundle.handle(result.cell)!)!;
        final spaceToWorld = bundle.frameTransform(frame, space: .root);
        absorbers[owner.id] = .new(result.absorb, spaceToWorld, .inverse(spaceToWorld));
      } else if (result is TransformForward) {
        work.addAll(result.targets);
      } else if (result is TransformRefused) {
        refused.add(ref);
      }
    }

    return ._(absorbers, refused);
  }
}
