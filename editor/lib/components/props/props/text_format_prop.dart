import 'package:editor/components/props/widgets/inputs/font_family_input_field.dart';
import 'package:editor/components/props/widgets/inputs/font_options_input_field.dart';
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

final class TextFormatProp(
  super.sources, {
  super.kind = .textFormat,
  super.tooltip = const .new('Controls how the text is formatted'),
}) extends Prop<TextFormat, TextFormatPartial> {
  @override
  PropWidget? buildWidget(BuildContext context) => TextFormatPropWidget(prop: this);
}

final class TextFormatPropWidget extends HookWidget with PropWidget {
  const new({
    super.key,
    required this.prop,
    this.isNested = false,
  });

  final TextFormatProp prop;

  @override
  final bool isNested;

  @override
  String resolveHeader(BuildContext context) => 'Text';

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final txn = usePropTransaction();
    final computed = usePropComputed(prop);
    final format = useProxyComputed(computed, (value) => value.resolve());

    return Padding(
      padding: resolvedPadding,
      child: Column(
        children: [
          FontFamilyInputField(
            value: useProxyComputed(format, (v) => v?.fontFamily),
            onChanged: (v) {
              final family = editor.builtinFonts.catalog[v];
              for (final asset in family.assets) editor.maybeAddAsset(asset);
              prop.set(txn, .new(fontFamily: v));
            },
            sessionCallbacks: txn.sessionCallbacks,
          ),
          const SizedBox(height: 8.0),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: FontWeightInputField(
                  values: TextFontWeight.values,
                  value: useProxyComputed(format, (v) => v?.fontWeight),
                  onChanged: (v) => prop.set(txn, .new(fontWeight: v)),
                ),
              ),
              Expanded(
                child: FontSlantInputField(
                  values: TextFontSlant.values,
                  value: useProxyComputed(format, (v) => v?.fontSlant),
                  onChanged: (v) => prop.set(txn, .new(fontSlant: v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          DoubleExpressionInputField(
            value: useProxyComputed(format, (v) => v?.fontSize),
            onChanged: (v) => prop.set(txn, .new(fontSize: v)),
            sessionCallbacks: txn.sessionCallbacks,
            options: .new(leading: Icons.textFormatSize()),
          ),
          const SizedBox(height: 8.0),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: DoubleExpressionInputField(
                  value: useProxyComputed(format, (v) => v?.lineHeight),
                  onChanged: (v) => prop.set(txn, .new(lineHeight: v)),
                  sessionCallbacks: txn.sessionCallbacks,
                  options: .new(leading: Icons.lineHeight()),
                ),
              ),
              Expanded(
                child: DoubleExpressionInputField(
                  value: useProxyComputed(format, (v) => v?.letterSpacing),
                  onChanged: (v) => prop.set(txn, .new(letterSpacing: v)),
                  sessionCallbacks: txn.sessionCallbacks,
                  options: .new(leading: Icons.textFormatLetterSpacing()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
