import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_overlay/selection_overlay.dart';

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
    final editor = context.editor;
    final selection = editor.selection;
    useListenable(selection);

    final hoveredCell = useState<CellKind?>(null);
    final marqueeRect = useState<(Rect, HitTestRectMode)?>(null);
    final shouldUpdateSelectionOnUp = useRef(true);
    final isSelectionMove = useRef(false);

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: switch (hoveredCell.value) {
        .vertex => Cursors.toolCursorVertex,
        .edge => Cursors.toolCursorEdge,
        .face => Cursors.toolCursorFace,
        _ => Cursors.toolCursor,
      },
      child: Listener(
        behavior: .translucent,
        onPointerHover: (e) {
          final result = editor.hitTest(e.position);
          hoveredCell.value = result.top?.kind;
        },
        // onPointerDown: (e) {
        //   final result = editor.hitTest(e.position);

        //   final top = result.top;
        //   if (top != null) {
        //     editor.selection.set(top.key);
        //   } else {
        //     editor.selection.clear();
        //   }
        // },
        child: Stack(
          children: [
            DragActivityDetector(
              behavior: .translucent,
              activityFactory: (e) {
                if (isSelectionMove.value) return null;
                shouldUpdateSelectionOnUp.value = true;

                if (e is PointerDownEvent) {
                  final target = editor.hitTest(e.position).top;

                  if (target != null) {
                    context.invoke(intents.selectCell(target.ref));
                  } else {
                    context.invoke(intents.clearSelection());
                  }
                }

                if (selection.refs.isNotEmpty) {
                  return MoveActivity(
                    editor,
                    selection.refs.toList(),
                    onStart: () => shouldUpdateSelectionOnUp.value = false,
                  );
                } else {
                  return SelectRectActivity(
                    editor: editor,
                    onRectChanged: (r) => marqueeRect.value = r,
                  );
                }
              },
              child: GestureDetector(
                behavior: .translucent,
                onTapUp: (TapUpDetails details) {
                  final target = editor.hitTest(details.globalPosition).top;

                  if (target != null) {
                    context.invoke(intents.selectCell(target.ref));
                  } else {
                    context.invoke(intents.clearSelection());
                  }
                },
              ),
            ),
            SelectRectOverlay(rect: marqueeRect.value?.$1, mode: marqueeRect.value?.$2),
            CellSelectionOverlay(
              editor: editor,
              childPaintTransform: info.childPaintTransform,
              onMove: (cells) {
                isSelectionMove.value = true;
                shouldUpdateSelectionOnUp.value = true;

                return MoveActivity(
                  editor,
                  cells,
                  onStart: () => shouldUpdateSelectionOnUp.value = false,
                  onEnd: () => isSelectionMove.value = false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
