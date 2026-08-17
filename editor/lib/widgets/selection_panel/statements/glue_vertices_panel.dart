import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/statement_panel.dart';

class const GlueVerticesPanel({
  super.key,
  required final StatementId id,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statement = context.editor.statement<GlueVerticesStatement>(id);

    return StatementPanelBase(
      id: id,
    );
  }
}
