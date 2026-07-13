import '../../imports.dart';

class SelectionOverlayBuilder extends StatelessWidget {
  const SelectionOverlayBuilder({
    super.key,
    required this.controller,
    required this.child,
  });

  final VectorController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PersistentOverlayBuilder(
      builder: (context, info) => _SelectionOverlay(
        controller: controller,
        childPaintTransform: info.childPaintTransform,
      ),
      child: child,
    );
  }
}

class _SelectionOverlay extends HookWidget {
  const _SelectionOverlay({
    super.key,
    required this.controller,
    required this.childPaintTransform,
  });

  final VectorController controller;
  final Matrix4 childPaintTransform;

  @override
  Widget build(BuildContext context) {
    final selection = useListenable(controller.selection).selected;
    if (selection.isEmpty) return const SizedBox.shrink();
    useExistingSignalList(selection.map((s) => s()).toList());

    final min = Vector2(.infinity, .infinity);
    final max = Vector2(.negativeInfinity, .negativeInfinity);
    for (final s in selection) {
      final (mi, ma) = switch (s) {
        Vertex v => (v.position, v.position),
        Edge e => (e.bbox.min, e.bbox.max),
        CubicKnot2 k => (k.p, k.p),
        _ => throw UnimplementedError('SelectionOverlay: Unhandled selection type: $s'),
      };

      final _mi = childPaintTransform.transform3(Vector3(mi.x, mi.y, 0.0));
      final _ma = childPaintTransform.transform3(Vector3(ma.x, ma.y, 0.0));

      Vector2.min(min, _mi.xy, min);
      Vector2.max(max, _ma.xy, max);
    }

    final bbox = Aabb2.minMax(min, max);
    final rect = Rect.fromPoints(bbox.min.offset, bbox.max.offset);

    late final Widget? trailing;

    if (!rect.size.isEmpty) {
      trailing = Button(
        onTap: () {
          final manager = controller.symbolManager;
          final cells = selection.whereType<Cell>().toList();
          final geometry = GeometrySymbol.from(cells: cells);
          manager.addSymbol(geometry);
        },
        leading: Icons.add(),
        child: Text('Symbol'),
      );
    } else {
      trailing = null;
    }

    return Stack(
      children: [
        SelectionControls(
          layoutSize: rect.size,
          transform: Matrix4.translationValues(rect.left, rect.top, 0.0),
          trailing: trailing,
        ),
      ],
    );
  }
}
