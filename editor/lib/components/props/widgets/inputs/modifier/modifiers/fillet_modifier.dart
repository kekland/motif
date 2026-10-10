import 'package:editor/imports.dart';

final class const FilletModifierInputField({
  super.key,
  required super.value,
  super.onChanged,
  super.sessionCallbacks,
  super.focusNode,
  super.options,
}) extends InputField<FilletModifier> {
  @override
  Widget build(BuildContext context) {
    final radius = useProxyComputed(value, (m) => m!.radius?.x ?? 0.0);

    return DoubleExpressionInputField(
      value: radius,
      onChanged: (v) => onChanged?.call(.new(radius: .new(v, v))),
      options: .new(leading: Icons.borderRadius()),
    );
  }
}
