import 'package:vector/imports.dart';
import 'package:vgc/debug/debug_draw.dart';
import 'package:vgc/vgc.dart';

class PenTool extends Tool {
  const PenTool();

  @override
  String get key => 'pen';

  @override
  Widget buildIcon(BuildContext context) => Icons.pen();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _PenToolOverlay(info: info);
}

class _PenToolOverlay extends HookWidget {
  const _PenToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);
    final hoveredCell = useState<Cell?>(null);

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: SystemMouseCursors.precise,
      child: Listener(
        behavior: .translucent,
        onPointerHover: (e) {
          final globalPosition = e.position;
          final localPosition = controller.globalToArtworkLocal(globalPosition);

          final scale = info.childPaintTransform.getMaxScaleOnAxis();
          final tolerance = HitTestTolerance.defaultTolerance.scaled((1.0 / scale) * 2.0);

          final hits = controller.complex.hitTest(localPosition.asVector2(), tolerance: tolerance);
          if (hits.isNotEmpty) {
            hoveredCell.value = hits.first.cell;
          } else {
            hoveredCell.value = null;
          }
        },
        onPointerDown: (e) {},
        child: GestureDetector(
          behavior: .translucent,
          onTapUp: (details) {},
          child: Stack(
            children: [
              if (hoveredCell.value != null)
                Positioned.fill(
                  child: Transform(
                    transform: info.childPaintTransform,
                    child: CustomPaint(
                      painter: _HoverPainter(
                        cell: hoveredCell.value!,
                        color: context.colors.accent.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoverPainter extends CustomPainter {
  const _HoverPainter({required this.cell, required this.color});

  final Color color;
  final Cell cell;

  @override
  void paint(Canvas canvas, Size size) {
    drawDebugCell(canvas, cell, color: color);
  }

  @override
  bool shouldRepaint(covariant _HoverPainter oldDelegate) {
    return oldDelegate.cell != cell;
  }
}
