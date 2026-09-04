part of '../program.dart';

final class Vertex extends Statement with PlacedStatement {
  new(
    this.position, {
    this.style = .default_,
    super.id,
    super.modifiers,
    FrameRef? parent,
  }) : parent = parent != null ? ParentSelector(parent) : null;

  final Vec2 position;
  final VertexStyle style;

  VertexRef get ref => id.cell(.vertex, 0);

  @override
  final ParentSelector? parent;

  @override
  late final selectors = [?parent];

  @override
  Iterable<Op> ops(EvalContext context) sync* {
    yield AddVertexOp(
      position,
      parent: context.maybeResolve(parent),
    );
  }

  @override
  Vertex copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    Vec2? position,
    VertexStyle? style,
    FrameRef? parent,
  }) => .new(
    position ?? this.position,
    style: style ?? this.style,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    parent: parent ?? this.parent?.ref,
  );

  @override
  TransformResult routeTransform(EvalContext context, CellRef<CellHandle> target) => .absorb(
    (m) => copyWith(position: m.transform2(position)),
    target,
  );
}
