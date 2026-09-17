import 'package:editor/imports.dart';
import 'package:editor/tools/pencil/transient_strokes_widget.dart';

class PencilTool extends Tool {
  const PencilTool();

  @override
  String get key => 'pencil';

  @override
  List<ToolOption> get options => [
    TopologicalToolOption.entry,
    DestructiveToolOption.entry,
    EdgeStyleToolOption.entry,
  ];

  bool topological(BuildContext context) => context.editor.tool.getOption(options[0].key).value;
  bool destructive(BuildContext context) => context.editor.tool.getOption(options[1].key).value;
  EdgeStyle edgeStyle(BuildContext context) => context.editor.tool.getOption(options[2].key).value;

  @override
  String resolveName(BuildContext context) => 'Pencil';

  @override
  Widget buildIcon(BuildContext context) => Icons.pencil();

  @override
  Widget buildViewportOverlay(
    BuildContext context,
    OverlayChildLayoutInfo info,
    PencilTool tool,
  ) => _PencilToolOverlay(info: info, tool: tool);

  @override
  SingleActivator? get shortcut => .new(.keyN);
}

class _PencilToolOverlay extends HookWidget {
  const _PencilToolOverlay({
    super.key,
    required this.info,
    required this.tool,
  });

  final OverlayChildLayoutInfo info;
  final PencilTool tool;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: SystemMouseCursors.precise,
      child: DragActivityDetector(
        behavior: .translucent,
        activityFactory: (_) => PencilFreehandStrokeActivity(
          context.editor,
          topological: tool.topological(context),
          destructive: tool.destructive(context),
          edgeStyle: tool.edgeStyle(context),
        ),
        child: TransientStrokesWidget(
          transform: info.childPaintTransform,
        ),
      ),
    );
  }
}
