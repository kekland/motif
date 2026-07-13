import 'package:vector/imports.dart';
import 'generators/select_generator_window.dart';

part 'properties_panel/add_modifier_window.dart';
part 'properties_panel/modifiers.dart';
part 'properties_panel/modifier.dart';

class PropertiesPanel extends HookWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);
    final selection = useListenable(controller.selection);

    if (selection.selected.isEmpty) {
      return const Center(
        child: Text('No selection'),
      );
    }

    final cells = selection.selected.whereType<Cell>().toList();
    if (cells.isEmpty) {
      return const Center(
        child: Text('No cells selected'),
      );
    }

    return ListView(
      children: [
        _Header(cells: cells),
        Divider(),
        _Modifiers(cell: cells.first),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    super.key,
    required this.cells,
  });

  final List<Cell> cells;

  @override
  Widget build(BuildContext context) {
    final cell = cells.first;

    return Subtitle(
      leading: Icons.edge(),
      child: Text('${cell.runtimeType} ${cell.id}'),
    );
  }
}
