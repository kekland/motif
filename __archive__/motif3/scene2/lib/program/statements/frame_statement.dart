part of '../program.dart';

final class FrameStatement extends Statement with PlacedStatement {
  new({
    super.id,
    super.scope,
    Mat4? transform,
    FrameRef? parent,
  }) : transform = transform ?? .identity(),
       parent = parent?.borrow();

  final Mat4 transform;

  @override
  final Borrow<FrameRef>? parent;

  @override
  late final _args = [?parent];

  late final ref = Ref.frame(this, 'frame');

  @override
  void performExecute(EvalContext context) {
    final handle = context.transaction.addFrame(
      ref.cellId,
      transform: transform,
      parent: context.resolve.maybe(parent?.ref),
    );

    context.bind(ref, handle);
  }

  @override
  FrameStatement copyWith({StatementId? id, Scope? scope, Mat4? transform, FrameRef? parent}) {
    return FrameStatement(
      id: id ?? this.id,
      scope: scope ?? this.scope,
      transform: transform ?? this.transform,
      parent: parent ?? this.parent?.ref,
    );
  }
}
