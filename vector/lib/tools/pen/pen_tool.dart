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
          final v2 = controller.complex.createVertex(v.endPosition!.asVector2());
          controller.complex.createOpenEdge(
            v.start,
            v2,
            c1: v.c1Position?.asVector2(),
            c2: v.c2Position?.asVector2(),
          );
          controller.transientEdges.remove(v);

          final c2 = v.c2Position?.asVector2();
          final newC2 = c2 != null ? v2.position + (v2.position - c2) : null;
          transientEdge.value = controller.transientEdges.create(v2, c1Position: newC2?.asOffset());
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
            transientEdge.value!.endPosition = localPosition;
          }
        },
        onPointerDown: (e) {
          final hitTest = controller.hitTestCell(e.position);

          if (hitTest == null) {
            createVertexRecognizer.addPointer(e);
          }
        },
        child: GestureDetector(
          behavior: .translucent,
          onTapUp: (details) {
            final position = controller.globalToArtworkLocal(details.globalPosition);
            final hitTest = controller.hitTestCell(details.globalPosition);

            if (hitTest == null) {
              final vertex = controller.complex.createVertex(position.asVector2());

              final edge = transientEdge.value;
              if (edge != null) {
                // Commit a new edge
                controller.complex.createOpenEdge(
                  edge.start,
                  vertex,
                  c1: edge.c1Position?.asVector2(),
                  c2: edge.c2Position?.asVector2(),
                );

                controller.transientEdges.remove(edge);
              }

              transientEdge.value = controller.transientEdges.create(vertex);
            } else if (hitTest.cell is Vertex) {
              final vertex = hitTest.cell as Vertex;

              final edge = transientEdge.value;
              if (edge != null) {
                // Commit a new edge
                controller.complex.createOpenEdge(
                  edge.start,
                  vertex,
                  c1: edge.c1Position?.asVector2(),
                  c2: edge.c2Position?.asVector2(),
                );

                controller.transientEdges.remove(edge);
              }

              transientEdge.value = controller.transientEdges.create(vertex);
            } else if (hitTest.cell is Edge) {
              final hitEdge = hitTest.cell as Edge;
              final t = (hitTest as EdgeHitTestEntry).t;

              final splitResult = controller.complex.splitEdge(hitEdge, t);
              final edge = transientEdge.value;

              if (edge != null) {
                controller.complex.createOpenEdge(
                  edge.start,
                  splitResult.vertex,
                  c1: edge.c1Position?.asVector2(),
                  c2: edge.c2Position?.asVector2(),
                );

                controller.transientEdges.remove(edge);
              } else {
                transientEdge.value = controller.transientEdges.create(splitResult.vertex);
              }
            }
          },
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
