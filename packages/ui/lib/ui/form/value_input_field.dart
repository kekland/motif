import 'package:ui/ui.dart';

class ValueInputField<T> extends InputField<T> {
  const ValueInputField({
    super.key,
    required super.value,
    this.valueToString,
    this.onTap,
    this.onTapDown,
    super.focusNode,
    super.onChanged,
    super.sessionCallbacks,
    super.options,
  });

  final String? Function(T?)? valueToString;
  final VoidCallback? onTap;
  final GestureTapDownCallback? onTapDown;

  @override
  Widget build(BuildContext context) {
    final focusNode = useManagedResource(
      value: this.focusNode,
      create: () => FocusNode(),
      dispose: (v) => v.dispose(),
    );

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

class ContextMenuValueInputField<T> extends InputField<T> {
  const ContextMenuValueInputField({
    super.key,
    required super.value,
    required this.values,
    super.onChanged,
    super.sessionCallbacks,
    super.options,
    this.valueToString,
  });

  final String? Function(T?)? valueToString;
  final List<T> values;

  @override
  Widget build(BuildContext context) {
    final hasFocus = useState(false);
    final valueToString = this.valueToString ?? (v) => v?.toString();

    return ValueInputField<T>(
      value: value,
      onChanged: onChanged,
      sessionCallbacks: sessionCallbacks,
      valueToString: valueToString,
      options: .new(
        leading: Icons.textFormatWeight(),
        hasFocus: hasFocus.value,
      ).merge(options),
      onTapDown: (details) async {
        final options = values.map((w) => ContextMenuItem(w, label: valueToString(w) ?? '$w'));

        hasFocus.value = true;
        final newValue = await ContextMenu.push<T>(
          context,
          .new(options.toList(), selectedValue: value()),
          details: details,
        );

        if (!context.mounted) return;

        hasFocus.value = false;
        if (newValue != null) onChanged?.call(newValue);
      },
    );
  }
}
