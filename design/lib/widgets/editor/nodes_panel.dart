import 'package:design/imports.dart';

class NodesPanel extends HookWidget {
  const NodesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DesignController.of(context);
    final root = useListenable(controller.root);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 16.0, bottom: 4.0),
          child: Text('nodes', style: context.typography.caption3.tertiary),
        ),
        Flexible(
          child: ListView.custom(
            childrenDelegate: SliverChildBuilderDelegate(
              (context, i) {
                final node = root.children[i];
                return NodeTile(node: node);
              },
              childCount: root.children.length,
            ),
          ),
        ),
      ],
    );
  }
}

class NodeTile extends HookWidget {
  const NodeTile({super.key, required this.node, this.depth = 0});

  final Node node;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final expansibleController = useExpansibleController();
    final controller = DesignController.of(context);
    final isSelected = useComputed(() => controller.selection.isNodeSelected(node));
    final isSubtreeSelected = useComputed(() {
      if (isSelected.value) return false;
      final nodes = controller.selection.selectedNodes;
      return nodes.any((n) => n.isAncestorOf(node));
    });

    final children = useComputedValue(() => [...node.children]);

    final Color color;

    if (isSelected.value) {
      color = context.colors.accent.secondary;
    } else if (isSubtreeSelected.value) {
      color = context.colors.accent.tertiary;
    } else {
      color = context.colors.surface.primary.copyWithForeground(context.colors.display.secondary);
    }

    final name = useComputedValue(() => node.name);

    final icon = switch (node) {
      ContainerNode() => Icons.container(),
      // RectangleNode() => Icons.square(),
      // EllipseNode() => Icons.circle(),
      _ => Icons.circle(),
    };

    return Expansible(
      animationStyle: context.animations.effectFast,
      controller: expansibleController,
      headerBuilder: (context, animation) => GestureSurface(
        onTap: () => context.invoke(intents.selectNode(node)),
        height: 36.0,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        color: color,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: depth * 8.0),
            DefaultForegroundStyle(
              iconSize: 16.0,
              iconFill: isSelected.value ? 1.0 : 0.0,
              child: icon,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                name,
                style: context.typography.caption2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!node.isLeaf && node.children.isNotEmpty) ...[
              const SizedBox(width: 4.0),
              GestureSurface(
                onTap: () => expansibleController.toggle(),
                child: RotationTransition(
                  turns: animation.drive(Tween(begin: 0.0, end: 0.5)),
                  child: Icons.chevronLeft(size: 16.0),
                ),
              ),
            ],
          ],
        ),
      ),
      bodyBuilder: (context, _) => Column(
        children: [
          for (final child in children) NodeTile(node: child, depth: depth + 1),
        ],
      ),
    );
  }
}
