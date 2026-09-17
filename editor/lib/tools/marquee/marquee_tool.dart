import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_overlay/selection_overlay.dart';

class MarqueeTool extends Tool {
  const MarqueeTool();

  @override
  Widget buildIcon(BuildContext context) => Icons.marquee();

  @override
  String resolveName(BuildContext context) => 'Marquee';

  @override
  String get key => 'marquee';

  @override
  Widget buildViewportOverlay(
    BuildContext context,
    OverlayChildLayoutInfo info,
    MarqueeTool tool,
  ) => _MarqueeToolOverlay(info: info, tool: tool);

  @override
  SingleActivator? get shortcut => .new(.keyM);
}

class _MarqueeToolOverlay extends HookWidget {
  const _MarqueeToolOverlay({
    super.key,
    required this.info,
    required this.tool,
  });

  final OverlayChildLayoutInfo info;
  final MarqueeTool tool;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;

    return Stack(
      children: [
        Positioned.fill(child: SelectRectDetector()),
        Positioned.fill(
          child: IgnorePointer(
            child: CellSelectionOverlay(
              editor: editor,
              childPaintTransform: info.childPaintTransform,
            ),
          ),
        ),
      ],
    );
  }
}
