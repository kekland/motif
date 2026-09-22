part of '../_program.dart';

final class GlueVerticesStatement extends Statement {
  new(
    List<VertexSelector> vertices, {
    this.position = .centroid,
    super.id,
    super.modifiers,
  }) : vertices = vertices.map((v) => v.clone()).toList() {
    selectors = [...this.vertices];
  }

  final List<VertexSelector> vertices;
  final GlueVerticesPosition position;

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    yield GlueVerticesOp(
      vertices.map((s) => context.resolve(s)).toList(),
      position: position,
    );
  }

  @override
  GlueVerticesStatement copyWith({
    StatementId? id,
    List<Modifier>? modifiers,
    List<VertexSelector>? vertices,
    GlueVerticesPosition? position,
  }) => .new(
    vertices ?? this.vertices,
    position: position ?? this.position,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
  );

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) => .forward(
    vertices.map((s) => context.resolve(s)).toList(),
  );
}
