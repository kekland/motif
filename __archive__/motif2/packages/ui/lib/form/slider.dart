import 'dart:math' as math;

import 'package:ui/ui.dart';
import 'package:stack_mouse_cursor/stack_mouse_cursor.dart';

class Slider extends StatelessWidget {
  const Slider({
    super.key,
    this.label,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.logScale = false,
  });

  final Widget? label;
  final double min;
  final double max;
  final double value;
  final bool logScale;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    // Convert from value to 0..1 range for progress
    double _valueToLinear(double value) {
      if (logScale) {
        final logMin = math.log(min + 1);
        final logMax = math.log(max + 1);
        final logValue = math.log(value + 1);
        return (logValue - logMin) / (logMax - logMin);
      } else {
        return (value - min) / (max - min);
      }
    }

    double _linearToValue(double linearValue) {
      if (logScale) {
        final logMin = math.log(min + 1);
        final logMax = math.log(max + 1);
        final logValue = linearValue * (logMax - logMin) + logMin;
        return math.exp(logValue) - 1;
      } else {
        return linearValue * (max - min) + min;
      }
    }

    void _updateValue(Offset localPosition) {
      final width = context.size!.width;
      final newValue = _linearToValue(localPosition.dx / width);
      final clampedValue = newValue.clamp(min, max);

      onChanged?.call(clampedValue);
    }

    return Column(
      mainAxisSize: .min,
      children: [
        Row(
          children: [
            Expanded(
              child: DefaultForegroundStyle(
                textStyle: context.typography.body.tertiary,
                maxLines: 1,
                overflow: .ellipsis,
                child: label ?? const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 4.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.divider, width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              child: Text(
                value.toStringAsFixed(2),
                style: context.typography.body.tertiary.tabular,
              ),
            ),
          ],
        ),
        MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: GestureDetector(
            onTapDown: (details) => _updateValue(details.localPosition),
            onHorizontalDragStart: (_) => ExclusiveMouseCursor.instance.set(SystemMouseCursors.resizeLeftRight),
            onHorizontalDragEnd: (_) => ExclusiveMouseCursor.instance.release(),
            onHorizontalDragUpdate: (details) => _updateValue(details.localPosition),
            child: SizedBox(
              width: double.infinity,
              height: 24.0,
              child: CustomPaint(
                painter: _SliderPainter(
                  trackColor: context.colors.divider,
                  thumbColor: context.colors.display.secondary,
                  progress: _valueToLinear(value),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4.0),
      ],
    );
  }
}

class _SliderPainter extends CustomPainter {
  _SliderPainter({
    super.repaint,
    required this.trackColor,
    required this.thumbColor,
    required this.progress,
  });

  final Color trackColor;
  final Color thumbColor;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = trackColor
      ..style = .stroke
      ..strokeCap = .round
      ..strokeWidth = 4.0;

    final width = size.width;

    final leftX = (size.width * progress - 8.0).clamp(0.0, size.width);
    final rightX = (size.width * progress + 8.0).clamp(0.0, size.width);

    canvas.drawLine(
      Offset(0.0, size.height / 2),
      Offset(leftX, size.height / 2),
      paint,
    );

    canvas.drawLine(
      Offset(rightX, size.height / 2),
      Offset(width, size.height / 2),
      paint,
    );

    final thumbPaint = Paint()
      ..color = thumbColor
      ..style = .fill;

    final thumbRect = Rect.fromCenter(
      center: Offset(size.width * progress, size.height / 2),
      width: 4.0,
      height: 16.0,
    );

    final thumbRRect = RRect.fromRectAndRadius(thumbRect, Radius.circular(2.0));
    canvas.drawRRect(thumbRRect, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
