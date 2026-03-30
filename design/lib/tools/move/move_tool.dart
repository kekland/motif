import 'package:design/imports.dart';

class MoveTool extends Tool {
  const MoveTool();

  @override
  String get key => 'move';

  @override
  Widget buildIcon(BuildContext context) => Icons.move();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _MoveToolOverlay(info: info);
}

class _MoveToolOverlay extends StatelessWidget {
  const _MoveToolOverlay({required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
