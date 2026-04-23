import 'package:canvas/canvas.dart';
import 'package:design/imports.dart';

class DesignCanvas extends HookWidget {
  const DesignCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DesignController.watch(context);
    final root = useListenable(controller.root);
    final focusNode = useFocusScopeNode();

    final canvasKey = controller.canvasKey;
    final viewportController = useTransformationController();

    // Ensure that the canvas always has focus if no other widget has it.
    useEffect(() {
      void _onPrimaryFocusChanged() {
        final primaryFocus = FocusManager.instance.primaryFocus;
        if (primaryFocus == focusNode.enclosingScope) focusNode.requestFocus();
      }

      FocusManager.instance.addListener(_onPrimaryFocusChanged);
      return () => FocusManager.instance.removeListener(_onPrimaryFocusChanged);
    });

    final tool = useComputedValue(() => controller.tool.activeTool);

    return FocusScope(
      autofocus: true,
      canRequestFocus: true,
      descendantsAreFocusable: true,
      node: focusNode,
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
