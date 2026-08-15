part of '../color_picker_window.dart';

class _HSVSquare extends HookWidget {
  const _HSVSquare({
    super.key,
    required this.value,
    this.onChanged,
  });

  final ColorData value;
  final ValueChanged<ColorData>? onChanged;

  @override
  Widget build(BuildContext context) {
    final panHue = useRef<double?>(null);
    final hsvColor = value as HsvColorData;
    var hue = hsvColor.h;
    var x = hsvColor.s;
    var y = hsvColor.v;

    if (hue.isNaN) hue = 0.0;
    if (x.isNaN) x = 0.0;
    if (y.isNaN) y = 0.0;

    void _updateSv(Offset localPosition) {
      final totalSize = context.size!;
      const dragHandleSize = _DragHandle.size;
      final adjustedSize = Size(
        totalSize.width - dragHandleSize,
        totalSize.height - dragHandleSize,
      );

      final position = localPosition - const Offset(dragHandleSize, dragHandleSize) / 2;
      final newS = clampDouble(position.dx / adjustedSize.width, 0.0, 1.0);
      final newV = clampDouble(1.0 - position.dy / adjustedSize.height, 0.0, 1.0);
      final newColor = hsvColor.copyWith(s: newS, v: newV);
      if (onChanged != null) onChanged!(newColor);
    }

    return GestureDetector(
      onPanStart: (_) => panHue.value = hue,
      onTapUp: (details) => _updateSv(details.localPosition),
      onPanUpdate: (details) {
        final size = context.size!;

        // On trackpad scroll, update the hue. If it's a mouse, update the s/v.
        if (details.kind == .trackpad) {
          final delta = details.delta.dx / size.width;
          final newHue = ((panHue.value! + delta * 360.0) % 360.0 + 360.0) % 360.0;
          if (onChanged != null) onChanged!(hsvColor.copyWith(h: newHue));
          panHue.value = newHue;
        } else {
          _updateSv(details.localPosition);
        }
      },
      child: Stack(
        clipBehavior: .none,
        children: [
          Surface(
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
          Align(
            alignment: FractionalOffset(x, 1.0 - y),
            child: _DragHandle(innerColor: value.toUiColor().withValues(alpha: 1.0)),
          ),
        ],
      ),
    );
  }
}
