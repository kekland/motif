part of '../_program.dart';

final class GroupStatement extends Statement with PlacedStatement, FramedStatement {
  GroupStatement({
    super.id,
    super.modifiers,
    FrameRef? parent,
  }) : parent = .of(parent) {
    selectors = [?this.parent];
  }

  @override
  final ParentSelector? parent;

  @override
  FrameRef get frame => id.cell(.frame, 0);

  @override
  bool get isLeaf => false;

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    yield AddFrameOp(
      .identity(),
      size: null,
      parent: context.maybeResolve(parent),
    );
  }

  @override
  GroupStatement copyWith({
    StatementId? id,
    List<Modifier>? modifiers,
    FrameRef? parent,
  }) {
    return GroupStatement(
      id: id ?? this.id,
      modifiers: modifiers ?? this.modifiers,
      parent: parent ?? this.parent?.ref,
    );
  }

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) {
    final children = context.bundle.frameChildren(context.handle(frame));
    return .forward(children.map((c) => c.ref(context.bundle)).toList());
  }

  @override
  ReparentRoute routeReparent(CellRef target) => .accept;

  @override
  Statement absorbReparent(FrameRef to, Mat4 parentTransform) => copyWith(parent: to);
}
