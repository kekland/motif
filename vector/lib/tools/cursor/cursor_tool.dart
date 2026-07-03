import 'package:vector/imports.dart';

export 'activities/move_object_activity.dart';

class CursorTool extends Tool {
  const CursorTool();

  @override
  String get key => 'cursor';

  @override
  LogicalKeySet get shortcut => LogicalKeySet(.keyV);

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
    final controller = VectorController.watch(context);
    final hoveredObject = useState<Object?>(null);
    final shouldUpdateSelectionOnUp = useRef(true);

    return Stack(
      children: [
        MouseRegion(
          hitTestBehavior: .translucent,
          cursor: switch (hoveredObject.value) {
            Vertex() => Cursors.toolCursorVertex,
            Edge() => Cursors.toolCursorEdge,
            EdgeKnot() => Cursors.toolCursorKnot,
            EdgeKnotControlPoint() => Cursors.toolCursorControlPoint,
            _ => .defer,
          },
          child: Listener(
            behavior: .translucent,
            onPointerHover: (e) {
              final hits = controller.hitTestCells(e.position);

              if (hits.isNotEmpty) {
                hoveredObject.value = hits.first.hitObject;
              } else {
                hoveredObject.value = null;
              }
            },
            onPointerDown: (e) {
              shouldUpdateSelectionOnUp.value = true;
              final hits = controller.hitTestCells(e.position);

              if (hits.isNotEmpty) {
                controller.selection.select(hits.first.cell);
              }
            },
            child: DragActivityDetector(
              behavior: .translucent,
              activityFactory: () => MoveObjectActivity(controller: controller),
              child: GestureDetector(
                behavior: .translucent,
                onTapUp: (details) {
                  final hits = controller.hitTestCells(details.globalPosition);
                  if (hits.isEmpty) {
                    controller.selection.clear();
                  } else {
                    controller.selection.select(hits.first.cell);
                  }
                },
                // child: Stack(
                //   children: [
                //     Transform(
                //       transform: info.childPaintTransform,
                //       child: HoverOverlayBuilder(
                //         controller: controller,
                //         hoveredCell: hoveredCell.value,
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
