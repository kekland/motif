import 'package:editor/imports.dart';

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
    return SelectRectDetector();
  }
}
