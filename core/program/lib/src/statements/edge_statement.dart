part of '../_program.dart';

final class EdgeStatement extends Statement with PlacedStatement {
  new(
    VertexSelector start,
    VertexSelector end, {
    this.startTangent,
    this.endTangent,
    this.style = .default_,
    super.id,
    super.modifiers,
    FrameRef? parent,
  }) : start = start.clone(),
       end = end.clone(),
       parent = .of(parent) {
    selectors = [this.start, this.end, ?this.parent];
  }

  final VertexSelector start;
  final VertexSelector end;
  final Vec2? startTangent;
  final Vec2? endTangent;
  final EdgeStyle style;

  EdgeRef get ref => id.cell(.edge, 0);

  @override
  final ParentSelector? parent;

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    context.style(ref, style);
    yield AddEdgeOp(
      context.resolve(start),
      context.resolve(end),
      startTangent: startTangent,
      endTangent: endTangent,
      parent: context.maybeResolve(parent),
    );
  }

  @override
  EdgeStatement copyWith({
    StatementId? id,
    List<Modifier>? modifiers,
    VertexSelector? start,
    VertexSelector? end,
    Vec2? startTangent,
    Vec2? endTangent,
    EdgeStyle? style,
    FrameRef? parent,
  }) => .new(
    start ?? this.start,
    end ?? this.end,
    startTangent: startTangent ?? this.startTangent,
    endTangent: endTangent ?? this.endTangent,
    style: style ?? this.style,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    parent: parent ?? this.parent?.ref,
  );

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) => switch (target) {
    CellRef(kind: .edge) => .forward([
      context.resolve(start),
      context.resolve(end),
      CovertexRef.start(ref),
      CovertexRef.end(ref),
    ]),
    CovertexRef c when c.edge == ref => .absorb,
    _ => .refuse,
  };

  @override
  TransformAbsorb absorbTransform(EvalContext context, Set<Ref> absorbed, Set<Ref> all) {
    final bundle = context.bundle;
    final e = bundle.edge(ref)!;
    final space = bundle.parentOf(e);
    final cubic = bundle.edgeCubic(e, space: space);
    final moveStart = absorbed.contains(CovertexRef.start(ref));
    final moveEnd = absorbed.contains(CovertexRef.end(ref));
    final startVertexMoves = all.contains(context.resolve(start));
    final endVertexMoves = all.contains(context.resolve(end));

    final (ps, ts) = (cubic.p0, cubic.p1 - cubic.p0);
    final (pe, te) = (cubic.p3, cubic.p2 - cubic.p3);

    Vec2 moved(Mat4 m, Vec2 p, Vec2 t, bool vertexMoves) {
      return m.transform2(p + t) - (vertexMoves ? m.transform2(p) : p);
    }

    return .new(
      (m) => copyWith(
        startTangent: moveStart ? moved(m, ps, ts, startVertexMoves) : null,
        endTangent: moveEnd ? moved(m, pe, te, endVertexMoves) : null,
      ),
      cell: ref,
    );
  }

  @override
  ReparentRoute routeReparent(CellRef target) => .accept;

  @override
  Statement absorbReparent(FrameRef to, Mat4 parentTransform) => copyWith(parent: to);
}
