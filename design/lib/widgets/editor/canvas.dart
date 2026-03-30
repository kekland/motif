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
                  (context, child) => _ToolOverlay(child: child),
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

class _ToolOverlay extends HookWidget {
  const _ToolOverlay({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = DesignController.of(context);
    final tool = useListenable(controller.tool);

    final overlayController = useOverlayPortalController();
    useCallOncePostFrame(() => overlayController.show());

    return OverlayPortal.overlayChildLayoutBuilder(
      controller: overlayController,
      overlayChildBuilder: (context, info) {
        return tool.wrapViewport(context, info);
      },
      child: child,
    );
  }
}
