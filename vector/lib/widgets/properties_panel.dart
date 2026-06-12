import 'package:color/color.dart';
import 'package:color/widgets/color_input.dart';
import 'package:vector/imports.dart';

part 'properties/edge_properties.dart';

class PropertiesPanel extends HookWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.of(context);
    useListenable(controller.strokeProperties);

    final selectionController = controller.selection;
    final selectedCells = useComputedValue(() => [...selectionController.selectedObjects]);

    final strokeProperties = controller.strokeProperties;

    return Column(
      key: ValueKey(selectedCells),
      children: [
        Spacer(),
        Checkbox(
          value: strokeProperties.topological,
          onChanged: (value) => controller.strokeProperties.topological = value,
        ),
        const SizedBox(height: 8.0),
        ColorPicker(
          value: () => strokeProperties.color,
          onChanged: (c) => controller.strokeProperties.color = c,
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
