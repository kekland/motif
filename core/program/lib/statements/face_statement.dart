part of '../program.dart';

final class FaceStatement extends Statement with PlacedStatement {
  new(
    this.outer, {
    this.holes = const [],
    this.style = .default_,
    super.id,
    super.enabled,
    FrameRef? parent,
  }) : parent = .of(parent);

  final ChainSelector outer;
  final List<ChainSelector> holes;
  final FaceStyle style;

  FaceRef get ref => id.cell(.face, 0);

  @override
  final ParentSelector? parent;

  @override
  late final selectors = [outer, ...holes, ?parent];

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    context.style(ref, style);
    yield MakeFaceOp(
      context.resolve(outer),
      holes: [for (final h in holes) context.resolve(h)],
      parent: context.maybeResolve(parent),
    );
  }

  @override
  FaceStatement copyWith({
    StatementId? id,
    bool? enabled,
    ChainSelector? outer,
    List<ChainSelector>? holes,
    FaceStyle? style,
    FrameRef? parent,
  }) => .new(
    outer ?? this.outer,
    holes: holes ?? this.holes,
    style: style ?? this.style,
    id: id ?? this.id,
    enabled: enabled ?? this.enabled,
    parent: parent ?? this.parent?.ref,
  );

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) => .forward([
    ...context.resolve(outer),
    for (final h in holes) ...context.resolve(h),
  ]);
}
