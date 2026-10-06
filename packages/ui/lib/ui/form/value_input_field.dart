import 'package:ui/ui.dart';

class ValueInputField<T> extends InputField<T> {
  const ValueInputField({
    super.key,
    required super.value,
    this.valueToString,
    this.onTap,
    this.onTapDown,
    super.onChanged,
    super.sessionCallbacks,
    super.options,
  });

  final String? Function(T?)? valueToString;
  final VoidCallback? onTap;
  final GestureTapDownCallback? onTapDown;

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final valueToString = this.valueToString ?? (v) => v?.toString();
    final textValue = useProxyComputed(value, (v) => valueToString(v));

    return InputFieldBase(
      onTap: onTap,
      onTapDown: onTapDown,
      options: options,
      focusNode: focusNode,
      cursor: SystemMouseCursors.click,
      builder: (context, focusNode, style, hintStyle) {
        return SignalBuilder(
          builder: (context) {
            final text = textValue();
            return Text(
              text ?? options.hintText ?? '',
              style: text != null ? style : hintStyle,
            );
          },
        );
      },
    );
  }
}
