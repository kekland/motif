part of 'scene_tree_panel.dart';

class NodeTile extends HookWidget {
  const NodeTile({
    super.key,
    required this.editor,
    required this.node,
    required this.index,
    this.depth = 0,
  });

  static List<SceneNode> childrenToDisplay(SceneNode object, Set<SceneNode> selection) {
    return object.children.where((o) {
      // if (o is Cell && o.isOwned) return selection.contains(o);
      return true;
    }).toList();
  }

  static const height = 32.0;
  static const indent = 8.0;

  final Editor editor;
  final SceneNode node;
  final int index;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final node = useNode(this.node, aspect: .children);
    final expansibleController = useExpansibleController();
    final isSelected = useComputed(() => editor.selection.isSelected(node));
    final isSubtreeSelected = useComputed(() {
      if (isSelected.value) return false;
      final nodes = editor.selection.nodes;
      return nodes.any((n) => n.isAncestorOf(node));
    });
    final children = childrenToDisplay(node, {});

    final Color color;

    if (isSelected.value) {
      color = context.colors.accent.secondary;
    } else if (isSubtreeSelected.value) {
      color = context.colors.accent.tertiary;
    } else {
      color = context.colors.surface.primary;
    }

    final child = Expansible(
      animationStyle: context.animations.effectFast,
      controller: expansibleController,
      headerBuilder: (context, animation) => GestureSurface(
        behavior: .translucent,
        onTap: () => context.invoke(intents.selectNode(node)),
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        color: color,
        child: _NodeTileBody(
          node: node,
          isSelected: isSelected.value,
          depth: depth,
          trailing: children.isNotEmpty
              ? GestureSurface(
                  onTap: () => expansibleController.toggle(),
                  child: RotationTransition(
                    turns: animation.drive(Tween(begin: 0.75, end: 0.25)),
                    child: Icons.chevronLeft(size: 16.0),
                  ),
                )
              : null,
        ),
      ),
      bodyBuilder: (context, animation) => AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final shouldDisplay = animation.value > 0.0;
          return CustomPaint(
            foregroundPainter: _NodeChildrenTreePainter(
              color: context.colors.divider,
              depth: depth,
            ),
            child: Column(
              children: [
                if (shouldDisplay)
                  for (var i = 0; i < children.length; i++)
                    NodeTile(
                      key: ValueKey(children[i].id),
                      editor: editor,
                      node: children[i],
                      depth: depth + 1,
                      index: i,
                    ),
              ],
            ),
          );
        },
      ),
    );

    return Stack(
      children: [
        Positioned(
          left: 0.0,
          right: 0.0,
          top: 0.0,
          height: 4.0,
          child: _ObjectGapDragTarget(parent: node.parent!, index: index),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          height: 4.0,
          child: _ObjectGapDragTarget(parent: node.parent!, index: index + 1),
        ),
        Positioned.fill(
          child: _ObjectSubtreeDragTarget(object: node, child: Container()),
        ),
        Draggable(
          hitTestBehavior: .translucent,
          data: node,
          onDragStarted: () {},
          axis: .vertical,
          affinity: .vertical,
          feedback: SizedBox(),
          child: child,
        ),
      ],
    );
  }
}

class _NodeTileBody extends HookWidget {
  const _NodeTileBody({
    super.key,
    required this.node,
    required this.isSelected,
    required this.depth,
    this.trailing,
  });

  final SceneNode node;
  final bool isSelected;
  final int depth;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final node = useNode(this.node, aspect: .name);

    final name = node.name;
    final icon = switch (node) {
      RectangleObject() => Icons.square(),
      ContainerObject() => Icons.container(),
      Vertex() => Icons.vertex(),
      Edge() => Icons.edge(),
      _ => Icons.circle(),
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: depth * NodeTile.indent,
          height: 1.0,
          child: CustomPaint(
            painter: _NodeChildTreeBranchPainter(
              depth: depth,
              color: context.colors.divider,
            ),
          ),
        ),
        DefaultForegroundStyle(
          iconSize: 16.0,
          iconFill: isSelected ? 1.0 : 0.0,
          child: icon,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            name,
            style: context.typography.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 4.0),
          trailing!,
        ],
      ],
    );
  }
}
