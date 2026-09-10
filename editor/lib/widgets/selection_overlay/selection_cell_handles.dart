import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_overlay/cell_handles.dart';

class SelectionCellHandles extends StatelessWidget {
  const SelectionCellHandles({
    super.key,
    required this.refs,
    required this.childPaintTransform,
  });

  final Matrix4 childPaintTransform;
  final Set<Ref> refs;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CellHandlesWidget(
        scene: context.editor.scene,
        paintTransform: childPaintTransform,
        primaryColor: context.colors.selection.primary,
        secondaryColor: context.colors.selection.secondary,
        refs: refs,
      ),
    );
  }
}
