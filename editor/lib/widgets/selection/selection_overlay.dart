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

class ObjectSelectionGroupOverlay extends HookWidget {
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
    final nodes = this.nodes.toList();

    final stamp = useState(0);
    useEffect(() {
      return effect(() {
        for (final n in nodes) n().value;
        stamp.value += 1;
      });
    }, [nodes]);

    Widget _buildSelectionControls({required Matrix4 transform, required Size layoutSize, required Size childSize}) {
      return SelectionControls(
        key: ValueKey(this.nodes),
        transform: transform,
        layoutSize: layoutSize,
        onMove: () => MoveNodesActivity(editor, nodes: nodes),
        onEdgeResize: (e) => ResizeNodesActivity.edge(editor, nodes: nodes, edge: e),
        onCornerResize: (c) => ResizeNodesActivity.corner(editor, nodes: nodes, corner: c),
        onRotate: (c) => RotateNodesActivity(editor, nodes: nodes, corner: c),
        padding: gesturePadding,
        childSize: childSize,
      );
    }

    if (nodes.length == 1) {
      final node = nodes.single;
      final bbox = node.boundingBox;
      final nodeToScene = node.getTransformTo(null);

      final Matrix4 totalTransform = childPaintTransform * (nodeToScene);
      totalTransform.translateByDouble(bbox.min.x, bbox.min.y, 0.0, 1.0);

      final transform = totalTransform.getWithNormalizedScale();

      final size = Size(node.resolvedSize.width, node.resolvedSize.height);
      final layoutSize = Size(size.width * totalTransform.scaleX, size.height * totalTransform.scaleY);

      return _buildSelectionControls(
        transform: transform,
        layoutSize: layoutSize,
        childSize: size,
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
