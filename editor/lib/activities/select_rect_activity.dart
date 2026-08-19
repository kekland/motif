import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

class SelectRectActivity extends DragActivity {
  SelectRectActivity({
    required this.editor,
    required this.onRectChanged,
  });

  final Editor editor;
  final ValueChanged<(Rect, HitTestRectMode)?> onRectChanged;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    onRectChanged((.fromPoints(details.localPosition, details.localPosition), .contain));
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
    onRectChanged((localRect, mode));

    final globalRect = Rect.fromPoints(startDetails.globalPosition, details.globalPosition);
    final hitTestResult = editor.hitTestRect(globalRect, mode: mode);
    final refs = hitTestResult.refs;
    editor.selection.setMultiple(refs);

    super.onUpdate(details);
  }

  @override
  void onEnd(DragEndDetails? details) {
    onRectChanged(null);
    super.onEnd(details);
  }
}

class SelectRectDetector extends HookWidget {
  const SelectRectDetector({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = Editor.watch(context);
    final state = useState<(Rect, HitTestRectMode)?>(null);

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: Cursors.toolMarquee,
      child: DragActivityDetector(
        behavior: .translucent,
        activityFactory: (_) => SelectRectActivity(
          editor: editor,
          onRectChanged: (r) => state.value = r,
        ),
        child: Stack(
          children: [SelectRectOverlay(rect: state.value?.$1, mode: state.value?.$2)],
        ),
      ),
    );
  }
}

class SelectRectOverlay extends StatelessWidget {
  const SelectRectOverlay({super.key, this.rect, this.mode});

  final Rect? rect;
  final HitTestRectMode? mode;

  @override
  Widget build(BuildContext context) {
    if (rect == null) return const SizedBox.shrink();
    final color = context.colors.accent.primary;

    return Positioned.fromRect(
      rect: rect!,
      child: CustomPaint(
        painter: _SelectRectOverlayPainter(color: color, mode: mode!),
      ),
    );
  }
}

class _SelectRectOverlayPainter extends CustomPainter {
  _SelectRectOverlayPainter({
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
  bool shouldRepaint(_SelectRectOverlayPainter oldDelegate) => oldDelegate.color != color || oldDelegate.mode != mode;
}
