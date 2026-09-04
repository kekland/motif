part of '../program.dart';

final class Face extends Statement with PlacedStatement {
  new(
    this.outer, {
    this.holes = const [],
    this.style = .default_,
    super.id,
    super.modifiers,
    FrameRef? parent,
  }) : parent = parent != null ? ParentSelector(parent) : null;

  final ChainSelector outer;
  final List<ChainSelector> holes;
  final FaceStyle style;

  FaceRef get ref => id.cell(.face, 0);

  @override
  final ParentSelector? parent;

  @override
  late final selectors = [outer, ...holes, ?parent];

  @override
  Iterable<Op> ops(EvalContext context) sync* {
    yield MakeFaceOp(
      context.resolve(outer),
      holes: [for (final h in holes) context.resolve(h)],
      parent: context.maybeResolve(parent),
    );
  }

  @override
  Face copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    ChainSelector? outer,
    List<ChainSelector>? holes,
    FaceStyle? style,
    FrameRef? parent,
  }) => .new(
    outer ?? this.outer,
    holes: holes ?? this.holes,
    style: style ?? this.style,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    parent: parent ?? this.parent?.ref,
  );

  @override
  TransformResult routeTransform(EvalContext context, CellRef target) => .forward([
    ...context.resolve(outer),
    for (final h in holes) ...context.resolve(h),
  ]);
}
