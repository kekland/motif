import 'package:renderer/renderer.dart';
import 'package:editor/imports.dart';
import 'package:editor/widgets/tool/tool_overlay.dart';

class EditorCanvas extends HookWidget {
  const EditorCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final tool = useComputedValue(() => editor.tool.activeTool);

    return InteractiveCanvasFocus(
      child: Overlay.wrap(
        child: Surface(
          color: context.colors.surface.canvas,
          child: InteractiveCanvas(
            centerOrigin: true,
            overlayBuilders: [
              (context, child) => ToolOverlay(tool: tool, child: child),
            ],
            child: SceneWidget(
              key: editor.sceneKey,
              scene: editor.scene,
            ),
          ),
        ),
      ),
    );
  }
}
