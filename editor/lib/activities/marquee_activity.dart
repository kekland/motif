import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

typedef MarqueeValue = (Rect, HitTestRectMode);

class MarqueeActivity extends DragActivity {
  MarqueeActivity({
    required this.editor,
    this.onLocalRectChanged,
    this.onGlobalRectChanged,
    super.onStart,
    super.onUpdate,
    super.onEnd,
    super.onCancel,
  });

  final Editor editor;
  final ValueChanged<MarqueeValue?>? onLocalRectChanged;
  final ValueChanged<MarqueeValue?>? onGlobalRectChanged;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    onLocalRectChanged?.call((.fromPoints(details.localPosition, details.localPosition), .contain));
    onGlobalRectChanged?.call((.fromPoints(details.globalPosition, details.globalPosition), .contain));
    editor.selection.clear();
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final start = startDetails.localPosition;
    final end = details.localPosition;
    late final HitTestRectMode mode;
    if (end.dx > start.dx) {
      mode = .contain;
    } else {
      mode = .intersect;
    }

    final localRect = Rect.fromPoints(start, end);
    final globalRect = Rect.fromPoints(startDetails.globalPosition, details.globalPosition);
    onLocalRectChanged?.call((localRect, mode));
    onGlobalRectChanged?.call((globalRect, mode));

    super.onUpdate(details);
  }

  @override
  void onEnd(DragEndDetails details) {
    onLocalRectChanged?.call(null);
    onGlobalRectChanged?.call(null);
    super.onEnd(details);
  }

  @override
  void onCancel() {
    onLocalRectChanged?.call(null);
    onGlobalRectChanged?.call(null);
    super.onCancel();
  }
}

class MarqueeDetector extends HookWidget {
  const MarqueeDetector({
    super.key,
    this.activityFactory,
    this.onStart,
    this.onEnd,
    this.onCancel,
    this.onGlobalRectChanged,
    this.color,
  });

  final MarqueeActivity Function(void Function(MarqueeValue?) onLocalRectChanged)? activityFactory;
  final VoidCallback? onStart;
  final VoidCallback? onEnd;
  final VoidCallback? onCancel;
  final ValueChanged<MarqueeValue?>? onGlobalRectChanged;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final editor = Editor.watch(context);
    final state = useState<MarqueeValue?>(null);

    void onLocalRectChanged(MarqueeValue? value) {
      state.value = value;
    }

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: Cursors.toolMarquee,
      child: DragActivityDetector(
        behavior: .translucent,
        activityFactory: (_) {
          if (activityFactory != null) return activityFactory!(onLocalRectChanged);
          return MarqueeActivity(
            editor: editor,
            onLocalRectChanged: onLocalRectChanged,
            onGlobalRectChanged: onGlobalRectChanged,
            onStart: onStart,
            onEnd: onEnd,
            onCancel: onCancel,
          );
        },
        child: Stack(
          children: [
            MarqueeOverlay(
              rect: state.value?.$1,
              mode: state.value?.$2,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

class MarqueeOverlay extends StatelessWidget {
  const MarqueeOverlay({
    super.key,
    this.rect,
    this.mode,
    this.color,
  });

  final Rect? rect;
  final HitTestRectMode? mode;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (rect == null) return const SizedBox.shrink();
    final color = this.color ?? context.colors.selection.primary;

    return Positioned.fromRect(
      rect: rect!,
      child: CustomPaint(
        painter: _MarqueeOverlayPainter(color: color, mode: mode!),
      ),
    );
  }
}

class _MarqueeOverlayPainter extends CustomPainter {
  _MarqueeOverlayPainter({
    required this.color,
    required this.mode,
  });

  final Color color;
  final HitTestRectMode mode;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withScaledAlpha(0.2)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = .round
      ..strokeWidth = 2.0;

    final path = Path()..addRect(Offset.zero & size);
    canvas.drawPath(path, paint);

    if (mode == .intersect) {
      canvas.drawDashedPath(path, paint: borderPaint, dashLength: 8.0, gapLength: 4.0);
    } else {
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(_MarqueeOverlayPainter oldDelegate) => oldDelegate.color != color || oldDelegate.mode != mode;
}
