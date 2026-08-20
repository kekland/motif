import 'package:editor/imports.dart';

class CellSelectionOverlay extends HookWidget {
  const CellSelectionOverlay({
    super.key,
    required this.editor,
    required this.childPaintTransform,
    this.onMove,
  });

  final Editor editor;
  final Matrix4 childPaintTransform;
  final DragActivity Function(List<Ref> refs)? onMove;

  @override
  Widget build(BuildContext context) {
    final selection = editor.selection;
    useListenable(selection);

    final selectionGroups = [
      selection.refs.toSet(),
    ];

    return Stack(
      children: [
        for (final group in selectionGroups)
          CellSelectionGroupOverlay(
            refs: group,
            editor: editor,
            childPaintTransform: childPaintTransform,
            onMove: onMove,
          ),
      ],
    );
  }
}

class CellSelectionGroupOverlay extends HookWidget {
  const CellSelectionGroupOverlay({
    super.key,
    required this.refs,
    required this.editor,
    required this.childPaintTransform,
    this.onMove,
  });

  final Iterable<Ref> refs;
  final Editor editor;
  final Matrix4 childPaintTransform;
  final DragActivity Function(List<Ref> nodes)? onMove;

  @override
  Widget build(BuildContext context) {
    useListenable(editor.scene);
    const gesturePadding = 16.0;

    // final nodesWithOwners = this.nodes.map((n) => n.owner ?? n);
    // useNodeList(nodesWithOwners, aspect: .layout);

    final refs = this.refs.toList();
    if (refs.isEmpty) return const SizedBox.expand();

    final handles = refs.map((r) => editor.handleOf(r)).nonNulls.toList();
    if (handles.isEmpty) return const SizedBox.expand();

    Widget _buildSelectionControls({
      required Mat4 transform,
      required Size layoutSize,
      required Size childSize,
    }) {
      final isZero = childSize.width == 0.0 && childSize.height == 0.0;

      final onMove = this.onMove ?? (refs) => MoveActivity(editor, refs);

      return SelectionControls(
        key: ValueKey(editor.selection.stamp),
        transform: transform,
        layoutSize: layoutSize,
        onMove: () => onMove(refs),
        onSideResize: isZero ? null : (s) => ResizeActivity.side(editor, refs, side: s),
        onCornerResize: isZero ? null : (c) => ResizeActivity.corner(editor, refs, corner: c),
        onRotate: isZero ? null : (c) => RotateActivity(editor, refs, corner: c),
        padding: gesturePadding,
        childSize: childSize,
        // trailing: SelectionOverlayTrailing(editor: editor, nodes: nodes),
      );
    }

    if (handles.length == 1) {
      final handle = handles.single;
      final bbox = editor.bundle.query.cellBbox(handle);
      final cellTransform = editor.bundle.cellWorldTransform(handle);

      final totalTransform = Mat4.viewFloat64(childPaintTransform.storage) * cellTransform;
      totalTransform.translate(bbox.min.x, bbox.min.y);

      final transform = totalTransform.withNormalizedScale();

      final size = Size(bbox.width, bbox.height);
      final layoutSize = Size(size.width * totalTransform.scaleX, size.height * totalTransform.scaleY);

      return _buildSelectionControls(
        transform: transform,
        layoutSize: layoutSize,
        childSize: size,
      );
    } else {
      final bboxes = handles.map((h) => editor.bundle.query.cellBboxWorld(h)).toList();

      final hull = Aabb2.invertedInfinity();
      for (final bbox in bboxes) hull.hull(bbox);

      final overlayHull = hull.transformed(Mat4.viewFloat64(childPaintTransform.storage));

      return _buildSelectionControls(
        transform: .translation2(overlayHull.min),
        layoutSize: .new(overlayHull.width, overlayHull.height),
        childSize: .new(hull.width, hull.height),
      );
    }
  }
}
