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

    final selectedCells = selection.refs;
    final selectedStatements = selection.statements;

    if (selection.isEmpty) {
      return SingleChildScrollView(
        child: RootSelectionPanel(),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          CellPanel(refs: selectedCells.toList()),
          Divider(),
          StatementPanel(statements: selectedStatements.toList()),
        ],
      ),
    );
  }
}
