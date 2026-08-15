part of 'actions.dart';

final intents = (
  selectNode: SelectNodeIntent.new,
  clearSelection: ClearSelectionIntent.new,
);

class SelectNodeIntent extends Intent {
  const SelectNodeIntent(this.node);
  final SceneNode node;
}

class ClearSelectionIntent extends Intent {
  const ClearSelectionIntent();
}