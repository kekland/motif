import 'dart:math';

import 'package:editor/imports.dart';
import 'package:editor/widgets/tree_panel/tree_panel_controller.dart';

class TreePanel extends HookWidget {
  const new({super.key});

  static const itemHeight = 36.0;
  static const depthPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final editor = context.editor;

    final tree = useListenable(editor.scene.tree);
    final selection = useListenable(editor.selection);
    final listKey = useMemoized(() => GlobalKey());
    final controller = useDisposable(() => SceneTreeController(editor, tree, selection, listKey, scrollController));
    useListenable(controller);

    void onTap(StatementId id) {
      if (context.keyboard.isCtrlPressed) {
        context.editor.selection.toggleStatement(id);
      } else if (context.keyboard.isShiftPressed) {
        final selectionRange = tree.rangeOf(selection.statements);
        final target = tree.indexOf(id);

        if (selectionRange != null && target != null) {
          final (start, end) = selectionRange;
          final range = (min(start, target), max(end, target));
          final statements = tree.nodesInRange(range.$1, range.$2).map((n) => n.id);
          context.editor.selection.setStatements(statements);
        } else {
          context.editor.selection.setStatement(id);
        }
      } else {
        context.editor.selection.setStatement(id);
      }
    }

    final nodes = controller.nodes;

    return Stack(
      clipBehavior: .hardEdge,
      children: [
        Scrollbar(
          controller: scrollController,
          child: ListView.builder(
            key: listKey,
            controller: scrollController,
            itemCount: nodes.length,
            padding: const .only(bottom: 32.0),
            findChildIndexCallback: (key) {
              final id = (key as ValueKey<StatementId>).value;
              return nodes.indexWhere((n) => n.statement.id == id);
            },
            itemBuilder: (context, index) {
              final node = nodes[index];
              final statement = node.statement;
              final isExpanded = controller.isExpanded(node.statement.id);

              final id = statement.id;
              final isSelected = selection.statements.contains(id);
              final isImplicitlySelected = !isSelected && selection.isImplicitlySelected(id);

              return SceneNodeDraggable(
                id: id,
                controller: controller,
                child: _SceneNodeWidget(
                  key: ValueKey(id),
                  node: node,
                  isExpanded: isExpanded,
                  isSelected: isSelected,
                  isImplicitlySelected: isImplicitlySelected,
                  onTap: () => onTap(id),
                  onToggleExpanded: () => controller.toggleExpanded(id),
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: SceneTreeDragAnchorWidget(controller: controller),
        ),
      ],
    );
  }
}

final class const _SceneNodeWidget({
  super.key,
  required final ObjectSceneNode node,
  required final bool isExpanded,
  required final bool isSelected,
  required final bool isImplicitlySelected,
  required final VoidCallback onTap,
  required final VoidCallback onToggleExpanded,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statement = node.statement;
    final hasChildren = node.children.isNotEmpty;

    return ListItem(
      height: TreePanel.itemHeight,
      onTap: onTap,
      leading: statement.resolveIcon(context),
      title: Text(statement.resolveName(context)),
      padding: .only(left: node.depth * TreePanel.depthPadding, right: 6.0),
      isSelected: isSelected || isImplicitlySelected,
      selectedColor: isImplicitlySelected ? context.colors.accent.tertiary : null,
      trailing: hasChildren
          ? IconButton.flat(
              onTap: onToggleExpanded,
              child: AnimatedRotation(
                duration: context.animations.effectFast.duration!,
                curve: context.animations.effectFast.curve!,
                turns: isExpanded ? 0.0 : 0.5,
                child: Icons.chevronUp(),
              ),
            )
          : null,
    );
  }
}
