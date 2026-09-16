import 'package:editor/imports.dart';
import 'package:editor/tools/pencil/transient_strokes_widget.dart';

class PencilTool extends Tool {
  const PencilTool();

  @override
  String get key => 'pencil';

  @override
  Widget buildIcon(BuildContext context) => Icons.pencil();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _PencilToolOverlay(info: info);

  @override
  SingleActivator? get shortcut => .new(.keyN);
}

class _PencilToolOverlay extends HookWidget {
  const _PencilToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: SystemMouseCursors.precise,
      child: DragActivityDetector(
        behavior: .translucent,
        activityFactory: (_) => PencilFreehandStrokeActivity(context.editor),
        child: TransientStrokesWidget(
          transform: info.childPaintTransform,
        ),
      ),
    );
  }
}
