import 'package:design/imports.dart';

import 'cursor/cursor_tool.dart';

export 'activities.dart';

const List<Tool> toolset = [CursorTool(), ContainerTool(), RectangleTool(), EllipseTool()];

class RectangleTool extends Tool {
  const RectangleTool();

  @override
  String get key => 'rectangle';

  @override
  Widget buildIcon(BuildContext context) => Icons.square();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      cursor: Cursors.toolRectangle,
      child: SizedBox.expand(),
    );
  }
}

class EllipseTool extends Tool {
  const EllipseTool();

  @override
  String get key => 'ellipse';

  @override
  Widget buildIcon(BuildContext context) => Icons.circle();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      cursor: Cursors.toolEllipse,
      child: SizedBox.expand(),
    );
  }
}

class ContainerTool extends Tool {
  const ContainerTool();

  @override
  String get key => 'container';

  @override
  Widget buildIcon(BuildContext context) => Icons.container();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      cursor: Cursors.toolContainer,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapUp: (details) {
          final controller = DesignController.of(context);

          // // Perform hit testing.
          final hitTestResult = NodeHitTestResult();
          final root = controller.renderRootNode;
          root.nodeHitTest(hitTestResult, position: root.globalToLocal(details.globalPosition));

          RenderNode? _targetNode;
          for (final entry in hitTestResult.path) {
            if (!entry.target.node.isLeaf) {
              _targetNode = entry.target;
              break;
            }
          }

          if (_targetNode == null) return;
          final position = _targetNode.globalToLocal(details.globalPosition);
          final node = MutableContainerNode(
            transform: .new(translation: position),
            layout: .fixed(100.0, 100.0),
          );

          (_targetNode.node as MutableNode).addChild(node);
        },
        child: SizedBox.expand(),
      ),
    );
  }
}
