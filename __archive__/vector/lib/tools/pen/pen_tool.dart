import '../../imports.dart';

export 'activities/create_vertex_activity.dart';

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
          final localPosition = controller.render.globalToLocal(globalPosition);
          final hitTest = controller.hitTestCell(globalPosition);

          hoveredCell.value = hitTest?.cell;
          transientEdge.value?.end = localPosition.vec2;
        },
        child: DragActivityDetector(
          behavior: .translucent,
          activityFactory: () => CreateVertexActivity(
            controller: controller,
            existingTransientEdge: transientEdge.value,
            onTransientEdgeCreated: (v) => transientEdge.value = v,
            onTransientEdgeCompleted: (v) {
              transientEdge.value = null;
            },
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
