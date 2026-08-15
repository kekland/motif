import 'package:tool/tool.dart';
import 'package:ui/ui.dart';

class ToolOverlay extends HookWidget {
  const ToolOverlay({
    super.key,
    required this.tool,
    required this.child,
  });

  final Tool? tool;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final overlayController = useOverlayPortalController();
    useCallOncePostFrame(() => overlayController.show());

    return OverlayPortal.overlayChildLayoutBuilder(
      controller: overlayController,
      overlayChildBuilder: (context, info) {
        if (tool == null) return const SizedBox.shrink();
        return tool!.buildViewportOverlay(context, info);
      },
      child: child,
    );
  }
}
