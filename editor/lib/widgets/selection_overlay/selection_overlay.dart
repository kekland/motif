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
  final DragActivity Function(List<CellKey> nodes)? onMove;

  @override
  Widget build(BuildContext context) {
    final selection = editor.selection;
    useListenable(selection);

    final selectionGroups = [
      selection.cells.toSet(),
    ];

    return Stack(
      children: [
        for (final group in selectionGroups)
          CellSelectionGroupOverlay(
            cells: group,
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
    required this.cells,
    required this.editor,
    required this.childPaintTransform,
    this.onMove,
  });

  final Iterable<CellKey> cells;
  final Editor editor;
  final Matrix4 childPaintTransform;
  final DragActivity Function(List<CellKey> nodes)? onMove;

  @override
  Widget build(BuildContext context) {
    useListenable(editor.scene);
    const gesturePadding = 16.0;

    // final nodesWithOwners = this.nodes.map((n) => n.owner ?? n);
    // useNodeList(nodesWithOwners, aspect: .layout);

    final cells = this.cells.toList();
    if (cells.isEmpty) return const SizedBox.expand();

    Widget _buildSelectionControls({
      required Mat4 transform,
      required Size layoutSize,
      required Size childSize,
    }) {
      final isZero = childSize.width == 0.0 && childSize.height == 0.0;

      final onMove = this.onMove ?? (cells) => MoveActivity(editor, cells);

      return SelectionControls(
        key: ValueKey(editor.selection.stamp),
        transform: transform,
        layoutSize: layoutSize,
        onMove: () => onMove(cells),
        onSideResize: isZero ? null : (s) => ResizeActivity.side(editor, cells, side: s),
        onCornerResize: isZero ? null : (c) => ResizeActivity.corner(editor, cells, corner: c),
        onRotate: isZero ? null : (c) => RotateActivity(editor, cells, corner: c),
        padding: gesturePadding,
        childSize: childSize,
        // trailing: SelectionOverlayTrailing(editor: editor, nodes: nodes),
      );
    }

    if (cells.length == 1) {
      final cell = cells.single;
      final handle = editor.bundle.handle(cell)!;
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
      final handles = cells.map((c) => editor.bundle.handle(c)!).toList();
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
