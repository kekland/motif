import 'package:editor/imports.dart';
import 'package:editor/tools/fill/transient_face_widget.dart';

class FillTool extends Tool {
  const FillTool();

  @override
  String get key => 'fill';

  @override
  Widget buildIcon(BuildContext context) => Icons.fill();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _FillToolOverlay(info: info);
}

class _FillToolOverlay extends HookWidget {
  const _FillToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final selection = editor.selection;
    useListenable(selection);

    final hoveredRegion = useState<Region?>(null);

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: switch (hoveredRegion.value) {
        null => Cursors.precise,
        _ => Cursors.toolFill,
      },
      child: Listener(
        behavior: .translucent,
        onPointerHover: (e) {
          final bundle = editor.bundle;
          final result = bundle.arrangement.regionAt(editor.globalToScene(e.position));
          hoveredRegion.value = result;
        },
        onPointerDown: (e) {
          final region = hoveredRegion.value;
          if (region == null) return;

          final outer = region.outer.coedges.map((c) => editor.refOfHandle(c.edge)!).toList();
          final holes = <List<EdgeRef>>[];
          for (final hole in region.holes) {
            holes.add(hole.coedges.map((c) => editor.refOfHandle(c.edge)!).toList());
          }

          final statement = FaceStatement(outer, holes: holes);
          editor.edit((txn) => txn.insert(statement));
        },
        child: hoveredRegion.value != null
            ? IgnorePointer(
                child: TransientFaceWidget(
                  editor: editor,
                  region: hoveredRegion.value!,
                  childPaintTransform: info.childPaintTransform,
                ),
              )
            : null,
      ),
    );
  }
}
