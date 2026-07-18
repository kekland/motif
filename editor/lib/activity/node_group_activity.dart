import 'dart:math' as math;

import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

abstract class NodeGroupActivity extends DragActivity {
  NodeGroupActivity(this.editor, {required List<SceneNode> nodes}) : nodes = getTargetNodes(nodes);
  NodeGroupActivity.raw(this.editor, {required this.nodes});

  static List<SceneNode> getTargetNodes(List<SceneNode> nodes) {
    final targetNodes = <SceneNode>{};
    for (final node in nodes) {
      if (node.owner != null) {
        targetNodes.add(node.owner!);
      } else {
        if (node is Edge) {
          targetNodes.add(node.start);
          targetNodes.add(node.end);
        }

        targetNodes.add(node);
      }
    }

    return targetNodes.toList();
  }

  final Editor editor;
  final List<SceneNode> nodes;

  late final Aabb2 groupBbox;
  late final List<NodeSnapshot> initialSnapshots;
  late final List<Matrix4> initialGlobalTransforms;
  late final List<Matrix4> initialInverseGlobalTransforms;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    initialSnapshots = [];
    initialGlobalTransforms = [];
    initialInverseGlobalTransforms = [];

    var minX = double.infinity, minY = double.infinity;
    var maxX = double.negativeInfinity, maxY = double.negativeInfinity;

    for (final node in nodes) {
      initialSnapshots.add(node.snapshot());

      final globalTransform = node.getTransformTo(null);
      initialGlobalTransforms.add(globalTransform);

      final inverseGlobal = Matrix4.inverted(globalTransform);
      initialInverseGlobalTransforms.add(inverseGlobal);

      final globalBbox = globalTransform.transformAabb2(node.boundingBox);
      minX = math.min(minX, globalBbox.min.x);
      minY = math.min(minY, globalBbox.min.y);
      maxX = math.max(maxX, globalBbox.max.x);
      maxY = math.max(maxY, globalBbox.max.y);
    }

    groupBbox = Aabb2.minMax(.new(minX, minY), .new(maxX, maxY));
  }

  void forEachNode(
    void Function(
      int index,
      SceneNode node,
      NodeSnapshot snapshot,
      Matrix4 globalTransform,
      Matrix4 inverseGlobalTransform,
    )
    callback,
  ) {
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final snapshot = initialSnapshots[i];
      final globalTransform = initialGlobalTransforms[i];
      final inverseGlobalTransform = initialInverseGlobalTransforms[i];

      callback(i, node, snapshot, globalTransform, inverseGlobalTransform);
    }
  }

  void applyTransformToNodes(Matrix4 transform) {
    forEachNode((i, node, snapshot, globalTransform, inverseGlobalTransform) {
      final localTransform = inverseGlobalTransform.clone()
        ..multiply(transform)
        ..multiply(globalTransform);

      node.applySnapshot(snapshot);
      node.transformWith(localTransform);
    });
  }
}
