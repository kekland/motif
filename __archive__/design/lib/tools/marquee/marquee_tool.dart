import 'package:design/imports.dart';

class MarqueeTool extends Tool {
  const MarqueeTool();

  @override
  String get key => 'marquee';

  @override
  Widget buildIcon(BuildContext context) => Icons.marquee();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _MarqueeToolOverlay(info: info);
}

class _MarqueeToolOverlay extends StatelessWidget {
  const _MarqueeToolOverlay({required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
