import 'package:editor/widgets/actions.dart';
import 'package:editor/widgets/context_menu/canvas_context_menu.dart';
import 'package:editor/widgets/editor_canvas_clients.dart';
import 'package:renderer/renderer.dart';
import 'package:editor/imports.dart';
import 'package:editor/widgets/tool/tool_overlay.dart';

class EditorCanvas extends HookWidget {
  const EditorCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final tool = useComputedValue(() => editor.tool.activeTool);

    Widget child = InteractiveCanvas(
      centerOrigin: true,
      overlayBuilders: [
        (context, transform) => CanvasPixelGrid(transform: transform),
        (context, transform) => EditorCanvasPeersWidget(transform: transform),
        (context, transform) => ToolOverlay(tool: tool, child: SizedBox.expand()),
      ],
      minScale: 1 / 128.0,
      child: SceneWidget(
        key: editor.sceneKey,
        scene: editor.scene,
        debug: false,
        debugArrangement: true,
      ),
    );

    child = Overlay.wrap(
      child: Surface(
        color: context.colors.surface.canvas,
        child: EditorCanvasPointerUpdateWidget(
          child: child,
        ),
      ),
    );

    return EditorActions(
      child: EditorShortcuts(
        child: ToolShortcuts(
          controller: editor.tool,
          canInvoke: (context) => editor.areCanvasActionsEnabled,
          child: InheritedCallbackShortcuts(
            child: CommanderRoot(
              key: editor.commanderRootKey,
              child: CanvasContextMenu(
                child: InteractiveCanvasFocus(
                  focusScopeNode: editor.canvasFocusScopeNode,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
