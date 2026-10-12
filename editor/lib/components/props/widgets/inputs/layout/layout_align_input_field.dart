import 'package:editor/imports.dart';

final class const LayoutAlignInputField({
  super.key,
  required super.value,
  super.sessionCallbacks,
  super.onChanged,
  super.options,
  final bool canBeNone = false,
  final bool isVertical = false,
}) extends InputField<LayoutAlign> {
  @override
  Widget build(BuildContext context) {
    final value = useExistingSignal(this.value).value;

    void onChange(LayoutAlign newValue) {
      if (value == newValue && canBeNone) return onChanged?.call(.none);
      return onChanged?.call(newValue);
    }

    return Column(
      children: [
        ToggleableButtonRow(
          children: [
            ToggleableButton(
              isActive: value == .start,
              onChanged: (_) => onChange(.start),
              child: isVertical ? Icons.alignVerticalTop() : Icons.alignHorizontalLeft(),
            ),
            ToggleableButton(
              isActive: value == .center,
              onChanged: (_) => onChange(.center),
              child: isVertical ? Icons.alignVerticalCenter() : Icons.alignHorizontalCenter(),
            ),
            ToggleableButton(
              isActive: value == .end,
              onChanged: (_) => onChange(.end),
              child: isVertical ? Icons.alignVerticalBottom() : Icons.alignHorizontalRight(),
            ),
          ],
        ),
      ],
    );
  }
}
