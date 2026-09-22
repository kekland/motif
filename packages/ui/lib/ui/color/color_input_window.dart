import 'package:color/color_flutter.dart';
import 'package:ui/ui.dart';

part 'components/drag_handle.dart';
part 'components/hsv_square.dart';
part 'components/slider.dart';
part 'components/sliders.dart';

class ColorInputWindow extends HookWidget {
  const new({super.key, required this.value, this.onChanged});

  final ReadonlySignal<ColorDataPartial> value;
  final ValueChanged<ColorDataPartial>? onChanged;

  static WindowEntry createEntry(
    BuildContext context, {
    required ReadonlySignal<ColorDataPartial> value,
    ValueChanged<ColorDataPartial>? onChanged,
  }) => WindowEntry.withContextAnchor(
    context,
    isModal: true,
    builder: (_) => ColorInputWindow(value: value, onChanged: onChanged),
  );

  @override
  Widget build(BuildContext context) {
    final color = useComputedValue(() => value.value);

    Widget child = SizedBox(
      width: 192.0,
      child: Column(
        spacing: 8.0,
        children: [
          if (color is HsvColorDataPartial) ...[
            AspectRatio(
              aspectRatio: 1.0,
              child: _HSVSquare(
                value: color,
                onChanged: onChanged,
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
            ),
            _SaturationSlider(
              value: color.s,
              onChanged: (s) => onChanged?.call(.hsv(s: s)),
            ),
            _ValueSlider(
              value: color.v,
              onChanged: (v) => onChanged?.call(.hsv(v: v)),
            ),
            _AlphaSlider(
              value: color.alpha,
              onChanged: (a) => onChanged?.call(.hsv(alpha: a)),
            ),
          ],
          ColorField(
            value: value,
            onChanged: onChanged,
          ),
        ],
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
