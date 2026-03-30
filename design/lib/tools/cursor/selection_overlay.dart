import 'dart:math' as math;

import 'package:design/imports.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:stack_mouse_cursor/stack_mouse_cursor.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

part 'selection/selection_controls.dart';
part 'selection/selection_handles.dart';
part 'selection/selection_size_info_box.dart';

class SelectionOverlayBuilder extends StatelessWidget {
  const SelectionOverlayBuilder({
    super.key,
    required this.controller,
    required this.selectionGroups,
    required this.child,
  });

  final SelectionController controller;
  final List<Set<Node>> selectionGroups;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PersistentOverlayBuilder(
      builder: (context, info) => SelectionOverlay(
        controller: controller,
        selectionGroups: selectionGroups,
        childPaintTransform: info.childPaintTransform,
      ),
      child: child,
    );
  }
}

class SelectionOverlay extends StatelessWidget {
  const SelectionOverlay({
    super.key,
    required this.controller,
    required this.selectionGroups,
    required this.childPaintTransform,
  });

  final SelectionController controller;
  final List<Set<Node>> selectionGroups;
  final Matrix4 childPaintTransform;

  @override
  Widget build(BuildContext context) {
    final root = controller.root;

    return Stack(
      children: [
        for (final group in selectionGroups)
          DeferredLayoutBuilder(
            targets: group.map((n) => root.getRenderNode(n)!).toList(),
            builder: (context, _) => SelectionGroupOverlay(
              controller: controller,
              nodes: group,
              childPaintTransform: childPaintTransform,
            ),
          ),
      ],
    );
  }
}

class SelectionGroupOverlay extends StatelessWidget {
  const SelectionGroupOverlay({
    super.key,
    required this.controller,
    required this.nodes,
    required this.childPaintTransform,
  });

  final Iterable<Node> nodes;
  final SelectionController controller;
  final Matrix4 childPaintTransform;

  @override
  Widget build(BuildContext context) {
    const gesturePadding = 16.0;
    final root = controller.root;

    // Gesture callbacks
    final isMutable = nodes.every((n) => n is MutableNode);
    final mn = isMutable ? nodes.toList().cast<MutableNode>() : null;

    final onMove = isMutable ? () => MoveNodesActivity(root: root, nodes: mn!) : null;
    final onEdgeResize = isMutable ? (e) => ResizeNodesActivity.edge(root: root, nodes: mn!, edge: e) : null;
    final onCornerResize = isMutable ? (c) => ResizeNodesActivity.corner(root: root, nodes: mn!, corner: c) : null;
    final onRotate = isMutable ? (c) => CornerRotateNodesActivity(root: root, nodes: mn!, corner: c) : null;

    Widget _buildSelectionControls({required Matrix4 transform, required Size layoutSize, required Size childSize}) {
      return SelectionControls(
        key: ValueKey(nodes),
        transform: transform,
        layoutSize: layoutSize,
        onMove: onMove,
        onEdgeResize: onEdgeResize,
        onCornerResize: onCornerResize,
        onRotate: onRotate,
        padding: gesturePadding,
        childSize: childSize,
      );
    }

    // If we have just a single node, we use the node's transform directly.
    if (nodes.length == 1) {
      final renderNode = root.getRenderNode(nodes.single);

      final Matrix4 totalTransform = childPaintTransform * renderNode!.getTransformTo(root);
      final (sx, sy) = (totalTransform.scaleX, totalTransform.scaleY);
      final size = Size(renderNode.size.width * sx, renderNode.size.height * sy);
      final transform = totalTransform.getWithNormalizedScale();

      return _buildSelectionControls(
        transform: transform,
        childSize: renderNode.size,
        layoutSize: size,
      );
    }
    // For multi-node selection, we use the bounding box of all the nodes in the group.
    else {
      final nodeRects = nodes
          .map((n) => root.getRenderNode(n)!)
          .map((n) => MatrixUtils.transformRect(n.getTransformTo(root), Offset.zero & n.size));

      final overlayNodeRects = nodeRects.map((n) => MatrixUtils.transformRect(childPaintTransform, n)).toList();

      final nodeBoundingBox = nodeRects.boundingBox;
      final overlayBoundingBox = overlayNodeRects.boundingBox;

      return _buildSelectionControls(
        transform: Matrix4.translationValues(overlayBoundingBox.left, overlayBoundingBox.top, 0.0),
        layoutSize: overlayBoundingBox.size,
        childSize: nodeBoundingBox.size,
      );
    }
  }
}
