import 'package:editor/imports.dart';

class ObjectSelectionOverlayBuilder extends StatelessWidget {
  const ObjectSelectionOverlayBuilder({
    super.key,
    required this.editor,
    required this.selectionGroups,
    required this.child,
  });

  final Editor editor;
  final List<Set<SceneNode>> selectionGroups;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PersistentOverlayBuilder(
      builder: (context, info) => ObjectSelectionOverlay(
        editor: editor,
        selectionGroups: selectionGroups,
        childPaintTransform: info.childPaintTransform,
      ),
      child: child,
    );
  }
}

class ObjectSelectionOverlay extends StatelessWidget {
  const ObjectSelectionOverlay({
    super.key,
    required this.editor,
    required this.selectionGroups,
    required this.childPaintTransform,
  });

  final Editor editor;
  final List<Set<SceneNode>> selectionGroups;
  final Matrix4 childPaintTransform;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final group in selectionGroups)
          ObjectSelectionGroupOverlay(
            nodes: group,
            editor: editor,
            childPaintTransform: childPaintTransform,
          ),
      ],
    );
  }
}

class ObjectSelectionGroupOverlay extends StatelessWidget {
  const ObjectSelectionGroupOverlay({
    super.key,
    required this.nodes,
    required this.editor,
    required this.childPaintTransform,
  });

  final Iterable<SceneNode> nodes;
  final Editor editor;
  final Matrix4 childPaintTransform;

  @override
  Widget build(BuildContext context) {
    const gesturePadding = 16.0;
    final root = editor.render;

    Widget _buildSelectionControls({required Matrix4 transform, required Size layoutSize, required Size childSize}) {
      return SelectionControls(
        key: ValueKey(nodes),
        transform: transform,
        layoutSize: layoutSize,
        // onMove: onMove,
        // onEdgeResize: onEdgeResize,
        // onCornerResize: onCornerResize,
        // onRotate: onRotate,
        padding: gesturePadding,
        childSize: childSize,
      );
    }

    if (nodes.length == 1) {
      final node = nodes.single;
      final bbox = node.boundingBox;
      final renderNode = editor.getRenderNode(node);

      final renderTransform = renderNode.getTransformTo(root);
      renderTransform.translateByDouble(bbox.min.x, bbox.min.y, 0.0, 1.0);

      final Matrix4 totalTransform = childPaintTransform * renderTransform;
      final rect = MatrixUtils.transformRect(totalTransform, Rect.fromPoints(bbox.min.offset, bbox.max.offset));
      final transform = totalTransform.getWithNormalizedScale();

      return _buildSelectionControls(
        transform: transform,
        layoutSize: rect.size,
        childSize: renderNode.size,
      );
    } else {
      final rects = nodes
          .map((n) => (editor.getRenderNode(n), n.boundingBox.asRect))
          .map((t) => MatrixUtils.transformRect(t.$1.getTransformTo(root), t.$2))
          .toList();

      final overlayRects = rects.map((r) => MatrixUtils.transformRect(childPaintTransform, r)).toList();
      final bbox = rects.boundingBox;
      final overlayBbox = overlayRects.boundingBox;

      return _buildSelectionControls(
        transform: .translationValues(overlayBbox.left, overlayBbox.top, 0.0),
        layoutSize: overlayBbox.size,
        childSize: bbox.size,
      );
    }
  }
}
