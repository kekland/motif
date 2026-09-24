import 'package:color/color_flutter.dart';
import 'package:ui/ui.dart';

part 'components/drag_handle.dart';
part 'components/hsv_square.dart';
part 'components/slider.dart';
part 'components/sliders.dart';

class ColorInputWindow extends HookWidget {
  const new({
    super.key,
    required this.value,
    this.onChanged,
    this.onStartChanging,
    this.onEndChanging,
  });

  final ReadonlySignal<ColorDataPartial> value;
  final VoidCallback? onStartChanging;
  final VoidCallback? onEndChanging;
  final ValueChanged<ColorDataPartial>? onChanged;

  @override
  Widget build(BuildContext context) {
    final color = useComputedValue(() => value.value);

    Widget child = SizedBox(
      width: 240.0,
      child: Column(
        spacing: 8.0,
        children: [
          if (color is HsvColorDataPartial) ...[
            AspectRatio(
              aspectRatio: 1.0,
              child: _HSVSquare(
                value: color,
                onChanged: onChanged,
                onStartChanging: onStartChanging,
                onEndChanging: onEndChanging,
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
              onStartChanging: onStartChanging,
              onEndChanging: onEndChanging,
            ),
            _SaturationSlider(
              value: color.s,
              onChanged: (s) => onChanged?.call(.hsv(s: s)),
              onStartChanging: onStartChanging,
              onEndChanging: onEndChanging,
            ),
            _ValueSlider(
              value: color.v,
              onChanged: (v) => onChanged?.call(.hsv(v: v)),
              onStartChanging: onStartChanging,
              onEndChanging: onEndChanging,
            ),
            _AlphaSlider(
              value: color.alpha,
              onChanged: (a) => onChanged?.call(.hsv(alpha: a)),
              onStartChanging: onStartChanging,
              onEndChanging: onEndChanging,
            ),
          ],
          ColorField(
            value: value,
            onChanged: onChanged,
            onStartChanging: onStartChanging,
            onEndChanging: onEndChanging,
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
