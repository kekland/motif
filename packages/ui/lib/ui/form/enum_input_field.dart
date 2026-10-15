import 'package:ui/ui.dart';

final class const EnumInputField<T>({
  super.key,
  required final List<T> values,
  required super.value,
  super.valueToString,
  super.sessionCallbacks,
  super.focusNode,
  super.onChanged,
  super.options,
}) extends ValueInputField<T> {
  @override
  Widget build(BuildContext context) {
    final valueToString = this.valueToString ?? (v) => v is Enum ? v.name : v.toString();

    return ValueInputField<T>(
      value: value,
      valueToString: valueToString,
      focusNode: focusNode,
      onChanged: onChanged,
      sessionCallbacks: sessionCallbacks,
      options: options.copyWith(
        trailing: Icons.chevronRight(),
      ),
      onTap: () async {
        final menu = ContextMenu([for (final v in values) .item(v, label: valueToString(v)!)]);
        final result = await ContextMenu.push(context, menu);
        if (result is T && context.mounted) {
          onChanged?.call(result);
        }
      },
    );
  }
}
