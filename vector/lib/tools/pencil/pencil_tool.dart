import 'package:vector/imports.dart';
import 'package:vector/tools/pencil/pencil_freehand_drag_activity.dart';

class PencilTool extends Tool {
  const PencilTool();

  @override
  String get key => 'pencil';

  @override
  Widget buildIcon(BuildContext context) => Icons.pencil();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _PencilToolOverlay(info: info);
}

class _PencilToolOverlay extends HookWidget {
  const _PencilToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);

    final freehandDragRecognizer = useManagedResource(
      create: () => DragActivityGestureRecognizer(
        activityFactory: () => PencilFreehandDrawActivity(controller: controller),
      ),
      dispose: (v) => v.dispose(),
    );

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: SystemMouseCursors.precise,
      child: Listener(
        behavior: .translucent,
        onPointerDown: (e) {
          freehandDragRecognizer.addPointer(e);
        },
        child: GestureDetector(
          behavior: .translucent,
          onTapUp: (details) {
            final globalPosition = details.globalPosition;
            final localPosition = controller.globalToArtworkLocal(globalPosition);
            controller.complex.createVertex(localPosition.asVector2());
          },
        ),
      ),
    );
  }
}
