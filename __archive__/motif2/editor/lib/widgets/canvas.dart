import 'package:canvas/canvas.dart';
import 'package:editor/imports.dart';

class EditorCanvas extends HookWidget {
  const EditorCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final tool = useComputedValue(() => editor.tool.activeTool);

    return InteractiveCanvasFocus(
      child: Overlay.wrap(
        child: Surface(
          color: context.colors.surface.tertiary,
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
