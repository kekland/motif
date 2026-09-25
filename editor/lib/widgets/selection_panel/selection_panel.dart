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

    var selectedCells = selection.refSources.cells.toSet();
    final selectedStatements = selection.statements;

    if (selection.isEmpty) {
      return SingleChildScrollView(
        child: RootSelectionPanel(),
      );
    }

    for (final id in selectedStatements) {
      final statement = editor.statement(id);
      if (statement is VertexStatement ||
          statement is EdgeStatement ||
          statement is FaceStatement ||
          statement is ShapeStatement) {
        final products = editor.scene.productsOf(id);
        selectedCells.removeAll(products);
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (selectedCells.isNotEmpty) ...[
            CellPanel(refs: selectedCells.toList()),
            Divider(),
          ],
          StatementPanel(statementIds: selectedStatements.toList()),
        ],
      ),
    );
  }
}
