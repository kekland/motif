part of '../color_input_window.dart';

class _HSVSquare extends HookWidget {
  const _HSVSquare({
    super.key,
    required this.value,
    this.onChanged,
    this.onStartChanging,
    this.onEndChanging,
  });

  final HsvColorDataPartial? value;
  final ValueChanged<ColorDataPartial>? onChanged;
  final VoidCallback? onStartChanging;
  final VoidCallback? onEndChanging;

  @override
  Widget build(BuildContext context) {
    final panHue = useRef<double?>(null);
    var hue = value?.h;
    var x = value?.s;
    var y = value?.v;

    if (hue?.isNaN == true) hue = null;
    if (x?.isNaN == true) x = null;
    if (y?.isNaN == true) y = null;

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
      if (onChanged != null) onChanged!(.hsv(s: newS, v: newV));
    }

    return GestureDetector(
      onPanStart: (_) {
        onStartChanging?.call();
        panHue.value = hue;
      },
      onTapUp: (details) => _updateSv(details.localPosition),
      onPanUpdate: (details) {
        final size = context.size!;

        // On trackpad scroll, update the hue. If it's a mouse, update the s/v.
        if (details.kind == .trackpad) {
          final delta = details.delta.dx / size.width;
          final newHue = ((panHue.value! + delta * 360.0) % 360.0 + 360.0) % 360.0;
          if (onChanged != null) onChanged!(.hsv(h: newHue));
          panHue.value = newHue;
        } else {
          _updateSv(details.localPosition);
        }
      },
      onPanEnd: (_) => onEndChanging?.call(),
      onPanCancel: () => onEndChanging?.call(),
      child: Stack(
        clipBehavior: .none,
        children: [
          Surface(
            borderRadius: .circular(4),
            borderSide: .new(color: context.colors.divider),
            child: Stack(
              children: [
                // Hue layer
                Positioned.fill(
                  child: ColoredBox(
                    color: HSVColor.fromAHSV(1.0, hue ?? 0.0, 1.0, 1.0).toColor(),
                  ),
                ),

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
          if (x != null || y != null)
            Align(
              alignment: FractionalOffset(x ?? 0.0, 1.0 - (y ?? 0.0)),
              child: _DragHandle(
                innerColor: HsvColorData(h: hue ?? 0.0, s: x ?? 1.0, v: y ?? 1.0).toUiColor(),
                expandWidth: x == null,
                expandHeight: y == null,
              ),
            ),
        ],
      ),
    );
  }
}
