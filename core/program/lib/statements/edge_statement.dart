part of '../program.dart';

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
       parent = .of(parent);

  final VertexSelector start;
  final VertexSelector end;
  final Vec2? startTangent;
  final Vec2? endTangent;
  final EdgeStyle style;

  EdgeRef get ref => id.cell(.edge, 0);

  @override
  final ParentSelector? parent;

  @override
  late final selectors = [start, end, ?parent];

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
    List<Statement>? modifiers,
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
  TransformResult routeTransform(EvalContext context, Set<CellRef> targets) => .forward(
    [context.resolve(start), context.resolve(end)],
  );
}
