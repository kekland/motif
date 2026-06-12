import 'package:canvas/canvas.dart';
import 'package:vector/imports.dart';
import 'package:vector/widgets/artwork.dart';
import 'package:vector/widgets/floating_action_bar/floating_action_bar.dart';
import 'package:vector/widgets/handles_overlay.dart';
import 'package:vector/widgets/toolbar.dart';

class VectorEditorPage extends HookWidget {
  const VectorEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useDisposable(() => VectorController());

    return ReassembleProvider(
      child: Provider.value(
        value: controller,
        child: EditorPageTemplate(
          mainBarConstraints: .pixels(48.0, 48.0),
          mainBar: VectorToolbar(),
          toolBar: null,
          // mainBar: PropertiesPanel(),
          sideBar: null,
          // toolBar: VectorToolbar(),
          canvas: _VectorCanvas(),
        ),
      ),
    );
  }
}

class _VectorCanvas extends HookWidget {
  const _VectorCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);
    final viewportController = useTransformationController();
    final tool = useComputedValue(() => controller.tool.activeTool);

    return ToolShortcuts(
      controller: controller.tool,
      child: Stack(
        children: [
          Overlay.wrap(
            child: InteractiveCanvasFocus(
              child: InteractiveCanvas(
                key: controller.canvasKey,
                centerOrigin: false,
                transformationController: viewportController,
                overlayBuilders: [
                  (context, child) => HandlesOverlayBuilder(
                    controller: controller,
                    areGesturesEnabled: tool is CursorTool,
                    isVisible: tool is! PencilTool,
                  ),
                  (context, child) => ToolOverlay(tool: tool, child: child),
                ],
                child: Stack(
                  children: [
                    // Positioned.fill(
                    //   child: GridPaper(
                    //     color: context.colors.surface.tertiary,
                    //   ),
                    // ),
                    ArtworkWidget(
                      controller: controller,
                    ),
                  ],
                ),
              ),
            ),
          ),
          FloatingActionBarPositioned(
            child: FloatingActionBar(),
          ),
        ],
      ),
    );
  }
}
