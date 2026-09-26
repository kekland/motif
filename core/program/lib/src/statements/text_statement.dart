part of '../_program.dart';

final class TextStatement extends Statement with PlacedStatement, FramedStatement, LayoutBoxStatement {
  TextStatement({
    required this.text,
    LayoutSize? size,
    Mat4? transform,
    FrameRef? parent,
    super.id,
    super.modifiers,
  }) : size = size ?? .zero,
       transform = transform ?? .identity(),
       parent = .of(parent) {
    selectors = [?this.parent];
  }

  final String text;

  @override
  final LayoutSize size;

  @override
  final Mat4 transform;

  @override
  Size2 intrinsicSize(Evaluation e) {
    final textStyle = skia.TextStyle(fontFamilies: e.fontProvider.families);
    final paragraphStyle = skia.ParagraphStyle();
    final paragraphBuilder = skia.ParagraphBuilder(paragraphStyle, e.fontProvider);
    paragraphBuilder.pushStyle(textStyle);
    paragraphBuilder.addText(text);
    paragraphBuilder.popStyle();
    final paragraph = paragraphBuilder.build();
    paragraph.layout(double.infinity);
    return Size2(paragraph.maxIntrinsicWidth, paragraph.height);
  }

  @override
  final ParentSelector? parent;

  @override
  bool get isLeaf => true;

  @override
  late final frame = id.cell(.frame, 0);

  @override
  Iterable<Op<dynamic>> execute(EvalContext context) sync* {
    var (transform, size) = resolveBox(context);
    transform = frameTransformOf(context, transform, parent: parent?.ref);

    yield AddFrameOp(
      transform,
      size: size,
      parent: context.maybeResolve(parent),
    );
  }

  @override
  TextStatement copyWith({
    StatementId? id,
    List<Modifier<Statement>>? modifiers,
    LayoutSize? size,
    Mat4? transform,
    FrameRef? parent,
    String? text,
  }) => TextStatement(
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    size: size ?? this.size,
    transform: transform ?? this.transform,
    parent: parent ?? this.parent?.ref,
    text: text ?? this.text,
  );

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) => .absorb;

  @override
  TransformAbsorb absorbTransform(EvalContext context, Set<Ref> absorbed, Set<Ref> all) {
    final oldSize = context.placementOf(id).size;

    return .new(
      (m, snapToPixel) {
        final placement = this.transform * m.unmirrored(oldSize);
        var transform = placement.withNormalizedScale();
        Size2? size = oldSize.scale(placement.scaleX, placement.scaleY);
        if (oldSize.equals(size!)) size = null;

        if (snapToPixel) {
          final translation = transform.translation2.round();
          transform.setTranslation(translation.x, translation.y);
          size = size?.round();
        }

        return copyWith(
          transform: transform,
          size: size != null ? .fixed(size.width, size.height) : null,
        );
      },
      cell: frame,
    );
  }
}
