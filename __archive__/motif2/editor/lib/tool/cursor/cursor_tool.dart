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
    final isSelectionMove = useRef(false);
    final selection = useListenable(editor.selection);

    void onTapUp(TapUpDetails details) {
      if (!shouldUpdateSelectionOnUp.value) return;

      final target = editor.hitTestScene(details.globalPosition.vec2).node.node;
      if (target is RootObject) {
        context.invoke(intents.clearSelection());
      } else {
        context.invoke(intents.selectNode(target));
      }
    }

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: switch (hoveredNode.value) {
        Vertex() => Cursors.toolCursorVertex,
        Edge() => Cursors.toolCursorEdge,
        // RootObject() => Cursors.toolMarquee,
        _ => Cursors.toolCursor,
      },
      child: Stack(
        children: [
          Listener(
            behavior: .translucent,
            onPointerHover: (e) {
              final result = editor.hitTestScene(e.position.vec2);
              hoveredNode.value = result.node.node;
            },
            child: DragActivityDetector(
              behavior: .translucent,
              activityFactory: (e) {
                if (isSelectionMove.value) return null;

                shouldUpdateSelectionOnUp.value = true;
                if (e is PointerDownEvent) {
                  final target = editor.hitTestScene(e.position.vec2).node.node;

                  if (target is RootObject) {
                    context.invoke(intents.clearSelection());
                  } else {
                    context.invoke(intents.selectNode(target));
                  }
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
                onTapUp: onTapUp,
              ),
            ),
          ),
          SelectRectOverlay(rect: marqueeRect.value?.$1, mode: marqueeRect.value?.$2),
          ObjectSelectionOverlay(
            editor: editor,
            selectionGroups: selection.selectionGroups,
            childPaintTransform: info.childPaintTransform,
            onMove: (nodes) {
              isSelectionMove.value = true;
              shouldUpdateSelectionOnUp.value = true;

              return MoveNodesActivity(
                editor,
                nodes: nodes,
                onStart: () => shouldUpdateSelectionOnUp.value = false,
                onEnd: () => isSelectionMove.value = false,
              );
            },
          ),
        ],
      ),
    );
  }
}
