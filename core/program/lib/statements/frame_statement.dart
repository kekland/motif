part of '../program.dart';

final class FrameStatement extends Statement with PlacedStatement {
  new({
    Mat4? transform,
    this.size,
    super.id,
    super.modifiers,
    FrameRef? parent,
  }) : transform = transform ?? .identity(),
       parent = .of(parent);

  final Mat4 transform;
  final Size2? size;

  FrameRef get ref => id.cell(.frame, 0);

  @override
  final ParentSelector? parent;

  @override
  late final selectors = [?parent];

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    yield AddFrameOp(
      transform,
      size: size,
      parent: context.maybeResolve(parent),
    );
  }

  @override
  FrameStatement copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    Mat4? transform,
    Size2? size,
    FrameRef? parent,
  }) => FrameStatement(
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    transform: transform ?? this.transform,
    size: size ?? this.size,
    parent: parent ?? this.parent?.ref,
  );

  @override
  TransformResult routeTransform(EvalContext context, Set<CellRef> targets) {
    final bundle = context.bundle;
    final bounds = bundle.query.frameBounds(bundle.handle(ref)!);

    return .absorb(
      (m) {
        final composed = m * transform;
        final size = bounds?.size.scale(composed.scaleX, composed.scaleY);

        return copyWith(
          transform: composed.withNormalizedScale(),
          size: size,
        );
      },
      ref,
    );
  }
}
