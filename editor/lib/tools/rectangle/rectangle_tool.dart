import 'package:editor/imports.dart';

class RectangleTool extends Tool {
  const RectangleTool();

  @override
  Widget buildIcon(BuildContext context) => Icons.square();

  @override
  String get key => 'rectangle';

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _RectangleToolOverlay(info: info);
}

class _RectangleToolOverlay extends HookWidget {
  const _RectangleToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final editor = Editor.watch(context);

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: Cursors.toolRectangle,
      child: DragActivityDetector(
        activityFactory: (_) => CreateRectangleActivity(
          editor: editor,
        ),
      ),
    );
  }
}
