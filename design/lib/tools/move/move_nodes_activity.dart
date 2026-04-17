import 'package:design/imports.dart';
import 'package:flutter/gestures.dart';

/// Moving nodes usually involves just projecting the global position into the parent's coordinate space and applying
/// that transformation to the node. Additionally, if the node (excluding dragged nodes) under the cursor changes during
/// the drag, we perform a reparenting operation.
///
/// For flex/grid layouts (translation of nodes is ignored), we need to support reordering of nodes.
///
/// So, the activity consists of three distinct parts:
/// - Reparenting
/// - Reordering (for supported layouts)
/// - Moving (either actual movement or transient transform)
class MoveNodesActivity extends NodeDragActivity with ExclusiveCursorDragActivity {
  MoveNodesActivity({required super.controller, required super.nodes});

  @override
  MouseCursor get cursor => Cursors.toolMove;

  late final MutableNode targetNode;
  late final List<Matrix4> initialNodeRootTransform;

  late MutableNode targetNodeParent;
  late RenderNode targetNodeRender;
  late RenderNode targetNodeParentRender;
  late NodeChildLayout targetNodeParentChildLayout;
  late bool canReparent;
  late bool canReorder;

  var isLayoutLocked = false;

  void _lockLayout() {
    isLayoutLocked = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => isLayoutLocked = false);
  }

  @override
  void onStart(PositionedGestureDetails details) {
    // First, sort the nodes by their index in the parent's children list.
    nodes.sort((a, b) {
      if (a.parent != b.parent) return 0;

      final aIndex = a.parent!.children.indexOf(a);
      final bIndex = b.parent!.children.indexOf(b);
      return aIndex.compareTo(bIndex);
    });

    super.onStart(details);
    _cachedReorderingOffsets = null;

    final hitTestResult = NodeHitTestResult();
    root.nodeHitTest(hitTestResult, position: root.globalToLocal(details.globalPosition));
    targetNode = hitTestResult.path.first.target.node as MutableNode;

    initialNodeRootTransform = renderNodes.map((n) => n.getTransformTo(root)).toList();
  }

  MutableNode _getParentAt(Offset globalPosition, {bool ignoreSiblings = false}) {
    final hitTestResult = NodeHitTestResult();
    final ignoring = {...renderNodes};
    if (ignoreSiblings) {
      ignoring.addAll(targetNode.parent!.children.map(root.getRenderNode).nonNulls);
    }

    root.nodeHitTest(hitTestResult, position: root.globalToLocal(globalPosition), ignoring: ignoring.toList());

    for (final entry in hitTestResult.path) {
      final node = entry.target.node;
      if (!node.isLeaf) return node as MutableNode;
    }

    return root.node as MutableNode;
  }

  void _performReparenting(MutableNode newParent) {
    _cachedReorderingOffsets = null;

    for (final node in nodes) {
      node.parent = newParent;
    }
  }

  List<double>? _cachedReorderingOffsets;
  List<double> _computeReorderingOffsets() {
    if (_cachedReorderingOffsets != null) return _cachedReorderingOffsets!;
    final direction = (targetNodeParentChildLayout as FlexNodeChildLayout).direction;

    // For each possible drop index, calculate where the node's center should be for the node to be dropped at that
    // index.
    //
    // First, compute the extent of the dragged nodes.
    var draggedExtent = 0.0;
    for (final node in nodes) {
      final renderNode = root.getRenderNode(node)!;
      final rect = MatrixUtils.transformRect(
        renderNode.getTransformTo(targetNodeParentRender),
        Offset.zero & renderNode.size,
      );

      draggedExtent += direction == .row ? rect.size.width : rect.size.height;
    }

    // Next up, keep track of the current position and "insert" our children into the layout.
    final rects = targetNodeParentRender.computeChildrenLayoutRects();
    var cursor = direction == .row ? rects[0].left : rects[0].top;
    final offsets = <double>[];

    for (var i = 0; i < targetNodeParent.children.length; i++) {
      final node = targetNodeParent.children[i];
      if (nodes.contains(node)) continue;

      final nodeExtent = direction == .row ? rects[i].size.width : rects[i].size.height;

      final startBoundary = cursor + (draggedExtent / 2);
      final endBoundary = cursor + nodeExtent + (draggedExtent / 2);
      final boundary = (startBoundary + endBoundary) / 2;
      offsets.add(boundary);

      cursor += nodeExtent;
    }

    _cachedReorderingOffsets = offsets;
    return offsets;
  }

  var _didCollapseSelection = false;
  void _collapseSelection() {
    if (_didCollapseSelection) return;
    _didCollapseSelection = true;

    // If the selection has more than one node, and if the nodes are non-consecutive children of the same parent, we
    // must collapse the nodes so that they become consecutive.
    if (nodes.length <= 1) return;

    // Get the nodes' extents
    final direction = (targetNodeParentChildLayout as FlexNodeChildLayout).direction;
    final extents = nodes.map((n) {
      final render = root.getRenderNode(n)!;
      final rect = MatrixUtils.transformRect(
        render.getTransformTo(targetNodeParentRender),
        Offset.zero & render.size,
      );

      return direction == .row ? rect.size.width : rect.size.height;
    }).toList();

    final targetIndex = nodes.indexOf(targetNode);
    final targetInitialTransform = initialNodeRootTransform[targetIndex];

    // Compute where the nodes should be moved to collapse into a single slot.
    final offsets = <double>[];
    var cursor = 0.0;
    for (final size in extents) {
      offsets.add(cursor);
      cursor += size;
    }

    // Apply the transforms to move the nodes to their new positions (with a local transient animation).
    final targetOffset = offsets[targetIndex];
    for (var i = 0; i < nodes.length; i++) {
      if (i == targetIndex) continue;

      final relativeShift = offsets[i] - targetOffset;
      final shiftTransform = Matrix4.translationValues(
        direction == .row ? relativeShift : 0.0,
        direction == .column ? relativeShift : 0.0,
        0.0,
      );

      final initial = initialNodeRootTransform[i];
      final newTransform = targetInitialTransform * shiftTransform;
      initialNodeRootTransform[i] = newTransform;

      final delta = initial * Matrix4.inverted(newTransform);
      controller.localTransientTransforms.animate(nodes[i], from: delta, to: Matrix4.identity());
    }
  }

  void _performReordering(int insertionIndex) {
    _collapseSelection();
    _cachedReorderingOffsets = null;

    for (final node in nodes) {
      node.detach();
    }

    for (var i = 0; i < nodes.length; i++) {
      targetNodeParent.insertChild(insertionIndex + i, nodes[i]);
    }
  }

  /// Animates the transient transforms for nodes that are potentially affected by reparenting or reordering.
  void _maybeAnimateTransients() {
    if (targetNodeParentChildLayout is FlexNodeChildLayout) {
      final sizes = <Node, double>{};
      final positions = <Node, double>{};
      final direction = (targetNodeParentChildLayout as FlexNodeChildLayout).direction;
      final rects = targetNodeParentRender.computeChildrenLayoutRects();
      if (rects.isEmpty) return;

      // [targetNodeParentRender.childrenNodes] will still contain the "old" nodes, so we can use it to collect layout
      // data.
      for (var i = 0; i < targetNodeParentRender.childrenNodes.length; i++) {
        final node = targetNodeParentRender.childrenNodes[i].node;
        final rect = rects[i];

        sizes[node] = direction == .row ? rect.size.width : rect.size.height;
        positions[node] = direction == .row ? rect.left : rect.top;
      }

      // If the node has been freshly added to the layout, it won't yet have a render node, so we need to compute its
      // size manually.
      for (final node in nodes) {
        if (sizes[node] != null) continue;
        final renderNode = root.getRenderNode(node);
        final rect = MatrixUtils.transformRect(
          renderNode!.getTransformTo(targetNodeParentRender),
          Offset.zero & renderNode.size,
        );

        sizes[node] = direction == .row ? rect.size.width : rect.size.height;
      }

      final firstNode = targetNodeParentRender.childrenNodes.first.node;
      final newPositions = <Node, double>{};
      var cursor = positions[firstNode]!;

      // [targetNodeParent.children] will have the new order of nodes, so we can use it to determine the new positions.
      for (final node in targetNodeParent.children) {
        newPositions[node] = cursor;
        cursor += sizes[node]!;
      }

      // Iterate over nodes and animate transients for nodes that changed position.
      for (final node in targetNodeParent.children) {
        if (nodes.contains(node)) {
          // If the node is being dragged, it already has a global transient applied.
          continue;
        }

        final oldPosition = positions[node]!;
        final newPosition = newPositions[node]!;
        final delta = oldPosition - newPosition;

        // If the node moved - animate it to its new position.
        if (delta != 0.0) {
          controller.localTransientTransforms.animate(
            node,
            from: Matrix4.translationValues(delta, 0.0, 0.0),
            to: Matrix4.identity(),
          );
        }
      }
    }
  }

  void _updateTargetInformation() {
    canReparent = true;
    targetNodeRender = targetNode.getRenderNode(root)!;
    targetNodeParent = targetNode.parent!;
    targetNodeParentRender = targetNodeParent.getRenderNode(root)!;
    targetNodeParentChildLayout = targetNodeParent.layout.childLayout;
    canReorder = targetNodeParentChildLayout is FlexNodeChildLayout;
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    _updateTargetInformation();

    // Reparenting
    final parentUnderCursor = _getParentAt(details.globalPosition, ignoreSiblings: canReorder);

    if (canReparent && parentUnderCursor != targetNode.parent && !isLayoutLocked) {
      _performReparenting(parentUnderCursor);
      _maybeAnimateTransients();
      _updateTargetInformation();
      _maybeAnimateTransients();
    }

    // Reordering
    if (canReorder && !isLayoutLocked) {
      final direction = (targetNodeParentChildLayout as FlexNodeChildLayout).direction;

      // Node's local position is its center.
      final localPosition = MatrixUtils.transformRect(
        targetNodeRender.getTransformTo(targetNodeParentRender),
        Offset.zero & targetNodeRender.size,
      ).center;

      final offset = direction == .row ? localPosition.dx : localPosition.dy;

      // Compute the reordering offsets and find the insertion index.
      final reorderingOffsets = _computeReorderingOffsets();
      var insertionIndex = reorderingOffsets.indexWhere((o) => offset < o);
      if (insertionIndex == -1) insertionIndex = reorderingOffsets.length;

      // Find our current index (including all dragged nodes).
      var currentSlot = 0;
      for (final child in targetNodeParent.children) {
        if (nodes.contains(child)) break;
        currentSlot++;
      }

      if (insertionIndex != currentSlot) {
        _performReordering(insertionIndex);
        _maybeAnimateTransients();
        _lockLayout();
      }
    }

    // Movement
    final delta =
        MatrixUtils.transformPoint(globalToRoot, details.globalPosition) -
        MatrixUtils.transformPoint(globalToRoot, startDetails.globalPosition);

    final translationTransform = Matrix4.translationValues(delta.dx, delta.dy, 0.0);

    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final initialNode = initialNodes[i];
      final parentRender = node.parent!.getRenderNode(root)!;

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

      // If translation is ignored, apply a global transient transform.
      if (node.parent!.layout.childLayout.isTranslationIgnored) {
        controller.globalTransientTransforms.apply(node, targetRootTransform);
      } else {
        controller.globalTransientTransforms.clear(node);
      }
    }

    super.onUpdate(details);
  }

  @override
  void onEnd(DragEndDetails? details) {
    for (final node in nodes) {
      final globalTransient = controller.globalTransientTransforms.get(node);

      // If there's a remaining global transient, collapse it into a local transient and animate back to identity.
      if (globalTransient != null) {
        controller.globalTransientTransforms.clear(node);

        final Matrix4 nodeToRoot = node.getRenderNode(root)!.getTransformTo(root);
        final Matrix4 localTransient = Matrix4.inverted(nodeToRoot) * globalTransient;
        controller.localTransientTransforms.animate(node, from: localTransient, to: Matrix4.identity());
      }
    }

    super.onEnd(details);
  }
}
