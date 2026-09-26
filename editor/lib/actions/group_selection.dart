part of '_intents.dart';

final class const GroupSelectionIntent() extends CommandIntent;

final groupSelectionIntentDescriptor = CommandIntentDescriptor<GroupSelectionIntent>(
  command: 'group-selection',
  build: (context, args) => .new(),
  resolveDescription: (context) => 'Group selected items',
  resolveShortcut: (context) => [PlatformSingleActivator(.keyG, control: true)],
);

class GroupSelectionAction extends CommandAction<GroupSelectionIntent> with CanvasFocusAction {
  @override
  final descriptor = groupSelectionIntentDescriptor;

  @override
  bool canInvoke(BuildContext context, GroupSelectionIntent intent) {
    final selection = context.editor.selection;
    return selection.isNotEmpty;
  }

  @override
  void performInvoke(BuildContext context, GroupSelectionIntent intent) {
    final result = context.editor.edit((txn) => txn.group(context.editor.selection.cells));
    if (result is ReparentSuccess) {
      final group = result.edit.created.first;
      context.editor.selection.setStatement(group.id);
    }
  }
}
