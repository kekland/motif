import 'package:flutter/foundation.dart';
import 'package:ui/ui.dart';

import 'package:vector_math/vector_math_64.dart' hide Colors;

class ColorInputField extends StatelessWidget {
  const ColorInputField({
    super.key,
    required this.value,
    this.onChanged,
    this.valueListenable,
  });

  final Color value;
  final ValueChanged<Color>? onChanged;
  final ValueListenable<Color>? valueListenable;

  @override
  Widget build(BuildContext context) {
    final leading = Builder(
      builder: (context) {
        final iconTheme = IconTheme.of(context);
        return GestureSurface(
          onTap: () => ColorPickerWindow.createEntry(value: valueListenable!, onChanged: onChanged).insert(context),
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: context.colors.inverse.withScaledAlpha(0.05)),
          width: iconTheme.size ?? 16.0,
          height: iconTheme.size ?? 16.0,
          color: value,
        );
      },
    );

    return ExpressionInputField(
      value: value,
      onChanged: onChanged,
      valueToString: (color) =>
          color?.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase() ?? '<none>',
      evaluateExpression: (str) {
        final value = evaluateExpression<Vector4>(str);
        return Color.fromARGB(
          value.w.clamp(0, 255).round(),
          value.x.clamp(0, 255).round(),
          value.y.clamp(0, 255).round(),
          value.z.clamp(0, 255).round(),
        );
      },
      options: .new(
        leading: valueListenable != null ? leading : null,
        trailing: Row(
          mainAxisSize: .min,
          children: [
            VerticalDivider(),
            const SizedBox(width: 2.0),
            SizedBox(
              width: 80.0,
              child: DoubleExpressionInputField(
                value: value.a * 100,
                fractionDigits: 1,
                onChanged: (a) => onChanged?.call(value.withAlpha(((a / 100) * 255).round())),
                options: .new(trailing: Text('%')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
