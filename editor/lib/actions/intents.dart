part of 'actions.dart';

final intents = (
  selectCell: SelectCellIntent.new,
  clearSelection: ClearSelectionIntent.new,
  undo: UndoIntent.new,
  redo: RedoIntent.new,
  deleteSelection: DeleteSelectionIntent.new,
  copySelection: CopySelectionIntent.new,
  paste: PasteIntent.new,
  selectTool: SelectToolIntent.new,
);

class SelectCellIntent extends Intent {
  const SelectCellIntent(this.ref);
  final CellRef ref;
}

class ClearSelectionIntent extends Intent {
  const ClearSelectionIntent();
}

class UndoIntent extends Intent {
  const UndoIntent();
}

class RedoIntent extends Intent {
  const RedoIntent();
}

class DeleteSelectionIntent extends Intent {
  const DeleteSelectionIntent();
}

class CopySelectionIntent extends Intent {
  const CopySelectionIntent();
}

class PasteIntent extends Intent {
  const PasteIntent();
}
