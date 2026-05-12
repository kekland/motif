import 'package:vector/imports.dart';
import 'package:vector/tools/pen/activities/pen_activities.dart';
import 'package:vgc/debug/debug_draw.dart';
import 'package:vgc/vgc.dart';

class PenTool extends Tool {
  const PenTool();

  @override
  String get key => 'pen';

  @override
  LogicalKeySet get shortcut => LogicalKeySet(.keyP);

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
    final transientEdge = useState<TransientEdge?>(null);
    final hoveredCell = useState<Cell?>(null);

    useOnDispose(() {
      final edge = transientEdge.value;
      if (edge != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.transientEdges.remove(edge);
        });
      }
    });

    final createVertexRecognizer = useDragActivityRecognizer(
      () => CreateVertexActivity(
        controller: controller,
        existingTransientEdge: transientEdge.value,
        onTransientEdgeCreated: (v) => transientEdge.value = v,
        onTransientEdgeCompleted: (v) {
          transientEdge.value = null;
        },
      ),
    );

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: switch (hoveredCell.value) {
        Vertex _ => Cursors.toolPenVertex,
        Edge _ => Cursors.toolPenEdge,
        _ => Cursors.precise,
      },
      child: Listener(
        behavior: .translucent,
        onPointerHover: (e) {
          final globalPosition = e.position;
          final localPosition = controller.globalToArtworkLocal(globalPosition);
          hoveredCell.value = controller.hitTestCell(globalPosition)?.cell;

          if (transientEdge.value != null) {
            transientEdge.value!.end = localPosition.asVector2();
          }
        },
        onPointerDown: (e) {
          createVertexRecognizer.addPointer(e);
        },
        child: GestureDetector(
          behavior: .translucent,
          child: Stack(
            children: [
              // if (hoveredCell.value != null)
              //   Positioned.fill(
              //     child: Transform(
              //       transform: info.childPaintTransform,
              //       child: CustomPaint(
              //         painter: _HoverPainter(
              //           cell: hoveredCell.value!,
              //           color: context.colors.accent.primary,
              //         ),
              //       ),
              //     ),
              //   ),
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
