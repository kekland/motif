import 'package:editor/imports.dart';

abstract class ShapeTool extends Tool {
  const ShapeTool();

  CreateShapeActivity Function(Editor editor) get activityFactory;
  MouseCursor get cursor;

  @override
  Widget buildViewportOverlay(
    BuildContext context,
    OverlayChildLayoutInfo info,
    ShapeTool tool,
  ) => _ShapeToolOverlay(
    info: info,
    activityFactory: activityFactory,
    cursor: cursor,
    tool: tool,
  );
}

class _ShapeToolOverlay extends HookWidget {
  const _ShapeToolOverlay({
    super.key,
    required this.info,
    required this.activityFactory,
    required this.cursor,
    required this.tool,
  });

  final OverlayChildLayoutInfo info;
  final CreateShapeActivity Function(Editor edito) activityFactory;
  final MouseCursor cursor;
  final ShapeTool tool;

  @override
  Widget build(BuildContext context) {
    final editor = Editor.watch(context);

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: cursor,
      child: DragActivityDetector(
        activityFactory: (_) => activityFactory(editor),
      ),
    );
  }
}
