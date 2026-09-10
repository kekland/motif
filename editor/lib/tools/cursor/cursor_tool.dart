import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_overlay/hover_overlay.dart';
import 'package:editor/widgets/selection_overlay/selection_overlay.dart';
import 'package:flutter/gestures.dart';

class CursorTool extends Tool {
  const CursorTool();

  @override
  String get key => 'cursor';

  @override
  Widget buildIcon(BuildContext context) => Icons.cursor();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _CursorToolOverlay(info: info);

  @override
  LogicalKeySet? get shortcut => .new(.keyV);
}

class _CursorToolOverlay extends HookWidget {
  const _CursorToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final selection = editor.selection;
    useListenable(selection);

    final hoveredCell = useState<Ref?>(null);
    final marqueeRect = useState<(Rect, HitTestRectMode)?>(null);
    final shouldUpdateSelectionOnUp = useRef(true);
    final isSelectionMove = useRef(false);

    DragActivity _move(Iterable<Ref> refs, {Ref? clicked}) => MoveActivity(
      editor,
      refs.toList(),
      onUpdate: () => shouldUpdateSelectionOnUp.value = false,
      onEnd: () {
        isSelectionMove.value = false;
        if (!shouldUpdateSelectionOnUp.value || clicked == null) return;
        context.invoke(intents.selectRef(clicked));
      },
    );

    List<Ref>? _refsToMove(PointerEvent e) {
      final selected = selection.refs.toSet();
      final hit = editor.hitTest(e.position).top?.ref;

      if (hit == null || selected.contains(hit)) return selected.toList();
      if (selection.visibleCovertices.contains(hit)) return [hit];
      return null;
    }

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: switch (hoveredCell.value) {
        CovertexRef() => Cursors.toolCursorControlPoint,
        CellRef(kind: .vertex) => Cursors.toolCursorVertex,
        CellRef(kind: .edge) => Cursors.toolCursorEdge,
        CellRef(kind: .face) => Cursors.toolCursorFace,
        _ => Cursors.toolCursor,
      },
      child: Listener(
        behavior: .translucent,
        onPointerHover: (e) {
          final result = editor.hitTest(e.position);
          hoveredCell.value = result.top?.ref;
        },
        child: Stack(
          children: [
            HoverOverlay(
              ref: hoveredCell.value,
              childPaintTransform: info.childPaintTransform,
            ),
            DragActivityDetector(
              behavior: .translucent,
              activityFactory: (e) {
                if (isSelectionMove.value) return null;
                shouldUpdateSelectionOnUp.value = true;

                if (e is PointerDownEvent) {
                  final target = editor.hitTest(e.position).top;

                  if (target != null) {
                    context.invoke(intents.selectRef(target.ref));
                  } else {
                    context.invoke(intents.clearSelection());
                  }
                }

                if (selection.refs.isNotEmpty) {
                  return _move(selection.refs);
                } else {
                  return SelectRectActivity(
                    editor: editor,
                    onRectChanged: (r) => marqueeRect.value = r,
                  );
                }
              },
            ),
            SelectRectOverlay(rect: marqueeRect.value?.$1, mode: marqueeRect.value?.$2),
            CellSelectionOverlay(
              editor: editor,
              childPaintTransform: info.childPaintTransform,
              onMove: (e, refs) {
                final refsToMove = _refsToMove(e);
                if (refsToMove == null) return null;

                if (!listEquals(refs, refsToMove)) {
                  return null;
                }

                shouldUpdateSelectionOnUp.value = true;
                isSelectionMove.value = true;
                return _move(selection.refs, clicked: editor.hitTest(e.position).top?.ref);
              },
            ),
          ],
        ),
      ),
    );
  }
}
