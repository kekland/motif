part of '../program.dart';

final class Frame extends Statement with PlacedStatement {
  new({
    Mat4? transform,
    this.size,
    super.id,
    super.modifiers,
    FrameRef? parent,
  }) : transform = transform ?? .identity(),
       parent = parent != null ? ParentSelector(parent) : null;

  final Mat4 transform;
  final Size2? size;

  FrameRef get ref => id.cell(.frame, 0);

  @override
  final ParentSelector? parent;

  @override
  late final selectors = [?parent];

  @override
  Iterable<Op> ops(EvalContext context) sync* {
    yield AddFrameOp(
      transform,
      size: size,
      parent: context.maybeResolve(parent),
    );
  }

  @override
  Frame copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    Mat4? transform,
    Size2? size,
    FrameRef? parent,
  }) => Frame(
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    transform: transform ?? this.transform,
    size: size ?? this.size,
    parent: parent ?? this.parent?.ref,
  );
}
