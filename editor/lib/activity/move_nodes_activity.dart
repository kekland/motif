import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

sealed class _NodeMover {
  _NodeMover(this.node);

  final SceneNode node;

  void onStart(PositionedGestureDetails details);
  void applyDelta(Vector2 delta);
}

class MoveNodesActivity extends DragActivity with ExclusiveCursorDragActivity {
  MoveNodesActivity({
    required this.editor,
    required this.nodes,
  });

  final Editor editor;
  final List<SceneNode> nodes;

  late final List<SceneNode> targetNodes;
  late final SceneObject targetObject;

  @override
  MouseCursor get cursor => Cursors.toolMove;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    // // Resolve the nodes to move.
    // final targetNodes = <SceneNode>{};
    // final nodesToProcess = <SceneNode>{};
    // nodesToProcess.addAll(nodes);

    // while (nodesToProcess.isNotEmpty) {
    //   final object = nodesToProcess.first;
    //   nodesToProcess.remove(object);

    //   if (object is Cell) {
    //     if (object.isOwned) {
    //       targetNodes.add(object.owner);
    //     } else {
    //       targetNodes.add(object);
    //     }
    //   } else {
    //     targetNodes.add(object);
    //   }
    // }

    // this.targetNodes = targetNodes.toList();

    // final hitTest = editor.hitTestScene(details.globalPosition);
    // for (final entry in hitTest.path) {
    //   if (targetNodes.contains(entry.object)) {
    //     targetObject = entry.object;
    //     break;
    //   }
    // }

    // print(targetObject);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final node = nodes.first;
    final renderNode = editor.getRenderNode(node);
    final transform = renderNode.getTransformTo(null);
    final inverseTransform = Matrix4.inverted(transform);
    final delta =
        MatrixUtils.transformPoint(inverseTransform, details.globalPosition) -
        MatrixUtils.transformPoint(inverseTransform, (lastUpdateDetails ?? startDetails).globalPosition);

    if (node is SceneObject) {
      node.transform = node.transform.translated(delta);
    }

    super.onUpdate(details);
  }
}
