part of 'actions.dart';

final intents = (
  selectCell: SelectCellIntent.new,
  clearSelection: ClearSelectionIntent.new,
  undo: UndoIntent.new,
  redo: RedoIntent.new,
);

class SelectCellIntent extends Intent {
  const SelectCellIntent(this.cell);
  final CellKey cell;
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
