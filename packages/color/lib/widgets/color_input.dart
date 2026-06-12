import 'package:color/color.dart';
import 'package:ui/ui.dart';

part 'color_input_mobile.dart';

class ColorInputField extends HookWidget {
  const ColorInputField({
    super.key,
    required this.value,
    this.onChanged,
  });

  final ColorData value;
  final ValueChanged<ColorData>? onChanged;

  @override
  Widget build(BuildContext context) {
    final valueSignal = useComputed(() => value);
    final (createEntry, _) = useCreateWindowEntry(
      context,
      (context) => ColorPickerWindow.createEntry(context, value: valueSignal, onChanged: onChanged),
    );

    // return VariantBuilder(
    //   mobile: (context) => _ColorInputMobile(),
    //   desktop: (context) {
    final leading = Builder(
      builder: (context) {
        final iconTheme = IconTheme.of(context);
        return GestureSurface(
          onTap: createEntry,
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: context.colors.inverse.withScaledAlpha(0.05)),
          width: iconTheme.size ?? 16.0,
          height: iconTheme.size ?? 16.0,
          color: value.toUiColor(colorSpace: .sRGB),
        );
      },
    );

    return GestureSurface(
      onTap: createEntry,
      supportedDevices: {.stylus, .touch},
      child: ExpressionInputField<ColorData>(
        value: value,
        onChanged: onChanged,
        valueToString: (color) => color?.cssColor.withAlpha(1.0).toString() ?? 'none',
        supportedDevices: {.mouse, .trackpad},
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
                  value: value.alpha * 100,
                  fractionDigits: 1,
                  supportedDevices: {.mouse, .trackpad},
                  onChanged: (a) => onChanged?.call(value.withAlpha(a / 100)),
                  options: .new(trailing: Text('%')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    //   },
    // );
  }
}
