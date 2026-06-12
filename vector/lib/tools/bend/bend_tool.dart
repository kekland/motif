import 'package:vector/imports.dart';

export 'bend_activity.dart';

class BendTool extends Tool {
  const BendTool();

  @override
  String get key => 'bend';

  @override
  Widget buildIcon(BuildContext context) => Icons.bend();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _BendToolOverlay(info: info);
}

class _BendToolOverlay extends HookWidget {
  const _BendToolOverlay({required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.of(context);

    final activityRecognizer = useDragActivityWithArgumentRecognizer<CellHitTestEntry>(
      (hitTest) => BendDragActivity.create(controller, hitTest),
    );

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        final hitTest = controller.hitTestCell(event.position);
        if (hitTest == null) return;

        activityRecognizer.addPointer(event, argument: hitTest);
      },
      child: Container(),
    );
  }
}
