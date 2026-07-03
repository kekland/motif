import 'package:vector/imports.dart';
import 'package:vector/tools/pencil/activities/pencil_freehand_draw_activity.dart';

export 'activities/pencil_freehand_draw_activity.dart';

class PencilTool extends Tool {
  const PencilTool();

  @override
  String get key => 'pencil';

  @override
  LogicalKeySet get shortcut => LogicalKeySet(.keyN);

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

    // final freehandDragRecognizer = useManagedResource(
    //   create: () => DragActivityGestureRecognizer(
    //     activityFactory: () => PencilFreehandDrawActivity(controller: controller),
    //     devicesToAcceptImmediately: {.stylus},
    //   ),
    //   dispose: (v) => v.dispose(),
    // );

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: SystemMouseCursors.precise,
      child: DragActivityDetector(
        behavior: .translucent,
        activityFactory: () => PencilFreehandDrawActivity(controller: controller),
        child: const SizedBox.expand(),
      ),
    );
  }
}
