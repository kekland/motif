part of '../program.dart';

final class EdgeStatement extends Statement with PlacedStatement {
  new(
    VertexRef start,
    VertexRef end, {
    this.startTangent,
    this.endTangent,
    this.style = .default_,
    super.id,
    super.scope,
    FrameRef? parent,
  }) : parent = parent?.borrow(),
       start = start.borrow(),
       end = end.borrow();

  final Borrow<VertexRef> start;
  final Borrow<VertexRef> end;
  final Vec2? startTangent;
  final Vec2? endTangent;
  final EdgeStyle style;

  @override
  final Borrow<FrameRef>? parent;

  @override
  late final _args = [start, end, ?parent];

  late final ref = Ref.edge(this, 'edge');

  @override
  void performExecute(EvalContext context) {
    final handle = context.transaction.addEdge(
      ref.cellId,
      context.resolve(start.ref),
      context.resolve(end.ref),
      startTangent: startTangent,
      endTangent: endTangent,
      parent: context.resolve.maybe(parent?.ref),
    );

    context.bind(ref, handle, style: style);
  }

  @override
  EdgeStatement copyWith({
    StatementId? id,
    Scope? scope,
    VertexRef? start,
    VertexRef? end,
    Vec2? startTangent,
    Vec2? endTangent,
    EdgeStyle? style,
    FrameRef? parent,
  }) {
    return EdgeStatement(
      start ?? this.start.ref,
      end ?? this.end.ref,
      startTangent: startTangent ?? this.startTangent,
      endTangent: endTangent ?? this.endTangent,
      style: style ?? this.style,
      id: id ?? this.id,
      scope: scope ?? this.scope,
      parent: parent ?? this.parent?.ref,
    );
  }
}
