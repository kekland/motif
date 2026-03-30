import 'package:design/imports.dart';
import 'package:flutter/src/gestures/gesture_details.dart';

class MoveNodesActivity extends NodeDragActivity with ExclusiveCursorDragActivity {
  MoveNodesActivity({required super.root, required super.nodes});

  @override
  MouseCursor get cursor => Cursors.toolMove;

  late final Node targetNode;
  late final List<Matrix4> initialNodeRootTransform;

  MutableNode _getParentAt(Offset globalPosition) {
    final hitTestResult = NodeHitTestResult();
    root.nodeHitTest(hitTestResult, position: root.globalToLocal(globalPosition), ignoring: renderNodes);

    for (final entry in hitTestResult.path) {
      final node = entry.target.node;
      if (!node.isLeaf) return node as MutableNode;
    }

    return root.node as MutableNode;
  }

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final hitTestResult = NodeHitTestResult();
    root.nodeHitTest(hitTestResult, position: root.globalToLocal(details.globalPosition));
    targetNode = hitTestResult.path.first.target.node;

    initialNodeRootTransform = renderNodes.map((n) => n.getTransformTo(root)).toList();
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final currentParent = _getParentAt(details.globalPosition);
    if (currentParent != targetNode.parent) {
      for (final node in nodes) {
        node.parent = currentParent;
      }
    }

    final delta =
        MatrixUtils.transformPoint(globalToRoot, details.globalPosition) -
        MatrixUtils.transformPoint(globalToRoot, startDetails.globalPosition);

    final translationTransform = Matrix4.translationValues(delta.dx, delta.dy, 0.0);

    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final initialNode = initialNodes[i];
      final parentRender = root.getRenderNode(node.parent!)!;

      final initialRootTransform = initialNodeRootTransform[i];
      final Matrix4 targetRootTransform = translationTransform * initialRootTransform;
      final Matrix4 newTransform = Matrix4.inverted(parentRender.getTransformTo(root)) * targetRootTransform;

      if (snapToPixelGrid) {
        final translation = newTransform.getTranslation();
        newTransform.setTranslationRaw(
          translation.x.roundToDouble(),
          translation.y.roundToDouble(),
          translation.z.roundToDouble(),
        );
      }

      node.transform = initialNode.transform.copyWith(value: newTransform);
    }

    super.onUpdate(details);
  }
}
