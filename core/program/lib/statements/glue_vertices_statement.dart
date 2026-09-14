part of '../program.dart';

final class GlueVerticesStatement extends Statement {
  new(
    this.vertices, {
    this.position = .centroid,
    super.id,
    super.enabled,
  });

  final List<VertexSelector> vertices;
  final GlueVerticesPosition position;

  @override
  Iterable<Selector> get selectors => vertices;

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
    bool? enabled,
    List<VertexSelector>? vertices,
    GlueVerticesPosition? position,
  }) => .new(
    vertices ?? this.vertices,
    position: position ?? this.position,
    id: id ?? this.id,
    enabled: enabled ?? this.enabled,
  );
}
