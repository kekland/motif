import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:color/color.dart';
import 'package:ui/ui.dart';

part 'color_picker/drag_handle.dart';
part 'color_picker/hsv_square.dart';
part 'color_picker/slider.dart';
part 'color_picker/sliders.dart';
part 'color_picker/utils.dart';

class ColorPickerWindow extends StatelessWidget {
  const ColorPickerWindow({
    super.key,
    required this.value,
    this.onChanged,
  });

  final ValueListenable<ColorData> value;
  final ValueChanged<ColorData>? onChanged;

  static WindowEntry createEntry({
    required ValueListenable<ColorData> value,
    ValueChanged<ColorData>? onChanged,
    required VoidCallback onRemoved,
  }) => WindowEntry(
    builder: (_) => ColorPickerWindow(value: value, onChanged: onChanged),
    onRemoved: onRemoved,
  );

  @override
  Widget build(BuildContext context) {
    return WindowScaffold(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: value,
          builder: (context, color, _) {
            return SizedBox(
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
          },
        ),
      ),
    );
  }
}
