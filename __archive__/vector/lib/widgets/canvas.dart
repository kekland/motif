import 'package:canvas/canvas.dart';
import '../imports.dart';

class VectorCanvas extends HookWidget {
  const VectorCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);
    final viewportController = useTransformationController();
    final tool = useComputedValue(() => controller.tool.activeTool);

    return Surface(
      color: context.colors.surface.tertiary,
      child: Stack(
        children: [
          Overlay.wrap(
            child: InteractiveCanvasFocus(
              child: InteractiveCanvas(
                key: controller.canvasKey,
                transformationController: viewportController,
                overlayBuilders: [
                  (context, child) => HandlesOverlayBuilder(
                    controller: controller,
                    // areGesturesEnabled: tool is CursorTool,
                    // isVisible: tool is! PencilTool,
                  ),
                  (context, child) => ToolOverlay(tool: tool, child: child),
                  (context, child) => SelectionOverlayBuilder(controller: controller, child: child),
                ],
                child: Stack(
                  children: [
                    // Positioned.fill(
                    //   child: GridPaper(
                    //     color: context.colors.surface.primary,
                    //   ),
                    // ),
                    _VectorControllerWidget(
                      renderKey: controller.renderKey,
                      controller: controller,
                      debug: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // FloatingActionBarPositioned(
          //   child: FloatingActionBar(),
          // ),
        ],
      ),
    );
  }
}

class _VectorControllerWidget extends HookWidget {
  _VectorControllerWidget({
    super.key,
    required this.renderKey,
    required this.controller,
    this.debug = false,
  });

  final GlobalKey renderKey;
  final VectorController controller;
  final bool debug;

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    final transientStrokes = useListenable(controller.transientStrokes);

    return VectorComplexWidget(
      key: renderKey,
      complex: controller.complex,
      transientStrokes: transientStrokes.strokes.toList(),
      debug: debug,
    );
  }
}
