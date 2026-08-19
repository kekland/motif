import 'package:ui/ui.dart';
import 'package:color/color.dart';

final class ColorField extends HookWidget {
  const new({
    super.key,
    required this.value,
    required this.onChanged,
    this.options = const TextFieldOptions(),
  });

  final ReadonlySignal<ColorData?> value;
  final ValueChanged<ColorData>? onChanged;
  final TextFieldOptions options;

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    final alpha = useComputed(() {
      final color = value();
      if (color == null) return null;
      return color.alpha * 100.0;
    }, keys: [value]);

    final (createEntry, hasEntry) = useCreateWindowEntry(
      (context) => ColorInputWindow.createEntry(context, value: value, onChanged: onChanged),
    );

    final leading = HookBuilder(
      builder: (context) {
        final iconTheme = IconTheme.of(context);
        final color = useComputed(() => value()?.toUiColor(colorSpace: .sRGB), keys: [value]).value;

        return GestureSurface(
          onTap: () => createEntry(context),
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: context.colors.inverse.withScaledAlpha(0.05)),
          width: iconTheme.size ?? 16.0,
          height: iconTheme.size ?? 16.0,
          color: color,
        );
      },
    );

    final colorInput = ExpressionInputField<ColorData>(
      value: value,
      onChanged: onChanged,
      valueToString: (color) => color?.cssColor.withAlpha(1.0).toString() ?? '',
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
      options: options.merge(
        .new(
          leading: leading,
          borderRadius: .horizontal(left: .circular(4.0), right: .circular(2.0)),
        ),
      ),
    );

    final opacityInput = DoubleExpressionInputField(
      value: alpha,
      fractionDigits: 1,
      supportedDevices: {.mouse, .trackpad},
      onChanged: (a) => onChanged?.call((value.value ?? .black).withAlpha(a / 100)),
      options: .new(
        hintText: '-',
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
