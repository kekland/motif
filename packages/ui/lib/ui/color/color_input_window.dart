import 'package:color/color.dart';
import 'package:ui/ui.dart';

part 'components/drag_handle.dart';
part 'components/hsv_square.dart';
part 'components/slider.dart';
part 'components/sliders.dart';

class ColorInputWindow extends HookWidget {
  const new({super.key, required this.value, this.onChanged});

  final ReadonlySignal<ColorData?> value;
  final ValueChanged<ColorData>? onChanged;

  static WindowEntry createEntry(
    BuildContext context, {
    required ReadonlySignal<ColorData?> value,
    ValueChanged<ColorData>? onChanged,
  }) => WindowEntry.withContextAnchor(
    context,
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
          AspectRatio(
            aspectRatio: 1.0,
            child: _HSVSquare(
              value: color,
              onChanged: onChanged,
            ),
          ),
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
          _HueSlider(
            value: color,
            onChanged: onChanged,
          ),
          _SaturationSlider(
            value: color,
            onChanged: onChanged,
          ),
          _ValueSlider(
            value: color,
            onChanged: onChanged,
          ),
          _AlphaSlider(
            value: color,
            onChanged: onChanged,
          ),
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
