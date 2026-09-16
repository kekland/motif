import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_overlay/cell_handles.dart';

class BendTool extends Tool {
  const BendTool();

  @override
  String get key => 'bend';

  @override
  Widget buildIcon(BuildContext context) => Icons.bend();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _BendToolOverlay(info: info);

  @override
  SingleActivator? get shortcut => .new(.keyB);
}

class _BendToolOverlay extends HookWidget {
  const _BendToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final hoveredCell = useState<Ref?>(null);

    return Focus(
      autofocus: true,
      child: MouseRegion(
        hitTestBehavior: .translucent,
        cursor: switch (hoveredCell.value) {
          CellRef(kind: .edge) => Cursors.toolPenEdge,
          CovertexRef() => Cursors.toolCursorControlPoint,
          _ => Cursors.precise,
        },
        child: Listener(
          behavior: .translucent,
          onPointerHover: (e) {
            final result = editor.hitTest(
              e.position,
              covertexMode: .all(allowCollapsed: true),
            );

            hoveredCell.value = result.topWhere((e) => e.ref is CovertexRef || (e.ref as CellRef).kind == .edge)?.ref;
          },
          child: DragActivityDetector(
            behavior: .translucent,
            activityFactory: (e) {
              final hitTest = editor.hitTest(e.position, covertexMode: .all(allowCollapsed: true));
              final hovered = hitTest.topWhere((e) => e.ref is CovertexRef || (e.ref as CellRef).kind == .edge)?.ref;

              if (hovered is CovertexRef) {
                return MoveActivity(editor, {hitTest.top!.ref});
              } else if (hovered is EdgeRef) {
                return BendEdgeActivity(editor, hovered);
              } else {
                return null;
              }
            },
            child: Stack(
              children: [
                CellHandlesWidget(
                  scene: editor.scene,
                  paintTransform: info.childPaintTransform,
                  refs: {
                    ...editor.scene.evaluation.live.ofKind(.vertex),
                    ?hoveredCell.value,
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
