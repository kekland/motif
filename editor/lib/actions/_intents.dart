import 'package:editor/imports.dart';
import 'package:flutter/services.dart';

part 'select_ref.dart';
part 'select_statement.dart';
part 'select_all.dart';
part 'clear_selection.dart';
part 'undo.dart';
part 'redo.dart';
part 'delete_selection.dart';
part 'copy_selection.dart';
part 'paste.dart';
part 'set_z_order_top.dart';
part 'set_z_order_bottom.dart';
part 'glue_selected_vertices.dart';
part 'group_selection.dart';

final intents = (
  selectRef: SelectRefIntent.new,
  selectStatement: SelectStatementIntent.new,
  selectAll: SelectAllIntent.new,
  clearSelection: ClearSelectionIntent.new,
  undo: UndoIntent.new,
  redo: RedoIntent.new,
  deleteSelection: DeleteSelectionIntent.new,
  copySelection: CopySelectionIntent.new,
  paste: PasteIntent.new,
  selectTool: SelectToolIntent.new,
  setZOrderTop: SetZOrderTopIntent.new,
  setZOrderBottom: SetZOrderBottomIntent.new,
  glueSelectedVertices: GlueSelectedVerticesIntent.new,
  groupSelection: GroupSelectionIntent.new,
);

final actions = <Type, Action>{
  SelectRefIntent: SelectRefAction(),
  SelectStatementIntent: SelectStatementAction(),
  SelectAllIntent: SelectAllAction(),
  ClearSelectionIntent: ClearSelectionAction(),
  UndoIntent: UndoAction(),
  RedoIntent: RedoAction(),
  DeleteSelectionIntent: DeleteSelectionAction(),
  CopySelectionIntent: CopySelectionAction(),
  PasteIntent: PasteAction(),
  SetZOrderTopIntent: SetZOrderTopAction(),
  SetZOrderBottomIntent: SetZOrderBottomAction(),
  GlueSelectedVerticesIntent: GlueSelectedVerticesAction(),
  GroupSelectionIntent: GroupSelectionAction(),
};

Map<SingleActivator, Intent> buildShortcuts(BuildContext context) {
  final shortcuts = <SingleActivator, Intent>{};

  for (final action in actions.values) {
    if (action is! CommandAction) continue;

    final descriptor = action.descriptor;
    final shortcut = descriptor.resolveShortcut(context);
    if (shortcut.isEmpty) continue;

    final intent = descriptor.build(context, []);
    for (final s in shortcut) shortcuts[s] = intent;
  }

  return shortcuts;
}
