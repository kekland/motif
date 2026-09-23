import 'package:ui/ui.dart';
import 'package:color/color_flutter.dart';

final class ColorField extends HookWidget {
  const new({
    super.key,
    required this.value,
    required this.onChanged,
    this.options = const TextFieldOptions(),
  });

  final ReadonlySignal<ColorDataPartial> value;
  final ValueChanged<ColorDataPartial>? onChanged;
  final TextFieldOptions options;

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    final alpha = useComputed(() {
      final alpha = value().alpha;
      if (alpha == null) return null;
      return alpha * 100.0;
    }, keys: [value]);

    final window = usePortalEntry(
      () => WindowEntry(
        builder: (context) => ColorInputWindow(value: value, onChanged: onChanged),
        isModal: true,
      ),
    );

    final leading = HookBuilder(
      builder: (context) {
        final iconTheme = IconTheme.of(context);
        final color = useComputed(
          () {
            final partial = value();
            if (!partial.canConstruct) return null;
            return partial.construct().toUiColor();
          },
          keys: [value],
        ).value;

        return GestureSurface(
          onTap: () => window.push(context),
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: context.colors.inverse.withScaledAlpha(0.05)),
          width: iconTheme.size ?? 16.0,
          height: iconTheme.size ?? 16.0,
          color: color,
        );
      },
    );

    final colorInput = ExpressionInputField<ColorDataPartial>(
      value: value,
      onChanged: onChanged,
      valueToString: (value) => value?.canConstruct == true ? value!.apply(.black).toString() : 'Mixed',
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
      onChanged: (a) => onChanged?.call(.withAlpha(a / 100)),
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
          onTap: () => window.push(context),
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
