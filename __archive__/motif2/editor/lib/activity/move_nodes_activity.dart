import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

/// An activity that is responsible for moving groups of nodes around the scene.
class MoveNodesActivity extends NodeGroupActivity with ExclusiveCursorDragActivity {
  MoveNodesActivity(
    super.editor, {
    required super.nodes,
    this._onStart,
    this._onEnd,
  });

  final VoidCallback? _onStart;
  final VoidCallback? _onEnd;

  late final SceneNode targetNode;

  @override
  MouseCursor get cursor => Cursors.toolMove;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    var didSetTargetNode = false;
    final hitTest = editor.hitTestScene(details.globalPosition.vec2);
    for (final entry in hitTest.nodes) {
      final node = entry.node;
      if (nodes.contains(node)) {
        targetNode = node.owner ?? node;
        didSetTargetNode = true;
        break;
      }
    }

    if (!didSetTargetNode) {
      targetNode = nodes.first.owner ?? nodes.first;
    }

    _onStart?.call();
  }

  MultiChildSceneObject _getParentAt(Vector2 globalPosition, {bool ignoreSiblings = false}) {
    final ignoring = {...nodes};
    if (ignoreSiblings) {
      ignoring.addAll(targetNode.parent!.children);
    }

    final result = editor.hitTestScene(globalPosition, ignore: ignoring.toList());

    for (final entry in result.nodes) {
      final node = entry.node;
      if (node is MultiChildSceneObject) return node;
    }

    return editor.scene.root;
  }

  void _performReparenting(MultiChildSceneObject newParent) {
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final targetGlobalTransform = initialGlobalTransforms[i];

      node.parent = newParent;
      node.applySnapshot(initialSnapshots[i]);

      final globalTransform = node.getTransformTo(null);
      final inverseGlobal = globalTransform.clone()..invert();

      final correction = inverseGlobal..multiply(targetGlobalTransform);
      node.applyTransform(correction);

      final (newGlobalTransform, newInverseGlobal) = computeTransformsFor(i);
      initialSnapshots[i] = node.snapshot();
      initialGlobalTransforms[i] = newGlobalTransform;
      initialInverseGlobalTransforms[i] = newInverseGlobal;

      node.transientTransform = null;
    }

    _didCollapseSelection = false;
  }

  var _didCollapseSelection = false;
  void _performReordering(int insertionIndex) {
    final parent = targetNode.parent! as ContainerObject;
    for (final node in nodes) node.detach();
    parent.insertChildren(insertionIndex, nodes);
  }

  List<double>? _cachedReorderingOffsets;
  List<double> _computeReorderingOffsets() {
    if (_cachedReorderingOffsets != null) return _cachedReorderingOffsets!;

    final parent = targetNode.parent! as ContainerObject;

    final childLayout = parent.childLayout as FlexContainerChildLayout;
    final direction = childLayout.direction;

    var draggedExtent = 0.0;
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final parentBbox = node.getTransformTo(node.parent).transformAabb2(node.bbox);
      draggedExtent += direction.main(parentBbox.width, parentBbox.height);
    }

    final bboxes = <Aabb2>[];
    for (var i = 0; i < parent.children.length; i++) {
      final child = parent.children[i];
      final bbox = child.getTransformTo(parent).transformAabb2(child.bbox);
      bboxes.add(bbox);
    }

    var cursor = direction.main(bboxes.first.left, bboxes.first.top);
    final offsets = <double>[];

    for (var i = 0; i < bboxes.length; i++) {
      final node = parent.children[i];
      final bbox = bboxes[i];
      if (nodes.contains(node)) continue;

      final extent = direction.main(bbox.width, bbox.height);
      final startBoundary = cursor + (draggedExtent / 2);
      final endBoundary = cursor + extent + (draggedExtent / 2);
      final boundary = (startBoundary + endBoundary) / 2;

      offsets.add(boundary);
      cursor += extent;
    }

    _cachedReorderingOffsets = offsets;
    return offsets;
  }

  Map<NodeId, Vector2>? _getChildCenters(SceneNode parent) {
    if (parent is! ContainerObject) return null;

    final map = <NodeId, Vector2>{};
    for (final child in parent.children) {
      map[child.id] = child.getTransformTo(parent).transformAabb2(child.bbox).center;
    }
    return map;
  }

  void _animateSiblingTransients(ContainerObject parent, Map<NodeId, Vector2> oldCenters) {
    final newCenters = _getChildCenters(parent)!;

    for (final node in parent.children) {
      if (nodes.contains(node)) continue;

      final oldCenter = oldCenters[node.id]!;
      final newCenter = newCenters[node.id]!;

      if (oldCenter != newCenter) {
        final delta = oldCenter - newCenter;
        editor.scene.transientTransforms.animate(
          node.id,
          from: .new(local: .translationValues(delta.x, delta.y, 0)),
          to: .new(local: .identity()),
        );
      }
    }
  }

  void _collapseSelection(ContainerObject parent) {
    if (_didCollapseSelection || nodes.length <= 1) return;
    if (parent.childLayout is! FlexContainerChildLayout) return;
    _didCollapseSelection = true;

    final targetIndex = nodes.indexOf(targetNode);

    final targetInitialGlobal = initialGlobalTransforms[targetIndex];
    final targetLayoutGlobal = targetNode.getTransformTo(null);

    final delta = targetInitialGlobal.getTranslation() - targetLayoutGlobal.getTranslation();
    final layoutToAnchor = Matrix4.translation(delta);

    for (var i = 0; i < nodes.length; i++) {
      if (i == targetIndex) continue;
      final node = nodes[i];
      final oldGlobal = initialGlobalTransforms[i];

      final nodeLayoutGlobal = node.getTransformTo(null);
      final newGlobal = layoutToAnchor.clone()..multiply(nodeLayoutGlobal);

      final correction = (nodeLayoutGlobal.clone()..invert())..multiply(newGlobal);
      node.applyTransform(correction);

      final (recomputedGlobal, recomputedInverse) = computeTransformsFor(i);
      initialSnapshots[i] = node.snapshot();
      initialGlobalTransforms[i] = recomputedGlobal;
      initialInverseGlobalTransforms[i] = recomputedInverse;

      final parentInverse = parent.getTransformTo(null)..invert();
      final nodeLocalInverse = parent.getTransformTo(node);

      final localTransient = parentInverse
        ..multiply(oldGlobal)
        ..multiply(nodeLocalInverse);

      editor.scene.transientTransforms.animate(
        node.id,
        from: .new(local: localTransient),
        to: .new(local: .identity()),
      );
    }
  }

  bool canReparent = true;
  bool canReorder = true;

  @override
  void onUpdate(DragUpdateDetails details) {
    final oldParent = targetNode.parent!;
    final parentUnderCursor = _getParentAt(details.globalPosition.vec2, ignoreSiblings: false);

    const canReparent = true;
    final canReorder = oldParent is ContainerObject && oldParent.childLayout is FlexContainerChildLayout;

    if (canReparent && parentUnderCursor != targetNode.parent) {
      final newParent = parentUnderCursor;

      final oldCenters = _getChildCenters(oldParent);
      final newCenters = _getChildCenters(newParent);

      _performReparenting(parentUnderCursor);

      if (oldParent is ContainerObject) {
        oldParent.relayout();
        if (oldCenters != null) _animateSiblingTransients(oldParent, oldCenters);
      }

      if (newParent is ContainerObject) {
        newParent.relayout();
        if (newCenters != null) _animateSiblingTransients(newParent, newCenters);
        _collapseSelection(newParent);
      }
    } else if (canReorder) {
      final parent = oldParent;
      final direction = (parent.childLayout as FlexContainerChildLayout).direction;

      final localParentPosition = targetNode.getPaintTransformTo(parent).transformAabb2(targetNode.bbox).center;
      final offset = direction.main(localParentPosition.x, localParentPosition.y);

      final reorderingOffsets = _computeReorderingOffsets();
      var insertionIndex = reorderingOffsets.indexWhere((o) => offset < o);
      if (insertionIndex == -1) insertionIndex = reorderingOffsets.length;

      var currentSlot = 0.0;
      for (final child in parent.children) {
        if (nodes.contains(child)) break;
        currentSlot++;
      }

      if (insertionIndex != currentSlot) {
        final oldCenters = _getChildCenters(parent);
        _performReordering(insertionIndex);

        parent.relayout();

        _animateSiblingTransients(parent, oldCenters!);
        _collapseSelection(parent);
      }
    }

    final startPosition = startDetails.globalPosition.vec2;
    final currentPosition = details.globalPosition.vec2;

    final sceneDelta = editor.globalToScene(currentPosition) - editor.globalToScene(startPosition);
    final translationTransform = Matrix4.translationValues(sceneDelta.x, sceneDelta.y, 0);

    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];

      final globalTransform = initialGlobalTransforms[i];
      final inverseGlobalTransform = initialInverseGlobalTransforms[i];

      final localTransform = inverseGlobalTransform.clone()
        ..multiply(translationTransform)
        ..multiply(globalTransform);

      node.applySnapshot(initialSnapshots[i]);

      if (node.isTransformControlled) {
        final global = translationTransform * globalTransform;
        node.transientTransform = node.transientTransform?.copyWith(global: global) ?? .new(global: global);
      } else {
        node.applyTransform(localTransform);
      }
    }

    super.onUpdate(details);
  }

  @override
  void onEnd(DragEndDetails? details) {
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      if (node.transientTransform?.global != null) {
        final global = node.transientTransform!.global!;
        node.transientTransform = null;

        final parentInverse = node.parent!.getTransformTo(null)..invert();
        final nodeLocalInverse = node.getTransformTo(node.parent)..invert();

        final localTransient = parentInverse
          ..multiply(global)
          ..multiply(nodeLocalInverse);

        editor.scene.transientTransforms.animate(
          node.id,
          from: .new(local: localTransient),
          to: .new(local: .identity()),
        );
      }
    }

    super.onEnd(details);
    _onEnd?.call();
  }
}
