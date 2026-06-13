import 'package:vector/imports.dart';
import 'package:vector/tools/cursor/selection/hover_overlay.dart';
import 'package:vgc/debug/debug_draw.dart';

class CursorTool extends Tool {
  const CursorTool();

  @override
  String get key => 'cursor';

  @override
  LogicalKeySet get shortcut => LogicalKeySet(.keyV);

  @override
  Widget buildIcon(BuildContext context) => Icons.cursor();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _CursorToolOverlay(info: info);
}

class _CursorToolOverlay extends HookWidget {
  const _CursorToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);
    final hoveredCell = useState<Cell?>(null);
    // final shouldUpdateSelectionOnUp = useRef(true);

    List<CellHitTestEntry> _hitTest(Offset globalPosition) {
      final scale = info.childPaintTransform.getMaxScaleOnAxis();
      return controller.hitTestCells(globalPosition, tolerance: .defaultTolerance.scaled(1.0 / scale));
    }

    return Stack(
      children: [
        MouseRegion(
          hitTestBehavior: .translucent,
          cursor: .defer,
          child: Listener(
            behavior: .translucent,
            onPointerHover: (e) {
              final hits = _hitTest(e.position);

              if (hits.isNotEmpty) {
                hoveredCell.value = hits.first.cell;
              } else {
                hoveredCell.value = null;
              }
            },
            // onPointerDown: (e) {
            //   shouldUpdateSelectionOnUp.value = true;
            //   // final hits = _hitTest(e.position);

            //   // if (hits.isNotEmpty) {
            //   //   controller.selection.select(hits.first.hitObject);
            //   // }
            // },
            child: GestureDetector(
              behavior: .translucent,
              onTapUp: (details) {
                final hits = _hitTest(details.globalPosition);
                if (hits.isEmpty) {
                  controller.selection.clear();
                } else {
                  controller.selection.select(hits.first.hitObject);
                }
              },
              child: Stack(
                children: [
                  Transform(
                    transform: info.childPaintTransform,
                    child: HoverOverlayBuilder(
                      controller: controller,
                      hoveredCell: hoveredCell.value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
