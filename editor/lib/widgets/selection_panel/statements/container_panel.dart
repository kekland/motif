import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/properties/child_layout_property.dart';
import 'package:editor/widgets/selection_panel/properties/size_property.dart';
import 'package:editor/widgets/selection_panel/properties/transform_property.dart';
import 'package:editor/widgets/selection_panel/statement_panel.dart';
import 'package:editor/widgets/selection_panel/widgets.dart';

class const ContainerPanel({
  super.key,
  required final StatementId id,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final statement = editor.statement<ContainerStatement>(id);
    final layout = editor.scene.layout.of(id);

    void apply(ContainerStatement newStatement) {
      return editor.edit((txn) {
        txn.replace(id, [newStatement]);
      });
    }

    return StatementPanelBase(
      id: id,
      child: PropertiesBody(
        children: [
          PropertiesSection(
            title: Text('Transform'),
            children: [
              TransformComponentWidget(
                transform: statement.transform,
                overridePosition: layout?.offset,
                onPositionChanged: (p) {
                  final s = TransformSession.statement(editor.scene, id);
                  s.setTranslation(p);
                },
                onRotationChanged: (r) {
                  final s = TransformSession.statement(editor.scene, id);
                  s.setRotation(r);
                },
              ),
            ],
          ),
          PropertiesSection(
            title: Text('Layout'),
            children: [
              SizeComponentWidget(
                size: statement.size,
                resolvedSize: layout?.size,
                onChanged: (s) => apply(statement.copyWith(size: s)),
              ),
              ChildLayoutComponentWidget(
                childLayout: statement.childLayout,
                onChanged: (l) => apply(statement.copyWith(childLayout: l)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
