part of '../_program.dart';

final class TextStatement extends Statement with PlacedStatement, FramedStatement, LayoutBoxStatement {
  TextStatement({
    required this.text,
    required this.textFormat,
    this.paragraphFormat = .default_,
    this.vertexStyle = .default_,
    this.edgeStyle = .default_,
    this.faceStyle = .default_,
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
  final TextFormat textFormat;
  final ParagraphFormat paragraphFormat;
  final VertexStyle vertexStyle;
  final EdgeStyle edgeStyle;
  final FaceStyle faceStyle;

  @override
  final LayoutSize size;

  @override
  final Mat4 transform;

  @override
  Size2 intrinsicSize(Evaluation e) {
    final paragraph = buildParagraph(e);
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
    TextFormat? textFormat,
    ParagraphFormat? paragraphFormat,
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
  }) => .new(
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    size: size ?? this.size,
    transform: transform ?? this.transform,
    parent: parent ?? this.parent?.ref,
    text: text ?? this.text,
    textFormat: textFormat ?? this.textFormat,
    paragraphFormat: paragraphFormat ?? this.paragraphFormat,
    vertexStyle: vertexStyle ?? this.vertexStyle,
    edgeStyle: edgeStyle ?? this.edgeStyle,
    faceStyle: faceStyle ?? this.faceStyle,
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

  @override
  bool frameContentRepaints(TextStatement old, TextStatement current) => true;
}

// ---------------------------------------------------------------------------------------------------------------------
// Paragraph builder
// ---------------------------------------------------------------------------------------------------------------------

extension ParagraphBuilder on TextStatement {
  skia.Paragraph buildParagraph(Evaluation e) {
    final context = e.contextFor(id);

    final family = context.resolveAsset<FontAsset>(textFormat.fontFamily)!;

    final skWeight = skia.FontWeight(textFormat.fontWeight.value);
    final skWidth = family.widths.first;
    final skSlant = switch (textFormat.fontStyle) {
      .regular => skia.FontSlant.upright,
      .italic => skia.FontSlant.italic,
    };

    final fontFile = family.resolveFile(weight: skWeight, width: skWidth, slant: skSlant)!;
    context.fetchAssetData(fontFile.id);

    final paragraphStyle = skia.ParagraphStyle(
      alignment: switch (paragraphFormat.alignment) {
        .left => .left,
        .right => .right,
        .center => .center,
        .justify => .justify,
      },
      ellipsis: paragraphFormat.ellipsis,
    );

    final textStyle = skia.TextStyle(
      fontSize: textFormat.fontSize,
      fontFamilies: [family.family],
      fontStyle: .new(weight: skWeight, width: skWidth, slant: skSlant),
      height: textFormat.lineHeight,
      letterSpacing: textFormat.letterSpacing,
    );

    final fontProvider = e.assetCache!.font.provider;
    final builder = skia.ParagraphBuilder(paragraphStyle, fontProvider);
    builder.pushStyle(textStyle);
    builder.addText(text);
    builder.popStyle();
    return builder.build();
  }
}

// ---------------------------------------------------------------------------------------------------------------------
// Text/paragraph styles
// ---------------------------------------------------------------------------------------------------------------------

enum TextDecorationKind { underline, overline, strikethrough }

sealed class const TextFontVariation();
final class const TextFontVariationItalic(final double value);
final class const TextFontVariationWeight(final double value);
final class const TextFontVariationWidth(final double value);
final class const TextFontVariationSlant(final double value);

enum TextFontStyle { regular, italic }

enum TextFontWeight {
  thin(100),
  extraLight(200),
  light(300),
  regular(400),
  medium(500),
  semiBold(600),
  bold(700),
  extraBold(800),
  black(900);

  const new(this.value);
  final int value;
}

final class const TextFormat({
  required final double fontSize,
  final double lineHeight = 1.0,
  final double letterSpacing = 0.0,
  required final FontFamilyId fontFamily,
  final TextFontStyle fontStyle = .regular,
  final TextFontWeight fontWeight = .regular,
  final List<TextFontVariation> variations = const [],
  final List<TextDecorationKind> decorations = const [],
}) with Equatable {
  static TextFormat default_(FontCatalog catalog) {
    return .new(
      fontFamily: catalog.assets.values.first.id,
      fontSize: 16.0,
    );
  }

  TextFormat copyWith({
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,
    FontFamilyId? fontFamily,
    TextFontStyle? fontStyle,
    TextFontWeight? fontWeight,
    List<TextFontVariation>? variations,
    List<TextDecorationKind>? decorations,
  }) => .new(
    fontFamily: fontFamily ?? this.fontFamily,
    fontSize: fontSize ?? this.fontSize,
    lineHeight: lineHeight ?? this.lineHeight,
    letterSpacing: letterSpacing ?? this.letterSpacing,
    fontStyle: fontStyle ?? this.fontStyle,
    fontWeight: fontWeight ?? this.fontWeight,
    variations: variations ?? this.variations,
    decorations: decorations ?? this.decorations,
  );

  @override
  List<Object?> get props => [fontSize, lineHeight, letterSpacing, fontStyle, fontWeight, variations, decorations];
}

enum TextAlignment { left, right, center, justify }

enum TextVerticalAlignment { top, middle, bottom }

final class const ParagraphFormat({
  final TextAlignment alignment = .left,
  final TextVerticalAlignment verticalAlignment = .top,
  final String? ellipsis,
}) with Equatable {
  static const default_ = ParagraphFormat();

  ParagraphFormat copyWith({
    TextAlignment? alignment,
    TextVerticalAlignment? verticalAlignment,
    String? ellipsis,
  }) => .new(
    alignment: alignment ?? this.alignment,
    verticalAlignment: verticalAlignment ?? this.verticalAlignment,
    ellipsis: ellipsis ?? this.ellipsis,
  );

  @override
  List<Object?> get props => [alignment, verticalAlignment, ellipsis];
}
