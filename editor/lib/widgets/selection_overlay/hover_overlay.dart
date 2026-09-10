import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_overlay/cell_handles.dart';

class HoverOverlay extends StatelessWidget {
  const HoverOverlay({
    super.key,
    required this.ref,
    required this.childPaintTransform,
  });

  final Matrix4 childPaintTransform;
  final Ref? ref;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CellHandlesWidget(
        scene: context.editor.scene,
        paintTransform: childPaintTransform,
        primaryColor: context.colors.selection.primary,
        secondaryColor: context.colors.selection.secondary,
        refs: {?ref},
      ),
    );
  }
}
