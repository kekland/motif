import 'package:editor/imports.dart';

class FillTool extends Tool {
  const FillTool();

  @override
  String get key => 'fill';

  @override
  Widget buildIcon(BuildContext context) => Icons.fill();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _FillToolOverlay(info: info);
}

class _FillToolOverlay extends StatelessWidget {
  const _FillToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
