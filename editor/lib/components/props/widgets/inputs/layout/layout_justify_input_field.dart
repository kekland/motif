import 'package:editor/imports.dart';

final class const LayoutJustifyInputField({
  super.key,
  required super.value,
  super.sessionCallbacks,
  super.onChanged,
  super.options,
  final bool isVertical = false,
}) extends InputField<LayoutJustify> {
  @override
  Widget build(BuildContext context) {
    final value = useExistingSignal(this.value).value;

    final turns = isVertical ? 1 : 0;

    return Column(
      children: [
        ToggleableButtonRow(
          children: [
            ToggleableButton(
              isActive: value == .start,
              onChanged: (_) => onChanged?.call(.start),
              child: RotatedBox(quarterTurns: turns, child: Icons.justifyStart()),
            ),
            ToggleableButton(
              isActive: value == .center,
              onChanged: (_) => onChanged?.call(.center),
              child: RotatedBox(quarterTurns: turns, child: Icons.justifyCenter()),
            ),
            ToggleableButton(
              isActive: value == .end,
              onChanged: (_) => onChanged?.call(.end),
              child: RotatedBox(quarterTurns: turns, child: Icons.justifyEnd()),
            ),
            ToggleableButton(
              isActive: value == .spaceBetween,
              onChanged: (_) => onChanged?.call(.spaceBetween),
              child: RotatedBox(quarterTurns: turns, child: Icons.justifySpaceBetween()),
            ),
          ],
        ),
      ],
    );
  }
}
