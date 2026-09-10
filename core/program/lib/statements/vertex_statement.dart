part of '../program.dart';

final class VertexStatement extends Statement with PlacedStatement {
  new(
    this.position, {
    this.style = .default_,
    super.id,
    super.enabled,
    FrameRef? parent,
  }) : parent = .of(parent);

  final Vec2 position;
  final VertexStyle style;

  VertexRef get ref => id.cell(.vertex, 0);

  @override
  final ParentSelector? parent;

  @override
  late final selectors = [?parent];

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    context.style(ref, style);
    yield AddVertexOp(
      position,
      parent: context.maybeResolve(parent),
    );
  }

  @override
  VertexStatement copyWith({
    StatementId? id,
    bool? enabled,
    Vec2? position,
    VertexStyle? style,
    FrameRef? parent,
  }) => .new(
    position ?? this.position,
    style: style ?? this.style,
    id: id ?? this.id,
    enabled: enabled ?? this.enabled,
    parent: parent ?? this.parent?.ref,
  );

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) => .absorb;

  @override
  TransformAbsorb absorbTransform(EvalContext context, Set<Ref> absorbed, Set<Ref> all) => .new(
    (m) => copyWith(position: m.transform2(position)),
    cell: ref,
  );
}
