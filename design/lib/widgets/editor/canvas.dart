import 'package:canvas/canvas.dart';
import 'package:design/imports.dart';

class DesignCanvas extends HookWidget {
  const DesignCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DesignController.watch(context);
    final root = useListenable(controller.root);

    final canvasKey = controller.canvasKey;
    final viewportController = useTransformationController();
    final tool = useComputedValue(() => controller.tool.activeTool);

    return InteractiveCanvasFocus(
      child: Overlay.wrap(
        child: Surface(
          color: context.colors.surface.tertiary,
          child: Stack(
            children: [
              InteractiveCanvas(
                key: canvasKey,
                transformationController: viewportController,
                overlayBuilders: [
                  (context, child) => ToolOverlay(tool: tool, child: child),
                ],
                child: RootNodeWidget(node: root),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
