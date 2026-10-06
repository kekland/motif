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
    return ContextMenuValueInputField<TextFontWeight>(
      value: value,
      values: values,
      onChanged: onChanged,
      sessionCallbacks: sessionCallbacks,
      valueToString: (w) => w?.resolveName(context),
      options: .new(leading: Icons.textFormatWeight()).merge(options),
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
    return ContextMenuValueInputField<TextFontSlant>(
      value: value,
      values: values,
      onChanged: onChanged,
      sessionCallbacks: sessionCallbacks,
      valueToString: (w) => w?.resolveName(context),
      options: .new(leading: Icons.textFormatSlant()).merge(options),
    );
  }
}
