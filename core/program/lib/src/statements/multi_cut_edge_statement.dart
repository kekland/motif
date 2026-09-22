part of '../_program.dart';

final class MultiCutEdgeStatement extends Statement {
  new(
    EdgeSelector target, {
    required this.ts,
    super.id,
    super.modifiers,
  }) : target = target.clone() {
    selectors = [this.target];
  }

  final EdgeSelector target;
  final List<double> ts;

  int get vertexCount => ts.length;
  int get pieceCount => ts.length + 1;

  VertexRef vertex(int i) => id.cell(.vertex, 0, i);
  EdgeRef piece(int i) => id.cell(.edge, 0, ts.length + i);

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    yield CutEdgeOp(context.resolve(target), ts);
  }

  @override
  MultiCutEdgeStatement copyWith({
    StatementId? id,
    List<Modifier>? modifiers,
    EdgeSelector? target,
    List<double>? ts,
  }) => .new(
    target ?? this.target,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    ts: ts ?? this.ts,
  );

  // @override
  // TransformRoute routeTransform(EvalContext context, Ref target) => switch (target) {
  //   CellRef c when c == vertex => .absorb,
  //   CellRef(kind: .edge) => .forward([context.resolve(this.target)]),
  //   CovertexRef c when c.edge == edge0 && c.isStart => .forward([CovertexRef.start(context.resolve(this.target))]),
  //   CovertexRef c when c.edge == edge1 && c.isEnd => .forward([CovertexRef.end(context.resolve(this.target))]),
  //   _ => .refuse,
  // };

  // @override
  // TransformAbsorb absorbTransform(EvalContext context, Set<Ref> absorbed, Set<Ref> all) {
  //   final p0 = context.bundle.vertexPosition(context.handle(vertex).asVertex);
  //   final cubic = context.bundle.edgeCubic(context.handle(context.resolve(target)));

  //   return .new(
  //     (m) {
  //       final t = cubic.closestPoint(m.transform2(p0)).t.clamp(1e-6, 1 - 1e-6);
  //       return copyWith(t: t);
  //     },
  //     cell: vertex,
  //   );
  // }
}
