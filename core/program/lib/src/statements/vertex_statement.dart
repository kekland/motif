part of '../_program.dart';

final class VertexStatement extends Statement with PlacedStatement {
  new(
    this.position, {
    this.style = .default_,
    super.id,
    super.modifiers,
    FrameRef? parent,
  }) : parent = .of(parent) {
    selectors = [?this.parent];
  }

  final Vec2 position;
  final VertexStyle style;

  VertexRef get ref => id.cell(.vertex, 0);

  @override
  final ParentSelector? parent;

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
    List<Modifier>? modifiers,
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
  TransformRoute routeTransform(EvalContext context, Ref target) => .absorb;

  @override
  TransformAbsorb absorbTransform(EvalContext context, Set<Ref> absorbed, Set<Ref> all) => .new(
    (m) => copyWith(position: m.transform2(position)),
    cell: ref,
  );

  @override
  ReparentRoute routeReparent(CellRef target) => .accept;

  @override
  VertexStatement absorbReparent(FrameRef to, Mat4 parentTransform) => copyWith(
    parent: to,
    position: parentTransform.transform2(position),
  );
}
