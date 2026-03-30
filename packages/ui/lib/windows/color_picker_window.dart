import 'package:flutter/foundation.dart';
import 'package:ui/ui.dart';
import 'package:stack_window_manager/stack_window_manager.dart';

class ColorPickerWindow extends StatelessWidget {
  const ColorPickerWindow({
    super.key,
    required this.value,
    this.onChanged,
  });

  final ValueListenable<Color> value;
  final ValueChanged<Color>? onChanged;

  static WindowEntry createEntry({
    required ValueListenable<Color> value,
    ValueChanged<Color>? onChanged,
  }) => WindowEntry(
    builder: (_) => ColorPickerWindow(value: value, onChanged: onChanged),
  );

  @override
  Widget build(BuildContext context) {
    return WindowScaffold(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: value,
          builder: (context, color, _) => SizedBox(
            width: 192.0,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: _HSVSquare(
                    value: color,
                    onChanged: onChanged,
                  ),
                ),
                const SizedBox(height: 8.0),
                _HueSlider(
                  value: color,
                  onChanged: onChanged,
                ),
                const SizedBox(height: 8.0),
                _OpacitySlider(
                  value: color,
                  onChanged: onChanged,
                ),
                const SizedBox(height: 8.0),
                ColorInputField(
                  value: color,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HSVSquare extends StatelessWidget {
  const _HSVSquare({
    super.key,
    required this.value,
    this.onChanged,
  });

  final Color value;
  final ValueChanged<Color>? onChanged;

  @override
  Widget build(BuildContext context) {
    final hsvColor = HSVColor.fromColor(value);
    final hue = hsvColor.hue;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final x = (hsvColor.saturation) * size.width;
        final y = (1.0 - hsvColor.value) * size.height;

        return GestureDetector(
          onPanUpdate: (details) {
            final position = details.localPosition;
            final newHsvColor = HSVColor.fromAHSV(
              hsvColor.alpha,
              hue,
              clampDouble(position.dx / size.width, 0.0, 1.0),
              clampDouble(1.0 - position.dy / size.height, 0.0, 1.0),
            );

            if (onChanged != null) onChanged!(newHsvColor.toColor());
          },
          child: Stack(
            clipBehavior: .none,
            children: [
              Surface(
                width: size.width,
                height: size.height,
                borderRadius: .circular(4),
                borderSide: .new(color: context.colors.divider),
                child: Stack(
                  children: [
                    // Hue layer
                    Positioned.fill(child: ColoredBox(color: HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor())),

                    // Saturation layer
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.white, Colors.white.withScaledAlpha(0.0)],
                          ),
                        ),
                      ),
                    ),

                    // Value layer
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black, Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Drag handle
              Positioned(
                left: x - _DragHandle.size / 2.0,
                top: y - _DragHandle.size / 2.0,
                child: _DragHandle(innerColor: value.withAlpha(255)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({super.key, this.innerColor});
  static const size = 16.0;

  final Color? innerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: context.shadows.small,
      ),
      child: Center(
        child: Container(
          width: size / 2,
          height: size / 2,
          decoration: BoxDecoration(shape: BoxShape.circle, color: innerColor),
        ),
      ),
    );
  }
}

class _HueSlider extends StatelessWidget {
  const _HueSlider({
    super.key,
    required this.value,
    this.onChanged,
  });

  final Color value;
  final ValueChanged<Color>? onChanged;

  @override
  Widget build(BuildContext context) {
    const colors = <Color>[
      .new(0xFFFF0000),
      .new(0xFFFFFF00),
      .new(0xFF00FF00),
      .new(0xFF00FFFF),
      .new(0xFF0000FF),
      .new(0xFFFF00FF),
      .new(0xFFFF0000),
    ];

    final hsvColor = HSVColor.fromColor(value);
    final x = hsvColor.hue / 360.0;

    return GestureDetector(
      onPanUpdate: (details) {
        final position = details.localPosition;
        final size = context.size!;

        final newHsvColor = HSVColor.fromAHSV(
          hsvColor.alpha,
          clampDouble(position.dx / size.width, 0.0, 1.0) * 360.0,
          hsvColor.saturation,
          hsvColor.value,
        );

        if (onChanged != null) onChanged!(newHsvColor.toColor());
      },
      child: Stack(
        clipBehavior: .none,
        children: [
          Container(
            width: double.infinity,
            height: 16.0,
            decoration: BoxDecoration(
              borderRadius: .circular(4.0),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: colors,
              ),
            ),
            foregroundDecoration: BoxDecoration(
              borderRadius: .circular(4.0),
              border: .all(color: context.colors.divider),
            ),
          ),
          Align(
            alignment: FractionalOffset(x, 0.0),
            child: Transform.translate(
              offset: Offset(-_DragHandle.size / 2.0, 0.0),
              child: _DragHandle(innerColor: value.withAlpha(255)),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpacitySlider extends StatelessWidget {
  _OpacitySlider({super.key, required this.value, this.onChanged});

  final Color value;
  final ValueChanged<Color>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = <Color>[
      value.withAlpha(0),
      value.withAlpha(255),
    ];

    final transparencyColors = switch (context.brightness) {
      .light => const (Color(0xFFCCCCCC), Color(0xFFFFFFFF)),
      .dark => const (Color(0xFF333333), Color(0xFF000000)),
    };

    final alpha = value.a;

    return GestureDetector(
      behavior: .opaque,
      onPanUpdate: (details) {
        final position = details.localPosition;
        final size = context.size!;

        final newColor = value.withAlpha(((position.dx / size.width).clamp(0.0, 1.0) * 255.0).round());
        if (onChanged != null) onChanged!(newColor);
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 16.0,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: .circular(4.0),
            ),
            foregroundDecoration: BoxDecoration(
              borderRadius: .circular(4.0),
              border: .all(color: context.colors.divider),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: colors,
              ),
            ),
            child: CustomPaint(
              willChange: false,
              isComplex: true,
              painter: _TransparencyPainter(
                tileSize: 4.0,
                grayColor: transparencyColors.$1,
                whiteColor: transparencyColors.$2,
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset(alpha, 0.0),
            child: Transform.translate(
              offset: Offset(-_DragHandle.size / 2.0, 0.0),
              child: _DragHandle(innerColor: value),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransparencyPainter extends CustomPainter {
  _TransparencyPainter({required this.tileSize, required this.grayColor, required this.whiteColor});

  final double tileSize;
  final Color grayColor;
  final Color whiteColor;

  @override
  void paint(Canvas canvas, Size size) {
    final grayPaint = Paint()..color = grayColor;
    final whitePaint = Paint()..color = whiteColor;

    for (var i = 0; i < size.width / tileSize; i++) {
      for (var j = 0; j < size.height / tileSize; j++) {
        final index = i + j;
        final paint = index % 2 == 0 ? grayPaint : whitePaint;

        final x = i * tileSize;
        final y = j * tileSize;
        final rect = Rect.fromLTWH(x, y, tileSize, tileSize);

        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_TransparencyPainter oldDelegate) => tileSize != oldDelegate.tileSize;
}
