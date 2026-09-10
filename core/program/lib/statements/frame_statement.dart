part of '../program.dart';

final class FrameStatement extends Statement with PlacedStatement {
  new({
    Mat4? transform,
    this.size,
    super.id,
    super.enabled,
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
    bool? enabled,
    Mat4? transform,
    Size2? size,
    FrameRef? parent,
  }) => FrameStatement(
    id: id ?? this.id,
    enabled: enabled ?? this.enabled,
    transform: transform ?? this.transform,
    size: size ?? this.size,
    parent: parent ?? this.parent?.ref,
  );

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) => .absorb;

  static (Mat4, Size2) transformBox(Mat4 own, Mat4 transform, Size2 box) {
    final placement = own * transform.unmirrored(box);

    return (
      placement.withNormalizedScale(),
      box.scale(placement.scaleX, placement.scaleY),
    );
  }

  @override
  TransformAbsorb absorbTransform(EvalContext context, Set<Ref> absorbed, Set<Ref> all) {
    final bundle = context.bundle;
    final bounds = bundle.query.frameBounds(bundle.handle(ref)!);

    return .new(
      (m) {
        final (transform, size) = transformBox(this.transform, m, bounds?.size ?? .zero());

        return copyWith(
          transform: transform,
          size: this.size != null ? size : null,
        );
      },
      cell: ref,
    );
  }
}
