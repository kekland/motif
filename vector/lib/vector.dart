import 'package:canvas/canvas.dart';
import 'package:vector/imports.dart';
import 'package:vector/widgets/artwork.dart';
import 'package:vector/widgets/toolbar.dart';

class VectorEditorPage extends HookWidget {
  const VectorEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useDisposable(() => VectorController());

    return Provider.value(
      value: controller,
      child: EditorPageTemplate(
        mainBar: null,
        sideBar: null,
        toolBar: VectorToolbar(),
        canvas: _VectorCanvas(),
      ),
    );
  }
}

class _VectorCanvas extends HookWidget {
  const _VectorCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);
    final complex = controller.complex;
    final viewportController = useTransformationController();
    final tool = useComputedValue(() => controller.tool.activeTool);

    return Overlay.wrap(
      child: InteractiveCanvas(
        key: controller.canvasKey,
        centerOrigin: false,
        transformationController: viewportController,
        overlayBuilders: [
          (context, child) => ToolOverlay(tool: tool, child: child),
        ],
        child: Stack(
          children: [
            Positioned.fill(
              child: GridPaper(
                color: context.colors.surface.tertiary,
              ),
            ),
            ArtworkWidget(controller: controller),
          ],
        ),
      ),
    );
  }
}
