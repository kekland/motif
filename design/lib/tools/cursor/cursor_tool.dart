import 'package:design/imports.dart';
import 'package:design/tools/cursor/hover_overlay.dart';
import 'package:design/tools/cursor/selection_overlay.dart';
import 'package:design/tools/marquee/marquee_overlay.dart';

import 'utils.dart';

class CursorTool extends Tool {
  const CursorTool();

  @override
  String get key => 'cursor';

  @override
  Widget buildIcon(BuildContext context) => Icons.cursor();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _CursorToolOverlay(info: info);
}

class _CursorToolOverlay extends HookWidget {
  const _CursorToolOverlay({required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final controller = DesignController.of(context);
    final hoveringNodeSignal = useSignal<RenderNode?>(null);
    final marqueeRectSignal = useSignal<Rect?>(null);
    final shouldUpdateSelectionOnUp = useRef(true);

    final moveActivityRecognizer = useManagedResource(
      create: () => DragActivityGestureRecognizer(
        onStart: () => shouldUpdateSelectionOnUp.value = false,
        activityFactory: () => MoveNodesActivity(
          controller: controller,
          nodes: controller.selection.selectedNodes.toList().cast(),
        ),
      ),
      dispose: (v) => v.dispose(),
    );

    final marqueeActivityRecognizer = useManagedResource(
      create: () => DragActivityGestureRecognizer(
        onStart: () => shouldUpdateSelectionOnUp.value = false,
        activityFactory: () => SelectNodesActivity(
          root: controller.renderRootNode,
        localRenderObject: context.findRenderObject()!,
          onMarqueeRectChanged: marqueeRectSignal.$set,
          onSelectedNodesChanged: controller.selection.setMultiple,
        ),
      ),
      dispose: (v) => v.dispose(),
    );

    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      cursor: Cursors.toolCursor,
      onHover: (e) {
        final target = hitTestNodes(controller.renderRootNode, e.position).first;
        hoveringNodeSignal.value = target is! RenderRootNode ? target : null;
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (e) {
          shouldUpdateSelectionOnUp.value = true;

          // Set up the selection
          final target = hitTestNodes(controller.renderRootNode, e.position).first;

          // If the target we hit is already in the selection, do not do anything for now.
          if (!controller.selection.isImplicitlySelected(target.node)) {
            if (target is RenderRootNode) {
              context.invoke(intents.clearSelection());
            } else {
              context.invoke(intents.selectNode(target.node));
            }
          }

          // Check for selection, start dragging if there's any. Otherwise, start marquee selection.
          final selectedNodes = controller.selection.selectedNodes;
          if (selectedNodes.isNotEmpty) {
            moveActivityRecognizer.addPointer(e);
          } else {
            marqueeActivityRecognizer.addPointer(e);
          }
        },
        child: GestureDetector(
          behavior: .translucent,
          onTapUp: (e) {
            if (!shouldUpdateSelectionOnUp.value) return;
            final target = hitTestNodes(controller.renderRootNode, e.globalPosition).first;

            if (target is RenderRootNode) {
              context.invoke(intents.clearSelection());
            } else {
              context.invoke(intents.selectNode(target.node));
            }
          },
          child: Stack(
            children: [
              // Hover overlay
              ListenableBuilder(
                listenable: hoveringNodeSignal,
                builder: (context, _) {
                  final hoveringNode = hoveringNodeSignal.value;

                  return Transform(
                    transform: info.childPaintTransform,
                    child: HoverOverlayBuilder(
                      hoveringNode: hoveringNode,
                      child: const SizedBox.expand(),
                    ),
                  );
                },
              ),

              // Selection overlay
              ListenableBuilder(
                listenable: controller.selection,
                builder: (context, _) {
                  final selectionGroups = controller.selection.selectionGroups;

                  return Transform(
                    transform: info.childPaintTransform,
                    child: SelectionOverlayBuilder(
                      controller: controller,
                      selectionGroups: selectionGroups,
                      child: const SizedBox.expand(),
                    ),
                  );
                },
              ),

              // Marquee selection overlay
              ListenableBuilder(
                listenable: marqueeRectSignal,
                builder: (context, _) {
                  final marqueeRect = marqueeRectSignal.value;
                  if (marqueeRect == null) return const SizedBox.shrink();
                  return MarqueeOverlay(rect: marqueeRect);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
