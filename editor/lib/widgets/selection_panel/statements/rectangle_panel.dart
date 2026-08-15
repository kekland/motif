import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/statement_panel.dart';

class const RectanglePanel({
  super.key,
  required final StatementId id,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statement = context.editor.statement<RectangleStatement>(id);

    return StatementPanelBase(
      id: id,
      children: [],
    );
  }
}
