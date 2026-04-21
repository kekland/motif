part of '../color_picker_window.dart';

class _Slider extends HookWidget {
  const _Slider({
    super.key,
    required this.stopsGenerator,
    required this.onChanged,
    this.value,
    this.color,
    this.leading,
    this.stops = 16,
    this.background,
    this.isCircular = false,
  });

  final int stops;
  final Color Function(double t) stopsGenerator;
  final ValueChanged<double> onChanged;
  final double? value;
  final Color? color;
  final Widget? leading;
  final Widget? background;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    final dragValue = useRef<double?>(null);
    final colors = List.generate(stops, (i) => stopsGenerator(i / (stops - 1)));

    final body = Stack(
      clipBehavior: .none,
      children: [
        if (background != null)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: .circular(8.0),
              child: background!,
            ),
          ),
        Container(
          width: double.infinity,
          height: 16.0,
          decoration: BoxDecoration(
            borderRadius: .circular(8.0),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: colors,
            ),
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: .circular(8.0),
            border: .all(color: context.colors.divider),
          ),
        ),
        if (value != null && !value!.isNaN)
          Align(
            alignment: FractionalOffset(value!, 0.0),
            child: _DragHandle(innerColor: color?.withValues(alpha: 1.0)),
          ),
      ],
    );

    double _clamp(double v) {
      if (isCircular) return (v % 1.0 + 1.0) % 1.0;
      return v.clamp(0.0, 1.0);
    }

    return Row(
      children: [
        if (leading != null) ...[
          SizedBox.square(
            dimension: 16.0,
            child: DefaultForegroundStyle(
              textStyle: context.typography.caption3.tertiary,
              iconSize: 16.0,
              child: leading!,
            ),
          ),
          const SizedBox(width: 4.0),
        ],
        Expanded(
          child: Builder(
            builder: (context) {
              return GestureDetector(
                onTapUp: (details) {
                  final position = details.localPosition;
                  final size = context.size!;
                  onChanged(_clamp(position.dx / size.width));
                },
                onPanUpdate: (details) {
                  final position = details.localPosition;
                  final size = context.size!;
                  onChanged(_clamp(position.dx / size.width));
                },
                onHorizontalDragStart: (details) {
                  dragValue.value = value;
                },
                onHorizontalDragUpdate: (details) {
                  final size = context.size!;
                  late double newValue;
                  if (details.kind == .trackpad) {
                    final delta = details.delta.dx / size.width;
                    newValue = dragValue.value! + delta;
                  } else {
                    newValue = details.localPosition.dx / size.width;
                  }

                  newValue = _clamp(newValue);

                  onChanged(newValue);
                  dragValue.value = newValue;
                },
                child: body,
              );
            },
          ),
        ),
        if (value != null) ...[
          const SizedBox(width: 8.0),
          Checkbox(
            value: !value!.isNaN,
            onChanged: (v) => onChanged(v ? 0.0 : .nan),
          ),
        ],
      ],
    );
  }
}
