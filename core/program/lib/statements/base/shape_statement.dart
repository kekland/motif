part of '../../program.dart';

sealed class ShapeStatement<S extends ObjectShape> extends Statement with PlacedStatement, LayoutBoxStatement {
  ShapeStatement({
    required this.shape,
    LayoutSize? size,
    Mat4? transform,
    this.vertexStyle = .default_,
    this.edgeStyle = .default_,
    this.faceStyle = .default_,
    FrameRef? parent,
    super.id,
    super.modifiers,
  }) : size = size ?? .zero,
       transform = transform ?? .identity(),
       parent = .of(parent);

  @override
  final LayoutSize size;

  @override
  final Mat4 transform;

  @override
  Size2 get intrinsicSize => .zero();

  final VertexStyle vertexStyle;
  final EdgeStyle edgeStyle;
  final FaceStyle faceStyle;
  final S shape;

  @override
  final ParentSelector? parent;

  @override
  late final selectors = [?parent];

  late final frame = shape.frameOf(id);
  late final face = shape.faceOf(id);

  @override
  Iterable<Op> execute(EvalContext context) {
    final (transform, size) = resolveBox(context);

    return shape.execute(
      context,
      transform,
      size,
      parent: context.maybeResolve(parent),
      vertexStyle: vertexStyle,
      edgeStyle: edgeStyle,
      faceStyle: faceStyle,
    );
  }

  @override
  ShapeStatement<S> copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    LayoutSize? size,
    Mat4? transform,
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    FrameRef? parent,
  });

  @override
  DissolveIntent routeDissolve(Set<CellRef<CellHandle>> targeted) => .new({frame});

  @override
  TransformResult routeTransform(EvalContext context, CellRef target) {
    final oldSize = context.placementOf(id).size;
    return .absorb(
      (m) {
        final composed = m * transform;
        final size = oldSize.scale(composed.scaleX, composed.scaleY);

        return copyWith(
          transform: composed.withNormalizedScale(),
          size: .fixed(size.width, size.height),
        );
      },
      frame,
    );
  }
}
