part of '../program.dart';

final class EdgeStatement extends PlacedStatement {
  EdgeStatement(
    VertexRef start,
    VertexRef end, {
    super.parent,
    super.id,
  }) : start = start.borrow(),
       end = end.borrow();

  final Arg<VertexRef> start;
  final Arg<VertexRef> end;

  @override
  late final _args = [start, end, ?parent];

  @override
  late final _products = [edge];

  late final edge = EdgeRef(id, #edge);

  @override
  void execute(EvalContext context) {
    final start = context.resolve(this.start);
    final end = context.resolve(this.end);
    final parent = context.resolveOptional(this.parent);

    final handle = context.transaction.addEdge(cellId('e'), start, end, parent: parent);
    context.bind(edge, handle);
  }

  @override
  TransformResult routeTransform(TransformContext context, Symbol product) {
    if (product != #edge) return const .refused();
    return .forwarded([start.ref, end.ref]);
  }

  @override
  EdgeStatement copyWith({VertexRef? start, VertexRef? end, FrameRef? parent}) => .new(
    start ?? this.start.ref,
    end ?? this.end.ref,
    parent: parent ?? this.parent?.ref,
    id: id,
  );
}
