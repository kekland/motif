import 'package:ui/ui.dart';
import 'package:color/color.dart';

final class ColorField extends HookWidget {
  const new({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ColorData value;
  final ValueChanged<ColorData>? onChanged;

  @override
  Widget build(BuildContext context) {
    final valueSignal = useComputed(() => value);
    final (createEntry, hasEntry) = useCreateWindowEntry(
      (context) => ColorInputWindow.createEntry(context, value: valueSignal, onChanged: onChanged),
    );

    final leading = Builder(
      builder: (context) {
        final iconTheme = IconTheme.of(context);
        return GestureSurface(
          onTap: () => createEntry(context),
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: context.colors.inverse.withScaledAlpha(0.05)),
          width: iconTheme.size ?? 16.0,
          height: iconTheme.size ?? 16.0,
          color: value.toUiColor(colorSpace: .sRGB),
        );
      },
    );

    final colorInput = ExpressionInputField<ColorData>(
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
        borderRadius: .horizontal(left: .circular(4.0), right: .circular(2.0)),
      ),
    );

    final opacityInput = DoubleExpressionInputField(
      value: value.alpha * 100,
      fractionDigits: 1,
      supportedDevices: {.mouse, .trackpad},
      onChanged: (a) => onChanged?.call(value.withAlpha(a / 100)),
      options: .new(
        trailing: Text('%'),
        borderRadius: .horizontal(right: .circular(4.0), left: .circular(2.0)),
      ),
    );

    return GestureSurface(
      onTap: () => createEntry(context),
      supportedDevices: {.stylus, .touch},
      child: Row(
        children: [
          Expanded(
            child: colorInput,
          ),
          const SizedBox(width: 2.0),
          SizedBox(
            width: 80.0,
            child: opacityInput,
          ),
        ],
      ),
    );
  }
}
