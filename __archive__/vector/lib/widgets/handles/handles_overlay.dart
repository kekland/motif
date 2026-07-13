import '../../imports.dart';

class HandlesOverlayBuilder extends HookWidget {
  const HandlesOverlayBuilder({
    super.key,
    required this.controller,
    this.hoveredCell,
    this.isVisible = true,
    this.areGesturesEnabled = true,
  });

  final VectorController controller;
  final bool areGesturesEnabled;
  final Cell? hoveredCell;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return PersistentOverlayBuilder(
      builder: (context, info) => HandlesOverlay(
        controller: controller,
        childPaintTransform: info.childPaintTransform,
        areGesturesEnabled: areGesturesEnabled,
        hoveredCell: hoveredCell,
        isVisible: isVisible,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class HandlesOverlay extends HookWidget {
  const HandlesOverlay({
    super.key,
    required this.controller,
    required this.childPaintTransform,
    this.areGesturesEnabled = true,
    this.hoveredCell,
    this.isVisible = true,
  });

  final VectorController controller;
  final Matrix4 childPaintTransform;
  final bool areGesturesEnabled;
  final Cell? hoveredCell;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final complex = useListenable(controller.complex);
    // final selection = useComputedValue(() => {...controller.selection.selectedObjects});
    // final transientEdges = useListenable(controller.transientEdges).edges;

    final children = <Widget>[];

    for (var cell in complex.cells) {
      if (cell is Vertex) {
        children.add(
          HandleWidget(
            position: cell.position.offset,
            child: VertexHandle(),
          ),
        );
      }
    }

    return Visibility(
      visible: isVisible,
      child: ClipRect(
        child: IgnorePointer(
          // activityFactory: () {},
          child: HandlesLayout(
            childPaintTransform: childPaintTransform,
            children: children,
          ),
        ),
      ),
    );
  }
}
