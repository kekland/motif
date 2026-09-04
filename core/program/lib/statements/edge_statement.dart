part of '../program.dart';

final class Edge extends Statement with PlacedStatement {
  new(
    this.start,
    this.end, {
    this.startTangent,
    this.endTangent,
    this.style = .default_,
    super.id,
    super.modifiers,
    FrameRef? parent,
  }) : parent = parent != null ? ParentSelector(parent) : null;

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
  Iterable<Op> ops(EvalContext context) sync* {
    yield AddEdgeOp(
      context.resolve(start),
      context.resolve(end),
      startTangent: startTangent,
      endTangent: endTangent,
      parent: context.maybeResolve(parent),
    );
  }

  @override
  Edge copyWith({
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
  TransformResult routeTransform(EvalContext context, CellRef target) => .forward(
    [context.resolve(start), context.resolve(end)],
  );
}
