part of '_intents.dart';

final class const SelectPreviousIntent() extends Intent;
final class const SelectNextIntent() extends Intent;
final class const SelectFirstChildIntent() extends Intent;
final class const SelectParentIntent() extends Intent;
final class const ShowSelectionOnScreenIntent() extends Intent;

final selectPreviousIntentDescriptor = CommandIntentDescriptor<SelectPreviousIntent>(
  command: 'select-previous',
  build: (context, _) => const SelectPreviousIntent(),
  resolveDescription: (context) => 'Select the previous item',
  resolveShortcut: (context) => [PlatformSingleActivator(.tab, shift: true)],
);

final selectNextIntentDescriptor = CommandIntentDescriptor<SelectNextIntent>(
  command: 'select-next',
  build: (context, _) => const SelectNextIntent(),
  resolveDescription: (context) => 'Select the next item',
  resolveShortcut: (context) => [PlatformSingleActivator(.tab)],
);

final selectFirstChildIntentDescriptor = CommandIntentDescriptor<SelectFirstChildIntent>(
  command: 'select-first-child',
  build: (context, _) => const SelectFirstChildIntent(),
  resolveDescription: (context) => 'Select the first child of the current selection',
  resolveShortcut: (context) => [PlatformSingleActivator(.enter)],
);

final selectParentIntentDescriptor = CommandIntentDescriptor<SelectParentIntent>(
  command: 'select-parent',
  build: (context, _) => const SelectParentIntent(),
  resolveDescription: (context) => 'Select the parent of the current selection',
  resolveShortcut: (context) => [PlatformSingleActivator(.enter, shift: true)],
);

final showSelectionOnScreenIntentDescriptor = CommandIntentDescriptor<ShowSelectionOnScreenIntent>(
  command: 'show-selection-on-screen',
  build: (context, _) => const ShowSelectionOnScreenIntent(),
  resolveDescription: (context) => 'Show the current selection on screen',
);

final class SelectPreviousAction extends CommandAction<SelectPreviousIntent> {
  new() : super(selectPreviousIntentDescriptor);

  @override
  void performInvoke(BuildContext context, SelectPreviousIntent intent) {
    final selection = context.editor.selection;
    final tree = context.editor.scene.tree;

    final range = tree.rangeOf(selection.statements);
    if (range == null) {
      final last = tree.root.children.last;
      selection.setStatement(last.id);
    } else {
      final (start, end) = range;
      final endNode = tree.nodeOf(tree.flattened[end].id);
      if (endNode == null) return;

      if (start == end) {
        final prev = endNode.siblingPrev;
        if (prev != null) selection.setStatement(prev.id);
      } else {
        selection.setStatement(endNode.id);
      }
    }

    context.editor.canvasUtils.showSelection();
  }
}

final class SelectNextAction extends CommandAction<SelectNextIntent> {
  new() : super(selectNextIntentDescriptor);

  @override
  void performInvoke(BuildContext context, SelectNextIntent intent) {
    final selection = context.editor.selection;
    final tree = context.editor.scene.tree;

    final range = tree.rangeOf(selection.statements);
    if (range == null) {
      final first = tree.root.children.first;
      selection.setStatement(first.id);
    } else {
      final (start, end) = range;
      final startNode = tree.nodeOf(tree.flattened[start].id);
      if (startNode == null) return;

      if (start == end) {
        final next = startNode.siblingNext;
        if (next != null) selection.setStatement(next.id);
      } else {
        selection.setStatement(startNode.id);
      }
    }

    context.editor.canvasUtils.showSelection();
  }
}

final class SelectFirstChildAction extends CommandAction<SelectFirstChildIntent> {
  new() : super(selectFirstChildIntentDescriptor);

  @override
  void performInvoke(BuildContext context, SelectFirstChildIntent intent) {
    final selection = context.editor.selection;
    final tree = context.editor.scene.tree;
    if (selection.statements.length != 1) return;

    final node = tree.nodeOf(selection.statements.first);
    if (node == null || node.children.isEmpty) return;

    final firstChild = node.children.first;
    selection.setStatement(firstChild.id);
    context.editor.canvasUtils.showSelection();
  }
}

final class SelectParentAction extends CommandAction<SelectParentIntent> {
  new() : super(selectParentIntentDescriptor);

  @override
  void performInvoke(BuildContext context, SelectParentIntent intent) {
    final selection = context.editor.selection;
    final tree = context.editor.scene.tree;

    final nodes = selection.statements.map((id) => tree.nodeOf(id)?.parent).nonNulls.toSet();
    if (nodes.length != 1) return;

    final parent = nodes.first;
    if (parent is! ObjectSceneNode) return;
    selection.setStatement(parent.id);
    context.editor.canvasUtils.showSelection();
  }
}

final class ShowSelectionOnScreenAction extends CommandAction<ShowSelectionOnScreenIntent> {
  new() : super(showSelectionOnScreenIntentDescriptor);

  @override
  void performInvoke(BuildContext context, ShowSelectionOnScreenIntent intent) {
    context.editor.canvasUtils.showSelection();
  }
}
