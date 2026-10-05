import 'package:editor/components/props/widgets/inputs/font_family_input_field.dart';
import 'package:editor/imports.dart';

final class TextFormatPartial({
  final double? fontSize,
  final double? lineHeight,
  final double? letterSpacing,
  final String? fontFamily,
  final TextFontSlant? fontSlant,
  final TextFontWeight? fontWeight,
  final TextFontWidth? fontWidth,
  final List<TextDecorationKind>? decorations,
}) extends Partial<TextFormat> with Equatable {
  @override
  TextFormat apply(TextFormat current) => current.copyWith(
    fontSize: fontSize,
    lineHeight: lineHeight,
    letterSpacing: letterSpacing,
    fontFamily: fontFamily,
    fontSlant: fontSlant,
    fontWeight: fontWeight,
    fontWidth: fontWidth,
    decorations: decorations,
  );

  @override
  List<Object?> get props => [
    fontSize,
    lineHeight,
    letterSpacing,
    fontFamily,
    fontSlant,
    fontWeight,
    fontWidth,
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
    final editor = context.editor;
    final transaction = usePropTransaction();
    final computed = usePropComputed(prop);
    final fontFamily = useProxyComputed(
      computed,
      (value) => value.resolve()?.fontFamily,
    );

    return Padding(
      padding: PropWidget.padding,
      child: Column(
        children: [
          FontFamilyInputField(
            value: fontFamily,
            onChanged: (v) {
              final family = editor.builtinFonts.catalog[v];
              for (final asset in family.assets) editor.maybeAddAsset(asset);
              transaction.edit((txn) => prop.set(txn, .new(fontFamily: v)));
            },
            sessionCallbacks: transaction.sessionCallbacks,
          ),
        ],
      ),
    );
  }
}
