import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/root_panel.dart';

import 'cell_panel.dart';
import 'statement_panel.dart';

class SelectionPanel extends HookWidget {
  const SelectionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final selection = editor.selection;
    // useListenable(editor.scene);
    useListenable(selection);

    final selectedCells = selection.cells;

    if (selection.isEmpty) {
      return SingleChildScrollView(
        child: RootSelectionPanel(),
      );
    }

    if (selectedCells.length == 1) {
      final cell = selectedCells.first;
      final ref = editor.scene.refOf(cell)!;

      return SingleChildScrollView(
        child: Column(
          children: [
            // Text(
            //   'Selected Cells: ${selectedCells.toList()}',
            // ),
            CellPanel(cellKey: cell),
            Divider(),
            StatementPanel(id: ref.statement),
          ],
        ),
      );
    }

    return Column(
      children: [
        Text(
          'Selected Cells: ${selectedCells.toList()}',
        ),
      ],
    );
  }
}
