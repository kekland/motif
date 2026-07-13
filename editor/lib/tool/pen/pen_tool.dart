import 'package:editor/imports.dart';

class PenTool extends Tool {
  const PenTool();

  @override
  String get key => 'pen';

  @override
  Widget buildIcon(BuildContext context) => Icons.pen();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _PenToolOverlay(info: info);
}

class _PenToolOverlay extends HookWidget {
  const _PenToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final editor = Editor.watch(context);
    final hoveredCell = useState<Cell?>(null);

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: switch(hoveredCell.value) {
        Vertex() => Cursors.toolPenVertex,
        Edge() => Cursors.toolPenEdge,
        _ => Cursors.precise,
      },
      child: Listener(
        behavior: .translucent,
        onPointerHover: (e) {
          final result = editor.hitTestScene(e.position);
          hoveredCell.value = result.cell?.node;
        },
      ),
    );
  }
}
