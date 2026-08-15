part of '../program.dart';

final class FrameStatement extends PlacedStatement {
  FrameStatement({
    Mat4? transform,
    super.parent,
    super.id,
  }) : transform = transform ?? Mat4.identity();

  final Mat4 transform;

  @override
  late final _args = [?parent];

  @override
  late final _products = [frame];

  late final frame = FrameRef(id, #frame);

  @override
  void execute(EvalContext context) {
    final parent = context.resolveOptional(this.parent);
    final handle = context.transaction.addFrame(cellId('f'), transform: transform, parent: parent);
    context.bind(frame, handle);
  }

  @override
  TransformResult routeTransform(TransformContext context, Symbol product) {
    if (product != #frame) return const .refused();
    return .absorbed(
      (transform) => copyWith(transform: transform * this.transform),
      context.handle(frame),
    );
  }

  @override
  FrameStatement copyWith({Mat4? transform, FrameRef? parent}) => .new(
    transform: transform ?? this.transform,
    parent: parent ?? this.parent?.ref,
    id: id,
  );
}
