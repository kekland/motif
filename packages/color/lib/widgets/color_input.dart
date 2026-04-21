import 'package:color/widgets/color_picker_window.dart';
import 'package:flutter/foundation.dart';
import 'package:color/color.dart';
import 'package:ui/ui.dart';

import 'package:vector_math/vector_math_64.dart' hide Colors;

class ColorInputField extends StatefulWidget {
  const ColorInputField({
    super.key,
    required this.value,
    this.onChanged,
  });

  final ColorData value;
  final ValueChanged<ColorData>? onChanged;

  @override
  State<ColorInputField> createState() => _ColorInputFieldState();
}

class _ColorInputFieldState extends State<ColorInputField> {
  WindowEntry? _windowEntry;
  late final _valueListenable = ValueNotifier(widget.value);

  @override
  void didUpdateWidget(covariant ColorInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // TODO: maybe hoist the value listenable up to avoid a frame delay?
    WidgetsBinding.instance.addPostFrameCallback((_) => _valueListenable.value = widget.value);
  }

  @override
  void dispose() {
    _valueListenable.dispose();
    _windowEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leading = Builder(
      builder: (context) {
        final iconTheme = IconTheme.of(context);
        return GestureSurface(
          onTap: () {
            if (_windowEntry != null) return;

            _windowEntry = ColorPickerWindow.createEntry(
              value: _valueListenable,
              onChanged: widget.onChanged,
              onRemoved: () => _windowEntry = null,
            );

            _windowEntry!.insert(context);
          },
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: context.colors.inverse.withScaledAlpha(0.05)),
          width: iconTheme.size ?? 16.0,
          height: iconTheme.size ?? 16.0,
          color: widget.value.toUiColor(colorSpace: .sRGB),
        );
      },
    );

    return ExpressionInputField<ColorData>(
      value: widget.value,
      onChanged: widget.onChanged,
      valueToString: (color) => color?.cssColor.withAlpha(1.0).toString() ?? 'none',
      evaluateExpression: (str) {
        return .transparent;
        // final value = evaluateExpression<Vector4>(str);
        // return Color.fromARGB(
        //   value.w.clamp(0, 255).round(),
        //   value.x.clamp(0, 255).round(),
        //   value.y.clamp(0, 255).round(),
        //   value.z.clamp(0, 255).round(),
        // );
      },
      options: .new(
        leading: leading,
        trailing: Row(
          mainAxisSize: .min,
          children: [
            VerticalDivider(),
            const SizedBox(width: 2.0),
            SizedBox(
              width: 80.0,
              child: DoubleExpressionInputField(
                value: widget.value.alpha * 100,
                fractionDigits: 1,
                onChanged: (a) => widget.onChanged?.call(widget.value.withAlpha(a / 100)),
                options: .new(trailing: Text('%')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
