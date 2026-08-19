part of '../program.dart';

final class VertexStatement extends PlacedStatement {
  VertexStatement(
    this.position, {
    super.parent,
    super.id,
  });

  final Vec2 position;

  @override
  late final _args = [?parent];

  @override
  late final _products = [vertex];

  late final vertex = Ref.vertex(id, #vertex);

  @override
  void execute(EvalContext context) {
    final parent = context.resolveOptional(this.parent);
    final handle = context.transaction.addVertex(cellId('v'), position, parent: parent);
    context.bind(vertex, handle);
  }

  @override
  TransformResult routeTransform(TransformContext context, Symbol product) {
    if (product != #vertex) return const .refused();
    return .absorbed(
      (transform) => copyWith(position: transform.transform2(position)),
      context.handle(vertex),
    );
  }

  @override
  VertexStatement copyWith({Vec2? position, FrameRef? parent}) => .new(
    position ?? this.position,
    parent: parent ?? this.parent?.ref,
    id: id,
  );

  @override
  VertexStatement updateWith(VertexStatementPartial partial) => partial.apply(this);

  @override
  VertexStatementPartial partial({Vec2Partial? position, FrameRef? parent}) => .new(
    position: position,
    parent: parent,
  );
}

final class const VertexStatementPartial({
  final Vec2Partial? position,
  final FrameRef? parent,
}) extends StatementPartial<VertexStatement> {
  @override
  VertexStatement apply(VertexStatement statement) => statement.copyWith(
    position: position?.apply(statement.position),
    parent: parent,
  );
}
