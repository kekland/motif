part of '../program.dart';

final class TransformContext {
  TransformContext(this.evaluation);
  final Evaluation evaluation;

  TopologyBundle get bundle => evaluation.bundle;
  CellHandle handle(Ref ref) => evaluation.cell(ref)!;
  CellHandle spaceOf(Ref ref) => bundle.parentOf(evaluation.cell(ref)!)!;
}

sealed class TransformResult {
  const TransformResult();

  const factory TransformResult.absorbed(Statement Function(Mat4 transform) absorb, CellHandle space) =
      AbsorbedTransform;
  const factory TransformResult.forwarded(List<Ref> targets) = ForwardedTransform;
  const factory TransformResult.refused() = RefusedTransform;
}

final class AbsorbedTransform extends TransformResult {
  const AbsorbedTransform(this.absorb, this.handle);
  final Statement Function(Mat4 transform) absorb;
  final CellHandle handle;
}

final class ForwardedTransform extends TransformResult {
  const ForwardedTransform(this.targets);
  final List<Ref> targets;
}

final class RefusedTransform extends TransformResult {
  const RefusedTransform();
}

final class TransformAbsorber {
  TransformAbsorber({
    required this.absorb,
    required this.handle,
    required this.worldToLocal,
    required this.localToWorld,
    required this.worldToSpace,
    required this.spaceToWorld,
  });

  final Statement Function(Mat4 transform) absorb;
  final CellHandle handle;
  final Mat4 worldToLocal;
  final Mat4 localToWorld;
  final Mat4 worldToSpace;
  final Mat4 spaceToWorld;
}

final class TransformRouter {
  TransformRouter._({required this.absorbers, required this.locked});

  final Map<StatementId, TransformAbsorber> absorbers;
  final Set<Ref> locked;

  bool get isEmpty => absorbers.isEmpty;

  Map<StatementId, Statement> transform(Mat4 transform) {
    final result = <StatementId, Statement>{};

    for (final entry in absorbers.entries) {
      final id = entry.key;
      final absorber = entry.value;

      final statement = absorber.absorb(absorber.worldToSpace * transform * absorber.spaceToWorld);
      result[id] = statement;
    }

    return result;
  }
}

extension TransformProgram on Program {
  TransformRouter resolveTransformRouter(Evaluation evaluation, Iterable<Ref> products) {
    final context = TransformContext(evaluation);
    final absorbers = <StatementId, TransformAbsorber>{};
    final locked = <Ref>{};

    final work = [...products];
    final seen = <Ref>{};
    var guard = 0;

    while (work.isNotEmpty) {
      assert(guard++ < 64 + length * 4, 'transform loop guard exceeded');
      final ref = work.removeLast();
      if (!seen.add(ref)) continue;

      final statement = byId(ref.statement);
      if (statement == null) continue;

      final result = statement.routeTransform(context, ref.product);
      if (result is AbsorbedTransform) {
        final handle = result.handle;
        final localToWorld = evaluation.bundle.cellWorldTransform(handle);
        final spaceToWorld = evaluation.bundle.cellParentWorldTransform(handle);

        absorbers[statement.id] = TransformAbsorber(
          absorb: result.absorb,
          localToWorld: localToWorld,
          worldToLocal: .inverse(localToWorld),
          spaceToWorld: spaceToWorld,
          worldToSpace: .inverse(spaceToWorld),
          handle: handle,
        );
      } else if (result is ForwardedTransform) {
        work.addAll(result.targets);
      } else if (result is RefusedTransform) {
        locked.add(ref);
      }
    }

    return ._(
      absorbers: absorbers,
      locked: locked,
    );
  }
}
