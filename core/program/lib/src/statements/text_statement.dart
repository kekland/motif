part of '../_program.dart';

final class TextStatement extends Statement
    with
        VertexStyledStatement,
        EdgeStyledStatement,
        FaceStyledStatement,
        PlacedStatement,
        FramedStatement,
        LayoutBoxStatement {
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
    super.name,
  }) : size = size ?? .zero,
       transform = transform ?? .identity(),
       parent = .of(parent) {
    selectors = [?this.parent];
  }

  final String text;
  final TextFormat textFormat;
  final ParagraphFormat paragraphFormat;

  @override
  final VertexStyle vertexStyle;

  @override
  final EdgeStyle edgeStyle;

  @override
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
    String? name,
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
    name: name ?? this.name,
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
  TextStatement copyWithVertexStyle({VertexStyle? style}) => copyWith(vertexStyle: style);

  @override
  TextStatement copyWithEdgeStyle({EdgeStyle? style}) => copyWith(edgeStyle: style);

  @override
  TextStatement copyWithFaceStyle({FaceStyle? style}) => copyWith(faceStyle: style);

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

    final familyName = textFormat.fontFamily;
    final family = e.assetManifest.fontCatalog[familyName];

    final face = family.resolveClosest(
      weight: textFormat.skWeight,
      width: textFormat.skWidth,
      slant: textFormat.skSlant,
    );

    final asset = family.assetFor(face);
    context.loadAsset(asset);

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
      fontFamilies: [familyName],
      fontStyle: .new(weight: face.weight, width: face.width, slant: face.slant),
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

enum TextFontSlant { upright, italic, oblique }

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

enum TextFontWidth {
  ultraCondensed(1),
  extraCondensed(2),
  condensed(3),
  semiCondensed(4),
  normal(5),
  semiExpanded(6),
  expanded(7),
  extraExpanded(8),
  ultraExpanded(9);

  const new(this.value);
  final int value;
}

final class const TextFormat({
  required final double fontSize,
  final double lineHeight = 1.0,
  final double letterSpacing = 0.0,
  required final String fontFamily,
  final TextFontWidth fontWidth = .normal,
  final TextFontWeight fontWeight = .regular,
  final TextFontSlant fontSlant = .upright,
  final List<TextDecorationKind> decorations = const [],
}) with Equatable {
  static TextFormat default_(FontCatalog catalog) {
    return .new(
      fontFamily: catalog.families.values.first.name,
      fontSize: 16.0,
    );
  }

  TextFormat copyWith({
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,
    String? fontFamily,
    TextFontSlant? fontSlant,
    TextFontWeight? fontWeight,
    TextFontWidth? fontWidth,
    List<TextDecorationKind>? decorations,
  }) => .new(
    fontFamily: fontFamily ?? this.fontFamily,
    fontSize: fontSize ?? this.fontSize,
    lineHeight: lineHeight ?? this.lineHeight,
    letterSpacing: letterSpacing ?? this.letterSpacing,
    fontSlant: fontSlant ?? this.fontSlant,
    fontWeight: fontWeight ?? this.fontWeight,
    fontWidth: fontWidth ?? this.fontWidth,
    decorations: decorations ?? this.decorations,
  );

  @override
  List<Object?> get props => [
    fontFamily,
    fontSize,
    lineHeight,
    letterSpacing,
    fontSlant,
    fontWeight,
    fontWidth,
    decorations,
  ];

  skia.FontStyle get skStyle => .new(
    weight: skWeight,
    width: skWidth,
    slant: skSlant,
  );

  skia.FontWeight get skWeight => .new(fontWeight.value);
  skia.FontWidth get skWidth => .new(fontWidth.value);
  skia.FontSlant get skSlant => switch (fontSlant) {
    .upright => .upright,
    .italic => .italic,
    .oblique => .oblique,
  };

  FontFace resolveClosest(FontFamily family) => family.resolveClosest(
    weight: skWeight,
    width: skWidth,
    slant: skSlant,
  );
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
