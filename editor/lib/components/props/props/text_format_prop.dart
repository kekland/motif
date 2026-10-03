import 'package:editor/imports.dart';

final class TextFormatPartial({
  final double? fontSize,
  final double? lineHeight,
  final double? letterSpacing,
  final FontFamilyId? fontFamily,
  final TextFontStyle? fontStyle,
  final TextFontWeight? fontWeight,
  final List<TextFontVariation>? variations,
  final List<TextDecorationKind>? decorations,
}) extends Partial<TextFormat> with Equatable {
  @override
  TextFormat apply(TextFormat current) => current.copyWith(
    fontSize: fontSize,
    lineHeight: lineHeight,
    letterSpacing: letterSpacing,
    fontFamily: fontFamily,
    fontStyle: fontStyle,
    fontWeight: fontWeight,
    variations: variations,
    decorations: decorations,
  );

  @override
  List<Object?> get props => [
    fontSize,
    lineHeight,
    letterSpacing,
    fontFamily,
    fontStyle,
    fontWeight,
    variations,
    decorations,
  ];
}

final class TextFormatProp(super.sources, {super.kind = .textFormat}) extends Prop<TextFormat, TextFormatPartial> {
  @override
  PropWidget? buildWidget(BuildContext context) => TextFormatPropWidget(prop: this);
}

final class TextFormatPropWidget extends HookWidget with PropWidget {
  const new({super.key, required this.prop});

  final TextFormatProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Text';

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
