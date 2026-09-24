import 'package:editor/imports.dart';

class KnifeTool extends Tool {
  const KnifeTool();

  @override
  Widget buildIcon(BuildContext context) => Icons.knife();

  @override
  String resolveName(BuildContext context) => 'Knife';

  @override
  String get key => 'knife';

  @override
  Widget buildViewportOverlay(
    BuildContext context,
    OverlayChildLayoutInfo info,
    KnifeTool tool,
  ) => _KnifeToolOverlay(info: info, tool: tool);

  @override
  SingleActivator? get shortcut => .new(.keyK);
}

class _KnifeToolOverlay extends StatelessWidget {
  const new({
    super.key,
    required this.info,
    required this.tool,
  });

  final OverlayChildLayoutInfo info;
  final KnifeTool tool;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('not working yet'));
  }
}
