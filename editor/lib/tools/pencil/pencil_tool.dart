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
    PenEdgeStyleToolOption.entry,
  ];

  bool topological(BuildContext context) => context.editor.tool.get(options[0].key);
  bool destructive(BuildContext context) => context.editor.tool.get(options[1].key);
  PenEdgeStyleToolOption edgeStyle(BuildContext context) => context.editor.tool.getOption(options[2].key);

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
    final editor = context.editor;

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: SystemMouseCursors.precise,
      child: DragActivityDetector(
        behavior: .translucent,
        activityFactory: (e) {
          final position = editor.globalToScene(e.position);

          return PencilFreehandStrokeActivity(
            context.editor,
            topological: tool.topological(context),
            destructive: tool.destructive(context),
            edgeStyle: tool.edgeStyle(context).resolve(editor.scene, position),
          );
        },
        child: TransientStrokesWidget(
          transform: info.childPaintTransform,
        ),
      ),
    );
  }
}
