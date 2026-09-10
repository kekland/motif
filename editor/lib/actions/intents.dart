part of 'actions.dart';

final intents = (
  selectRef: SelectRefIntent.new,
  selectAll: SelectAllIntent.new,
  clearSelection: ClearSelectionIntent.new,
  undo: UndoIntent.new,
  redo: RedoIntent.new,
  deleteSelection: DeleteSelectionIntent.new,
  copySelection: CopySelectionIntent.new,
  paste: PasteIntent.new,
  selectTool: SelectToolIntent.new,
);

final class const SelectRefIntent(final Ref ref) extends Intent;
final class const SelectAllIntent() extends Intent;
final class const ClearSelectionIntent() extends Intent;
final class const UndoIntent() extends Intent;
final class const RedoIntent() extends Intent;
final class const DeleteSelectionIntent() extends Intent;
final class const CopySelectionIntent() extends Intent;
final class const PasteIntent() extends Intent;
