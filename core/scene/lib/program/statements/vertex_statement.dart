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
  VertexStatement copyWith({
    StatementId? id,
    Vec2? position,
    FrameRef? parent,
  }) => .new(
    position ?? this.position,
    parent: parent ?? this.parent?.ref,
    id: id ?? this.id,
  );
}
