part of '../program.dart';

final class EdgeStatement extends PlacedStatement {
  EdgeStatement(
    VertexRef start,
    VertexRef end, {
    this.startTangent,
    this.endTangent,
    this.style = .default_,
    super.parent,
    super.id,
  }) : start = start.borrow(),
       end = end.borrow();

  final Arg<VertexRef> start;
  final Arg<VertexRef> end;
  final Vec2? startTangent;
  final Vec2? endTangent;
  final EdgeStyle style;

  @override
  late final _args = [start, end, ?parent];

  @override
  late final _products = [edge];

  late final edge = Ref.edge(id, #edge);

  @override
  void execute(EvalContext context) {
    final start = context.resolve(this.start);
    final end = context.resolve(this.end);
    final parent = context.resolveOptional(this.parent);

    final handle = context.transaction.addEdge(
      cellId('e'),
      start,
      end,
      parent: parent,
      startTangent: startTangent,
      endTangent: endTangent,
    );

    context.bind(edge, handle, decoration: style);
  }

  @override
  TransformResult routeTransform(TransformContext context, Symbol product) {
    if (product != #edge) return const .refused();
    return .forwarded([start.ref, end.ref]);
  }

  @override
  EdgeStatement copyWith({
    VertexRef? start,
    VertexRef? end,
    FrameRef? parent,
    Vec2? startTangent,
    Vec2? endTangent,
    EdgeStyle? style,
  }) => .new(
    start ?? this.start.ref,
    end ?? this.end.ref,
    parent: parent ?? this.parent?.ref,
    startTangent: startTangent ?? this.startTangent,
    endTangent: endTangent ?? this.endTangent,
    style: style ?? this.style,
    id: id,
  );

  @override
  EdgeStatement updateWith(EdgeStatementPartial partial) => partial.apply(this);

  @override
  EdgeStatementPartial partial({
    VertexRef? start,
    VertexRef? end,
    FrameRef? parent,
    Vec2? startTangent,
    Vec2? endTangent,
    EdgeStylePartial? style,
  }) => .new(
    start: start,
    end: end,
    parent: parent,
    startTangent: startTangent,
    endTangent: endTangent,
    style: style,
  );
}

final class const EdgeStatementPartial({
  final VertexRef? start,
  final VertexRef? end,
  final FrameRef? parent,
  final Vec2? startTangent,
  final Vec2? endTangent,
  final EdgeStylePartial? style,
}) extends StatementPartial<EdgeStatement> {
  @override
  EdgeStatement apply(EdgeStatement statement) => statement.copyWith(
    start: start,
    end: end,
    parent: parent,
    startTangent: startTangent,
    endTangent: endTangent,
    style: statement.style.updateWith(style),
  );
}
