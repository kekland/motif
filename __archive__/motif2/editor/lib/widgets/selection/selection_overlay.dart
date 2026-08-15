import 'package:editor/imports.dart';

part 'selection_overlay_trailing.dart';


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
    this.onMove,
  });

  final Editor editor;
  final List<Set<SceneNode>> selectionGroups;
  final Matrix4 childPaintTransform;
  final DragActivity Function(List<SceneNode> nodes)? onMove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final group in selectionGroups)
          ObjectSelectionGroupOverlay(
            nodes: group,
            editor: editor,
            childPaintTransform: childPaintTransform,
            onMove: onMove,
          ),
      ],
    );
  }
}

class ObjectSelectionGroupOverlay extends HookWidget {
  const ObjectSelectionGroupOverlay({
    super.key,
    required this.nodes,
    required this.editor,
    required this.childPaintTransform,
    this.onMove,
  });

  final Iterable<SceneNode> nodes;
  final Editor editor;
  final Matrix4 childPaintTransform;
  final DragActivity Function(List<SceneNode> nodes)? onMove;

  @override
  Widget build(BuildContext context) {
    const gesturePadding = 16.0;

    final nodesWithOwners = this.nodes.map((n) => n.owner ?? n);
    useNodeList(nodesWithOwners, aspect: .layout);

    final nodes = this.nodes.toList();

    Widget _buildSelectionControls({
      required Matrix4 transform,
      required Size layoutSize,
      required Size childSize,
    }) {
      final isZero = childSize.width == 0.0 && childSize.height == 0.0;
      return SelectionControls(
        key: ValueKey(this.nodes),
        transform: transform,
        layoutSize: layoutSize,
        onMove: onMove != null ? () => onMove!(nodes) : null,
        onEdgeResize: isZero ? null : (e) => ResizeNodesActivity.edge(editor, nodes: nodes, edge: e),
        onCornerResize: isZero ? null : (c) => ResizeNodesActivity.corner(editor, nodes: nodes, corner: c),
        onRotate: isZero ? null : (c) => RotateNodesActivity(editor, nodes: nodes, corner: c),
        padding: gesturePadding,
        childSize: childSize,
        trailing: SelectionOverlayTrailing(editor: editor, nodes: nodes),
      );
    }

    if (nodes.length == 1) {
      final node = nodes.single;
      final bbox = node.bbox;
      final nodeToScene = node.getPaintTransformTo(null);

      final Matrix4 totalTransform = childPaintTransform * (nodeToScene);
      totalTransform.translateByDouble(bbox.min.x, bbox.min.y, 0.0, 1.0);

      final transform = totalTransform.getWithNormalizedScale();

      final size = Size(bbox.width, bbox.height);
      final layoutSize = Size(size.width * totalTransform.scaleX, size.height * totalTransform.scaleY);

      return _buildSelectionControls(
        transform: transform,
        layoutSize: layoutSize,
        childSize: size,
      );
    } else {
      final bboxes = nodes
          .map((n) => (n.getPaintTransformTo(null), n.bbox))
          .map((t) => t.$1.transformAabb2(t.$2))
          .toList();

      final overlayRects = bboxes.map((b) => childPaintTransform.transformAabb2(b)).toList();
      final bbox = bboxes.bbox;
      final overlayBbox = overlayRects.bbox;

      return _buildSelectionControls(
        transform: .translationValues(overlayBbox.left, overlayBbox.top, 0.0),
        layoutSize: .new(overlayBbox.width, overlayBbox.height),
        childSize: .new(bbox.width, bbox.height),
      );
    }
  }
}
