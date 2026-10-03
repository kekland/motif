import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_overlay/selection_overlay.dart';

abstract class LayoutBoxTool extends Tool {
  const LayoutBoxTool();

  CreateLayoutBoxActivityFactory get activityFactory;
  MouseCursor get cursor;

  @override
  List<ToolOption> get options => [
    SnapToPixelToolOption.entry,
    ShapeEdgeStyleToolOption.entry,
    FaceStyleToolOption.entry,
  ];

  bool snapToPixel(BuildContext context) => context.editor.tool.getOption(options[0].key).value;
  EdgeStyle edgeStyle(BuildContext context) => context.editor.tool.getOption(options[1].key).value;
  FaceStyle faceStyle(BuildContext context) => context.editor.tool.getOption(options[2].key).value;

  @override
  Widget buildViewportOverlay(
    BuildContext context,
    OverlayChildLayoutInfo info,
    LayoutBoxTool tool,
  ) => _LayoutBoxToolOverlay(
    info: info,
    activityFactory: activityFactory,
    cursor: cursor,
    tool: tool,
  );
}

typedef CreateLayoutBoxActivityFactory = CreateLayoutBoxActivity Function(
  Editor editor, {
  EdgeStyle edgeStyle,
  FaceStyle faceStyle,
  bool snapToPixel,
  void Function(FrameRef)? onCreated,
  void Function()? onEnd,
  void Function()? onCancel,
});

class _LayoutBoxToolOverlay extends HookWidget {
  const _LayoutBoxToolOverlay({
    super.key,
    required this.info,
    required this.activityFactory,
    required this.cursor,
    required this.tool,
  });

  final OverlayChildLayoutInfo info;
  final CreateLayoutBoxActivityFactory activityFactory;

  final MouseCursor cursor;
  final LayoutBoxTool tool;

  @override
  Widget build(BuildContext context) {
    final editor = Editor.watch(context);
    final frame = useState<FrameRef?>(null);

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: cursor,
      child: Stack(
        children: [
          CellSelectionGroupOverlay(
            refs: [?frame.value],
            editor: editor,
            childPaintTransform: info.childPaintTransform,
          ),
          DragActivityDetector(
            activityFactory: (_) => activityFactory(
              editor,
              edgeStyle: tool.edgeStyle(context),
              faceStyle: tool.faceStyle(context),
              snapToPixel: tool.snapToPixel(context),
              onCreated: (f) => frame.value = f,
              onEnd: () => frame.value = null,
              onCancel: () => frame.value = null,
            ),
          ),
        ],
      ),
    );
  }
}
