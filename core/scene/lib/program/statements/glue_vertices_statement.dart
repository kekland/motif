part of '../program.dart';

final class GlueVerticesStatement extends Statement {
  GlueVerticesStatement(
    List<VertexRef> targets, {
    this.position = .centroid,
    super.id,
  }) : targets = targets.own();

  final List<Own<VertexRef>> targets;
  final GlueVerticesPosition position;

  @override
  late final _args = [...targets];

  @override
  late final _products = [vertex];

  late final vertex = Ref.vertex(id, #vertex);

  @override
  void execute(EvalContext context) {
    final targets = [for (final arg in this.targets) context.resolve(arg)];
    final result = context.transaction.glueVertices(targets, position: position);
    context.bind(vertex, result);
  }

  // @override
  // TransformResult performTransform(TransformContext context, Symbol product, Mat4 transform) {

  @override
  GlueVerticesStatement copyWith({List<VertexRef>? targets, GlueVerticesPosition? position}) => .new(
    targets ?? this.targets.refs,
    position: position ?? this.position,
    id: id,
  );
}
