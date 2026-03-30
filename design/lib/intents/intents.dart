import 'package:design/imports.dart';

final intents = (
  selectNode: SelectNodeIntent.new,
  clearSelection: ClearSelectionIntent.new,
  deleteSelection: DeleteSelectionIntent.new,
  moveSelection: MoveSelectionIntent.new,
);

class SelectNodeIntent extends Intent {
  const SelectNodeIntent(this.node);

  final Node node;
}

class ClearSelectionIntent extends Intent {
  const ClearSelectionIntent();
}

class DeleteSelectionIntent extends Intent {
  const DeleteSelectionIntent();
}

class MoveSelectionIntent extends Intent {
  const MoveSelectionIntent(this.offset);

  final Offset offset;
}
