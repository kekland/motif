part of '../../_program.dart';

sealed class ShapeStatement<S extends ObjectShape> extends Statement
    with
        VertexStyledStatement,
        EdgeStyledStatement,
        FaceStyledStatement,
        PlacedStatement,
        FramedStatement,
        LayoutBoxStatement,
        FacedStatement {
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
    super.name,
  }) : size = size ?? .zero,
       transform = transform ?? .identity(),
       parent = .of(parent) {
    selectors = [?this.parent];
  }

  @override
  LayoutSize resolveSize(EvalContext context) => size;
  final LayoutSize size;

  @override
  final Mat4 transform;

  @override
  Size2 intrinsicSize(Evaluation evaluation) => .zero();

  @override
  final VertexStyle vertexStyle;

  @override
  final EdgeStyle edgeStyle;

  @override
  final FaceStyle faceStyle;

  final S shape;

  @override
  final ParentSelector? parent;

  @override
  bool get isLeaf => true;

  @override
  late final frame = shape.frameOf(id);

  @override
  late final face = shape.faceOf(id);

  @override
  Iterable<Op> execute(EvalContext context) {
    var (transform, size) = resolveBox(context);
    transform = frameTransformOf(context, transform, parent: parent?.ref);

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
    ModifierStack? modifiers,
    String? name,
    LayoutSize? size,
    Mat4? transform,
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    FrameRef? parent,
    S? shape,
  });

  @override
  ShapeStatement<S> applyPartial(StatementPartial partial) => copyWith(
    modifiers: partial.field(#modifiers),
    name: partial.field(#name),
    size: partial.field(#layoutSize),
    transform: partial.field(#transform),
    shape: partial.field(#objectShape),
    vertexStyle: partial.field(#vertexStyle),
    edgeStyle: partial.field(#edgeStyle),
    faceStyle: partial.field(#faceStyle),
  );

  @override
  DissolveIntent routeDissolve(Set<CellRef<CellHandle>> targeted) => .new({frame});
}
