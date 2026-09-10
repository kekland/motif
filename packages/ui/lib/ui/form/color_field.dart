import 'package:ui/ui.dart';
import 'package:color/color_flutter.dart';

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
      valueToString: (color) => color?.withAlpha(1.0).toString() ?? '',
      supportedDevices: {.mouse, .trackpad},
      evaluateExpression: (str) => null,
      options: options.merge(
        .new(
          leading: leading,
          borderRadius: .horizontal(left: .circular(4.0)),
          color: context.colors.surface.secondary.withScaledAlpha(0.0),
          border: .new(color: context.colors.divider.withScaledAlpha(0.0)),
        ),
      ),
    );

    final opacityInput = DoubleExpressionInputField(
      value: alpha,
      fractionDigits: 1,
      supportedDevices: {.mouse, .trackpad},
      onChanged: (a) => onChanged?.call((value.value ?? .black).withAlpha(a / 100)),
      options: .new(
        hintText: '0',
        trailing: Text('%'),
        borderRadius: .horizontal(right: .circular(4.0)),
        color: context.colors.surface.secondary.withScaledAlpha(0.0),
        padding: const .only(left: 8.0, right: 6.0),
        border: .new(color: context.colors.divider.withScaledAlpha(0.0)),
      ),
    );

    return Stack(
      children: [
        Positioned.fill(
          child: Surface(
            color: context.colors.surface.secondary,
            borderSide: .new(color: context.colors.divider),
            borderRadius: .circular(4.0),
          ),
        ),
        Positioned(
          right: 80.0,
          child: SizedBox(height: 32.0, child: VerticalDivider()),
        ),
        GestureSurface(
          onTap: () => createEntry(context),
          supportedDevices: {.stylus, .touch},
          borderRadius: .circular(4.0),
          child: Row(
            children: [
              Expanded(
                child: colorInput,
              ),
              SizedBox(
                width: 80.0,
                child: opacityInput,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
