part of '../program.dart';

final class CutEdgeStatement extends Statement {
  CutEdgeStatement(
    EdgeRef target, {
    required this.t,
    super.id,
  }) : target = target.own();

  final Own<EdgeRef> target;
  final double t;

  @override
  late final _args = [target];

  @override
  late final _products = [edge0, edge1, vertex];

  late final edge0 = Ref.edge(id, #edge0);
  late final edge1 = Ref.edge(id, #edge1);
  late final vertex = Ref.vertex(id, #vertex);

  Cubic2? _originalCubic;

  @override
  void execute(EvalContext context) {
    final target = context.resolve(this.target);
    final result = context.transaction.cutEdge(target, t);
    context.bind(edge0, result.edge0);
    context.bind(edge1, result.edge1);
    context.bind(vertex, result.vertex);
    _originalCubic = result.original;
  }

  @override
  TransformResult routeTransform(TransformContext context, Symbol product) {
    return switch (product) {
      #edge0 || #edge1 => .forwarded([target.ref]),
      #vertex => _slide(context),
      _ => const .refused(),
    };
  }

  AbsorbedTransform _slide(TransformContext context) {
    return .new(
      (transform) {
        final eval = context.evaluation;
        final position = context.evaluation.bundle.vertexPosition(eval.vertex(vertex)!);
        final after = transform.transform2(position);

        final originalCubic = _originalCubic!;
        final closestPoint = originalCubic.closestPoint(after);
        return copyWith(t: (closestPoint.t).clamp(1e-9, 1.0 - 1e-9));
      },
      context.handle(vertex),
    );
  }

  @override
  DissolveIntent routeDissolve(Set<Ref> targeted) {
    if (targeted.contains(vertex) || (targeted.contains(edge0) && targeted.contains(edge1))) {
      return .new(lose: {vertex, edge0, edge1});
    }

    final kept = targeted.contains(edge0) ? edge1 : edge0;
    return .new(lose: {...targeted, target.ref}, keep: {kept, vertex});
  }

  @override
  CutEdgeStatement copyWith({
    StatementId? id,
    EdgeRef? target,
    double? t,
  }) => .new(
    id: id ?? this.id,
    target ?? this.target.ref,
    t: t ?? this.t,
  );
}
