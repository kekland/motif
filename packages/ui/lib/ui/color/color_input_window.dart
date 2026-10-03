import 'package:color/color_flutter.dart';
import 'package:ui/ui.dart';

part 'components/drag_handle.dart';
part 'components/hsv_square.dart';
part 'components/slider.dart';
part 'components/sliders.dart';

class ColorInputWindow extends HookWidget {
  const new({
    super.key,
    required this.field,
  });

  final InputField<ColorDataPartial> field;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      width: 240.0,
      child: ColorInputWindowBody(
        value: field.value,
        onChanged: field.onChanged,
        sessionCallbacks: field.sessionCallbacks,
      ),
    );

    return WindowScaffold(
      title: Text('Color'),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}

class const ColorInputWindowBody({
  super.key,
  required final ReadonlySignal<ColorDataPartial?> value,
  required final ValueChanged<ColorDataPartial>? onChanged,
  required final InputSessionCallbacks? sessionCallbacks,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final color = useComputedValue(() => value());

    return Column(
      spacing: 8.0,
      children: [
        if (color is HsvColorDataPartial) ...[
          AspectRatio(
            aspectRatio: 1.0,
            child: _HSVSquare(
              value: color,
              onChanged: onChanged,
              sessionCallbacks: sessionCallbacks,
            ),
          ),
        ],
        Row(
          children: [
            IconButton(
              onTap: () {},
              child: Icons.eyedropper(),
            ),
            // const SizedBox(width: 4.0),
            // DropdownButton(),
          ],
        ),
        if (color is HsvColorDataPartial) ...[
          _HueSlider(
            value: color.h,
            onChanged: (h) => onChanged?.call(.hsv(h: h)),
            sessionCallbacks: sessionCallbacks,
          ),
          _SaturationSlider(
            value: color.s,
            onChanged: (s) => onChanged?.call(.hsv(s: s)),
            sessionCallbacks: sessionCallbacks,
          ),
          _ValueSlider(
            value: color.v,
            onChanged: (v) => onChanged?.call(.hsv(v: v)),
            sessionCallbacks: sessionCallbacks,
          ),
          _AlphaSlider(
            value: color.alpha,
            onChanged: (a) => onChanged?.call(.hsv(alpha: a)),
            sessionCallbacks: sessionCallbacks,
          ),
        ],
        ColorInputField(
          value: value,
          onChanged: onChanged,
          sessionCallbacks: sessionCallbacks,
        ),
      ],
    );
  }
}
