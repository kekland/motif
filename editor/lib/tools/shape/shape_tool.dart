import 'package:editor/imports.dart';

abstract class ShapeTool extends Tool {
  const ShapeTool();

  CreateShapeActivityFactory get activityFactory;
  MouseCursor get cursor;

  @override
  List<ToolOption> get options => [
    SnapToPixelToolOption.entry,
    EdgeStyleToolOption.entry,
    FaceStyleToolOption.entry,
  ];

  bool snapToPixel(BuildContext context) => context.editor.tool.getOption(options[0].key).value;
  EdgeStyle edgeStyle(BuildContext context) => context.editor.tool.getOption(options[1].key).value;
  FaceStyle faceStyle(BuildContext context) => context.editor.tool.getOption(options[2].key).value;

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

typedef CreateShapeActivityFactory = CreateShapeActivity Function(
  Editor editor, {
  EdgeStyle edgeStyle,
  FaceStyle faceStyle,
  bool snapToPixel,
});

class _ShapeToolOverlay extends HookWidget {
  const _ShapeToolOverlay({
    super.key,
    required this.info,
    required this.activityFactory,
    required this.cursor,
    required this.tool,
  });

  final OverlayChildLayoutInfo info;
  final CreateShapeActivityFactory activityFactory;

  final MouseCursor cursor;
  final ShapeTool tool;

  @override
  Widget build(BuildContext context) {
    final editor = Editor.watch(context);

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: cursor,
      child: DragActivityDetector(
        activityFactory: (_) => activityFactory(
          editor,
          edgeStyle: tool.edgeStyle(context),
          faceStyle: tool.faceStyle(context),
          snapToPixel: tool.snapToPixel(context),
        ),
      ),
    );
  }
}
