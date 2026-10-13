import 'package:blueprint/editor.dart';
import 'package:blueprint/editor/actions/actions.dart';
import 'package:ui/ui.dart';

class EditorCanvas extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = useListenable(BlueprintEditor.watch(context));
    final focusScopeNode = useFocusScopeNode();
    final marqueeValue = useValueNotifier<MarqueeValue?>(null);

    final children = <Widget>[];

    for (final node in editor.nodes) {
      children.add(NodeWidget(key: ValueKey(node.id), editor: editor, id: node.id));
    }

    Widget child = InteractiveCanvasFocus(
      focusScopeNode: focusScopeNode,
      child: InteractiveCanvas(
        key: editor.canvasKey,
        transformationController: editor.canvasTransformationController,
        backgroundColor: context.colors.surface.primary,
        onPointerPositionChanged: editor.onPointerPositionChanged,
        child: ConnectionsWidget(
          key: editor.renderKey,
          editor: editor,
          child: OverflowHitTestableStack(
            clipBehavior: .none,
            children: children,
          ),
        ),
      ),
    );

    child = Stack(
      fit: .expand,
      children: [
        Listener(
          behavior: .translucent,
          onPointerDown: (e) {
            final nodeHitTest = editor.hitTestNodes(e.position);
            if (nodeHitTest.isNotEmpty) {
              final id = nodeHitTest.first.node.id;
              if (!editor.selection.isNodeSelected(id)) context.invoke(intents.selectNode(id));
              return;
            }

            final hitTestConnections = editor.hitTestConnections(e.position);
            if (hitTestConnections.isNotEmpty) {
              context.invoke(intents.selectConnection(hitTestConnections.first.connection));
              return;
            }

            context.invoke(intents.clearSelection());
          },
          child: DragActivityDetector(
            behavior: .translucent,
            activityFactory: (e) {
              final socketHitTest = editor.hitTestSockets(e.position);
              if (socketHitTest.isNotEmpty) {
                return ConnectSocketActivity(editor: editor, socket: socketHitTest.first.socket);
              }

              final nodeHitTest = editor.hitTestNodes(e.position);
              if (nodeHitTest.isNotEmpty) {
                return MoveSelectedNodesActivity(editor: editor);
              }

              return MarqueeActivity(
                onLocalRectChanged: (v) => marqueeValue.value = v,
                onGlobalRectChanged: (v) => v != null ? editor.selection.handleMarquee(v) : null,
                onEnd: () => marqueeValue.value = null,
                onCancel: () => marqueeValue.value = null,
              );
            },
            child: child,
          ),
        ),
        MarqueeOverlayBuilder(value: marqueeValue),
      ],
    );

    return child;
  }
}
