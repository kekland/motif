import 'package:editor/imports.dart';

final class const FontWeightInputField({
  super.key,
  required final List<TextFontWeight> values,
  required super.value,
  super.onChanged,
  super.sessionCallbacks,
  super.options,
}) extends InputField<TextFontWeight> {
  @override
  Widget build(BuildContext context) {
    return ValueInputField<TextFontWeight>(
      value: value,
      onChanged: onChanged,
      sessionCallbacks: sessionCallbacks,
      valueToString: (w) => w?.resolveName(context),
      options: .new(
        leading: Icons.textFormatWeight(),
      ).merge(options),
      onTapDown: (details) async {
        final options = values.map((w) => ContextMenuItem(w, label: w.resolveName(context)));
        final newValue = await ContextMenu.push<TextFontWeight>(
          context,
          .new(options.toList(), selectedValue: value()),
          details: details,
        );

        if (context.mounted && newValue != null) onChanged?.call(newValue);
      },
    );
  }
}

final class const FontSlantInputField({
  super.key,
  required final List<TextFontSlant> values,
  required super.value,
  super.onChanged,
  super.sessionCallbacks,
  super.options,
}) extends InputField<TextFontSlant> {
  @override
  Widget build(BuildContext context) {
    return ValueInputField<TextFontSlant>(
      value: value,
      onChanged: onChanged,
      sessionCallbacks: sessionCallbacks,
      valueToString: (w) => w?.resolveName(context),
      options: .new(
        leading: Icons.textFormatSlant(),
      ).merge(options),
      onTapDown: (details) async {
        final options = values.map((w) => ContextMenuItem(w, label: w.resolveName(context)));
        final newValue = await ContextMenu.push<TextFontSlant>(
          context,
          .new(options.toList(), selectedValue: value()),
          details: details,
        );

        if (context.mounted && newValue != null) onChanged?.call(newValue);
      },
    );
  }
}
