import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_overlay/selection_overlay.dart';

class MarqueeTool extends Tool {
  const MarqueeTool();

  @override
  Widget buildIcon(BuildContext context) => Icons.marquee();

  @override
  String get key => 'marquee';

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _MarqueeToolOverlay(info: info);
}

class _MarqueeToolOverlay extends HookWidget {
  const _MarqueeToolOverlay({
    super.key,
    required this.info,
  });

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;

    return Stack(
      children: [
        Positioned.fill(child: SelectRectDetector()),
        Positioned.fill(
          child: CellSelectionOverlay(
            editor: editor,
            childPaintTransform: info.childPaintTransform,
          ),
        ),
      ],
    );
  }
}
