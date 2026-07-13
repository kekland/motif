import '../../imports.dart';

export 'select_cells_activity.dart';

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
  const _MarqueeToolOverlay({required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.of(context);
    final marqueeRect = useState<Rect?>(null);

    return DragActivityDetector(
      behavior: .translucent,
      activityFactory: () => SelectCellsActivity(
        controller: controller,
        onMarqueeRectChanged: (rect) => marqueeRect.value = rect,
      ),
      child: Stack(
        children: [
          if (marqueeRect.value != null) MarqueeOverlay(rect: marqueeRect.value!),
        ],
      ),
    );
  }
}
