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
    useListenable(selection);

    var selectedCells = selection.refs.toSet();
    final selectedStatements = selection.statements;

    if (selection.isEmpty) {
      return SingleChildScrollView(
        child: RootSelectionPanel(),
      );
    }

    if (selectedStatements.length == 1) {
      final products = editor.scene.productsOf(selectedStatements.single);
      selectedCells.removeAll(products);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (selectedCells.isNotEmpty) ...[
            CellPanel(refs: selectedCells.toList()),
            Divider(),
          ],
          StatementPanel(statements: selectedStatements.toList()),
        ],
      ),
    );
  }
}
