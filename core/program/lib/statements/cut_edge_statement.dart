part of '../program.dart';

final class CutEdgeStatement extends Statement {
  new(
    Selector<EdgeRef> target, {
    required this.t,
    super.id,
    super.modifiers,
  }) : target = target.clone();

  final Selector<EdgeRef> target;
  final double t;

  @override
  Iterable<Selector> get selectors => [target];

  VertexRef get vertex => id.cell(.vertex, 0);
  EdgeRef get edge0 => id.cell(.edge, 1);
  EdgeRef get edge1 => id.cell(.edge, 2);

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    yield CutEdgeOp(context.resolve(target), [t]);
  }

  @override
  CutEdgeStatement copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    Selector<EdgeRef>? target,
    double? t,
  }) => .new(
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    target ?? this.target,
    t: t ?? this.t,
  );

  @override
  TransformResult routeTransform(EvalContext context, CellRef<CellHandle> target) {
    final r = context.resolve(this.target);
    if (target.kind == .edge) return .forward([r]);

    final p0 = context.bundle.vertexPosition(context.handle(target).asVertex);
    final cubic = context.bundle.edgeCubic(context.handle(r));

    return .absorb((m) {
      final t = cubic.closestPoint(m.transform2(p0)).t.clamp(1e-6, 1 - 1e-6);
      return copyWith(t: t);
    }, target);
  }
}
