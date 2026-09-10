import 'package:editor/imports.dart';
import 'package:editor/tools/pen/transient_edges_widget.dart';

class PenTool extends Tool {
  const PenTool();

  @override
  String get key => 'pen';

  @override
  Widget buildIcon(BuildContext context) => Icons.pen();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _PenToolOverlay(info: info);

  @override
  LogicalKeySet? get shortcut => .new(.keyP);
}

class _PenToolOverlay extends HookWidget {
  const _PenToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final transientEdge = useState<TransientEdge?>(null);
    final hoveredCell = useState<Ref?>(null);

    useOnDispose(() {
      final edge = transientEdge.value;
      if (edge != null) edge.remove();
    });

    return CallbackShortcuts(
      bindings: {
        SingleActivator(.escape): () {
          transientEdge.value?.remove();
          transientEdge.value = null;
        },
      },
      child: Focus(
        autofocus: true,
        child: MouseRegion(
          hitTestBehavior: .translucent,
          cursor: switch (hoveredCell.value) {
            CellRef(kind: .vertex) => Cursors.toolPenVertex,
            CellRef(kind: .edge) => Cursors.toolPenEdge,
            _ => Cursors.precise,
          },
          child: Listener(
            behavior: .translucent,
            onPointerHover: (e) {
              final result = editor.hitTest(e.position);
              hoveredCell.value = result.top?.ref;

              if (transientEdge.value != null) {
                final edge = transientEdge.value!;
                edge.end = editor.globalToScene(e.position);
              }
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
        ),
      ),
    );
  }
}
