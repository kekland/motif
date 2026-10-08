import 'package:color/color_flutter.dart';
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
    final backgroundColor = useComputedValue(() => editor.scene.signal().program.settings.backgroundColor);

    Widget child = InteractiveCanvas(
      key: editor.canvasKey,
      transformationController: editor.canvasTransformationController,
      backgroundColor: backgroundColor.toUiColor(),
      centerOrigin: true,
      overlayBuilders: [
        (context, transform) => CanvasPixelGrid(transform: transform),
        (context, transform) => EditorCanvasPeersWidget(transform: transform),
        (context, transform) => ToolOverlay(tool: tool, child: SizedBox.expand()),
      ],
      minScale: EditorCanvasUtils.minScale,
      maxScale: EditorCanvasUtils.maxScale,
      child: SceneWidget(
        key: editor.sceneKey,
        scene: editor.scene,
        debug: false,
        debugArrangement: true,
      ),
    );

    child = Overlay.wrap(
      child: Surface(
        child: EditorCanvasPointerUpdateWidget(child: child),
      ),
    );

    return EditorTickerProviderWidget(
      key: editor.tickerProviderKey,
      child: EditorActions(
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
      ),
    );
  }
}

final class const EditorTickerProviderWidget({
  super.key,
  required final Widget child,
}) extends StatefulWidget {
  @override
  State<EditorTickerProviderWidget> createState() => EditorTickerProviderWidgetState();
}

class EditorTickerProviderWidgetState extends State<EditorTickerProviderWidget> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => widget.child;
}
