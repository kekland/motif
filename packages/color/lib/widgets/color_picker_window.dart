import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:color/color.dart';
import 'package:ui/ui.dart';

part 'color_picker/drag_handle.dart';
part 'color_picker/hsv_square.dart';
part 'color_picker/slider.dart';
part 'color_picker/sliders.dart';
part 'color_picker/utils.dart';

class ColorPickerWindow extends HookWidget {
  const ColorPickerWindow({
    super.key,
    required this.value,
    this.onChanged,
  });

  final ReadonlySignal<ColorData> value;
  final ValueChanged<ColorData>? onChanged;

  static WindowEntry createEntry(
    BuildContext context, {
    required ReadonlySignal<ColorData> value,
    ValueChanged<ColorData>? onChanged,
  }) => WindowEntry.withContextAnchor(
    context,
    builder: (_) => ColorPickerWindow(value: value, onChanged: onChanged),
  );

  @override
  Widget build(BuildContext context) {
    final color = useComputedValue(() => value.value);
    print(color);

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
              const SizedBox(width: 4.0),
              DropdownButton(),
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
          ColorInputField(
            value: color,
            onChanged: onChanged,
          ),
        ],
      ),
    );

    return WindowScaffold(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
