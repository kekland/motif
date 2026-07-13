import 'package:editor/imports.dart';

class ContainerTool extends Tool {
  const ContainerTool();

  @override
  Widget buildIcon(BuildContext context) => Icons.container();

  @override
  String get key => 'container';

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _ContainerToolOverlay(info: info);
}

class _ContainerToolOverlay extends HookWidget {
  const _ContainerToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final editor = Editor.watch(context);

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: Cursors.toolContainer,
      child: DragActivityDetector(
        activityFactory: (_) => CreateContainerActivity(
          editor: editor,
        ),
      ),
    );
  }
}
