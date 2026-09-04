part of '../../program.dart';

sealed class ShapeStatement<S extends ObjectShape> extends CompositeStatement with PlacedStatement, LayoutBoxStatement {
  ShapeStatement({
    required this.shape,
    LayoutSize? size,
    Mat4? transform,
    this.edgeStyle = .default_,
    this.faceStyle = .default_,
    FrameRef? parent,
    super.id,
    super.scope,
  }) : size = size ?? .zero,
       transform = transform ?? .identity(),
       parent = parent?.borrow();

  final LayoutSize size;
  final Mat4 transform;
  final EdgeStyle edgeStyle;
  final FaceStyle faceStyle;
  final S shape;

  @override
  final Borrow<FrameRef>? parent;

  @override
  late final _args = [?parent];

  late final frame = Ref.frame(this, 'frame');
  late final face = Ref.face(this, 'face');

  @override
  Iterable<Statement> performExpand(EvalContext context) => shape.produce(
    .zero(),
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
  );

  @override
  ShapeStatement copyWith({
    StatementId? id,
    Scope? scope,
    LayoutSize? size,
    Mat4? transform,
    S? shape,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    FrameRef? parent,
  });
}
