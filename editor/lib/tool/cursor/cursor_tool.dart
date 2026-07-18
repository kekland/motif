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
    final marqueeRect = useState<(Rect, HitTestRectMode)?>(null);
    final shouldUpdateSelectionOnUp = useRef(true);
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
          final result = editor.hitTestScene(e.position.vec2);
          hoveredNode.value = result.node.node;
        },
        child: DragActivityDetector(
          behavior: .translucent,
          activityFactory: (e) {
            shouldUpdateSelectionOnUp.value = true;
            final target = editor.hitTestScene(e.position.vec2).node.node;

            if (target is RootObject) {
              context.invoke(intents.clearSelection());
            } else {
              context.invoke(intents.selectNode(target));
            }

            if (selection.nodes.isNotEmpty) {
              return MoveNodesActivity(
                editor,
                nodes: selection.nodes.toList(),
                onStart: () => shouldUpdateSelectionOnUp.value = false,
              );
            } else {
              return SelectRectActivity(
                editor: editor,
                onRectChanged: (v) => marqueeRect.value = v,
              );
            }
          },
          child: GestureDetector(
            behavior: .translucent,
            onTapUp: (details) {
              if (!shouldUpdateSelectionOnUp.value) return;

              final target = editor.hitTestScene(details.globalPosition.vec2).node.node;
              if (target is RootObject) {
                context.invoke(intents.clearSelection());
              } else {
                context.invoke(intents.selectNode(target));
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
      ),
    );
  }
}
