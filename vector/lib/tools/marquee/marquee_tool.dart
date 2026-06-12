import 'package:vector/imports.dart';

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
    final marqueeRect = useState<Rect?>(null);

    final selectCellsRecognizer = useDragActivityRecognizer(
      () => SelectCellsActivity(
        controller: VectorController.of(context),
        onMarqueeRectChanged: (rect) => marqueeRect.value = rect,
      ),
    );

    return Listener(
      behavior: .translucent,
      onPointerDown: (e) {
        selectCellsRecognizer.addPointer(e);
      },
      child: Stack(
        children: [
          if (marqueeRect.value != null) MarqueeOverlay(rect: marqueeRect.value!),
        ],
      ),
    );
  }
}
