import 'package:editor/imports.dart';

class CursorTool extends Tool {
  const CursorTool();

  @override
  String get key => 'cursor';

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
    final editor = Editor.watch(context);
    final hoveredNode = useState<SceneNode?>(null);
    final marqueeRect = useState<(Rect, ObjectHitTestRectMode)?>(null);
    final selection = useListenable(editor.selection);

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: switch (hoveredNode.value) {
        Vertex() => Cursors.toolCursorVertex,
        Edge() => Cursors.toolCursorEdge,
        // RootObject() => Cursors.toolMarquee,
        _ => Cursors.toolCursor,
      },
      child: Listener(
        behavior: .translucent,
        onPointerHover: (e) {
          final result = editor.hitTestScene(e.position);
          hoveredNode.value = result.node!.node;
        },
        child: DragActivityDetector(
          behavior: .translucent,
          activityFactory: (e) {
            final target = editor.hitTestScene(e.position).node!.node;

            if (!selection.isImplicitlySelected(target)) {
              if (target is RootObject) {
                context.invoke(intents.clearSelection());
              } else {
                context.invoke(intents.selectNode(target));
              }
            }

            if (selection.nodes.isNotEmpty) {
              return MoveNodesActivity(
                editor: editor,
                nodes: selection.nodes.toList(),
              );
            } else {
              return SelectRectActivity(
                editor: editor,
                onRectChanged: (v) => marqueeRect.value = v,
              );
            }
          },
          child: Stack(
            children: [
              SelectRectOverlay(rect: marqueeRect.value?.$1, mode: marqueeRect.value?.$2),
              ObjectSelectionOverlay(
                editor: editor,
                selectionGroups: selection.selectionGroups,
                childPaintTransform: info.childPaintTransform,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
