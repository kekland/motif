part of '../_program.dart';

final class FaceStatement extends Statement with FaceStyledStatement, PlacedStatement, FacedStatement {
  new(
    ChainSelector outer, {
    List<ChainSelector> holes = const [],
    this.style = .default_,
    super.id,
    super.modifiers,
    super.name,
    FrameRef? parent,
  }) : outer = outer.clone(),
       holes = holes.map((h) => h.clone()).toList(),
       parent = .of(parent) {
    selectors = [this.outer, ...this.holes, ?this.parent];
  }

  final ChainSelector outer;
  final List<ChainSelector> holes;

  @override
  FaceStyle get faceStyle => style;
  final FaceStyle style;

  @override
  FaceRef get face => id.cell(.face, 0);

  @override
  final ParentSelector? parent;

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    context.style(face, style);
    yield MakeFaceOp(
      context.resolve(outer),
      holes: [for (final h in holes) context.resolve(h)],
      parent: context.maybeResolve(parent),
    );
  }

  @override
  FaceStatement copyWith({
    StatementId? id,
    List<Modifier>? modifiers,
    String? name,
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
    name: name ?? this.name,
    parent: parent ?? this.parent?.ref,
  );

  @override
  FaceStatement copyWithFaceStyle({FaceStyle? style}) => copyWith(style: style);

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) => .forward([
    ...context.resolve(outer),
    for (final h in holes) ...context.resolve(h),
  ]);

  @override
  ReparentRoute routeReparent(CellRef target) => .accept;

  @override
  Statement absorbReparent(FrameRef to, Mat4 parentTransform) => copyWith(parent: to);
}
