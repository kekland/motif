import 'package:editor/imports.dart';

import 'transient_edges_widget.dart';

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
    final editor = Editor.watch(context);
    final transientEdge = useState<TransientEdge?>(null);
    final hoveredCell = useState<Cell?>(null);

    useOnDispose(() {
      final edge = transientEdge.value;
      if (edge != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => edge.remove());
      }
    });

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: switch (hoveredCell.value) {
        Vertex() => Cursors.toolPenVertex,
        Edge() => Cursors.toolPenEdge,
        _ => Cursors.precise,
      },
      child: Listener(
        behavior: .translucent,
        onPointerHover: (e) {
          final result = editor.hitTestScene(e.position.vec2);
          hoveredCell.value = result.cell?.node;
        },
        child: DragActivityDetector(
          behavior: .translucent,
          activityFactory: (_) => CreateVertexActivity(
            editor: editor,
            existingTransientEdge: transientEdge.value,
            onTransientEdgeCreated: (v) => transientEdge.value = v,
            onTransientEdgeCompleted: (v) {
              transientEdge.value = null;
            },
          ),
          child: TransientEdgesWidget(
            transform: info.childPaintTransform,
          ),
        ),
      ),
    );
  }
}
