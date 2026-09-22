part of '../_program.dart';

final class CutEdgeStatement extends Statement {
  new(
    EdgeSelector target, {
    required this.t,
    super.id,
    super.modifiers,
  }) : target = target.clone() {
    selectors = [this.target];
  }

  final EdgeSelector target;
  final double t;

  VertexRef get vertex => id.cell(.vertex, 0, 0);
  EdgeRef get edge0 => id.cell(.edge, 0, 1);
  EdgeRef get edge1 => id.cell(.edge, 0, 2);

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    yield CutEdgeOp(context.resolve(target), [t]);
  }

  @override
  CutEdgeStatement copyWith({
    StatementId? id,
    List<Modifier>? modifiers,
    EdgeSelector? target,
    double? t,
  }) => .new(
    target ?? this.target,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    t: t ?? this.t,
  );

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) {
    return switch (target) {
      CellRef c when c == vertex => .absorb,
      CellRef(kind: .edge) => .forward([context.resolve(this.target)]),
      CovertexRef c when c.edge == edge0 && c.isStart => .forward([CovertexRef.start(context.resolve(this.target))]),
      CovertexRef c when c.edge == edge1 && c.isEnd => .forward([CovertexRef.end(context.resolve(this.target))]),
      _ => .refuse,
    };
  }

  @override
  TransformAbsorb absorbTransform(EvalContext context, Set<Ref> absorbed, Set<Ref> all) {
    final p0 = context.bundle.vertexPosition(context.handle(vertex).asVertex);
    final cubic = context.bundle.edgeCubic(context.handle(context.resolve(target)));

    return .new(
      (m) {
        final t = cubic.closestPoint(m.transform2(p0)).t.clamp(1e-6, 1 - 1e-6);
        return copyWith(t: t);
      },
      cell: vertex,
    );
  }
}
