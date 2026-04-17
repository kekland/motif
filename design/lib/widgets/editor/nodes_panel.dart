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
                return NodeTile(
                  key: ValueKey(node),
                  controller: controller,
                  index: i,
                  node: node,
                );
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
  const NodeTile({
    super.key,
    required this.controller,
    required this.node,
    required this.index,
    this.depth = 0,
  });

  static const height = 36.0;
  static const indent = 12.0;

  final DesignController controller;
  final Node node;
  final int index;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final expansibleController = useExpansibleController();
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
        child: _NodeBody(
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
      bodyBuilder: (context, _) => CustomPaint(
        foregroundPainter: _NodeChildrenTreePainter(
          color: context.colors.inverse.withScaledAlpha(0.25),
          depth: depth,
        ),
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++)
              NodeTile(
                key: ValueKey(children[i]),
                controller: controller,
                node: children[i],
                depth: depth + 1,
                index: i,
              ),
          ],
        ),
      ),
    );

    return Stack(
      children: [
        Positioned(
          left: 0.0,
          right: 0.0,
          top: 0.0,
          height: 4.0,
          child: _NodeGapDragTarget(parent: node.parent!, index: index),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          height: 4.0,
          child: _NodeGapDragTarget(parent: node.parent!, index: index + 1),
        ),
        Positioned.fill(
          child: _NodeSubtreeDragTarget(node: node, child: Container()),
        ),
        Draggable(
          hitTestBehavior: .translucent,
          data: node,
          onDragStarted: () {
            print('drag started');
          },
          axis: .vertical,
          affinity: .vertical,
          feedback: SizedBox(),
          child: child,
        ),
      ],
    );
  }
}

class _NodeSubtreeDragTarget extends StatelessWidget {
  const _NodeSubtreeDragTarget({super.key, required this.node, required this.child});

  final Node node;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      hitTestBehavior: .translucent,
      onWillAcceptWithDetails: (details) {
        final draggedNode = details.data as Node;
        if (draggedNode == node || draggedNode.isAncestorOf(node)) return false;
        return true;
      },
      onAcceptWithDetails: (details) {
        final draggedNode = (details.data as MutableNode)..detach();
        final mutableNode = node as MutableNode;
        mutableNode.addChild(draggedNode);
      },
      builder: (context, candidateData, rejectedData) {
        if (candidateData.isEmpty) return child;

        return Container(
          foregroundDecoration: candidateData.isNotEmpty
              ? BoxDecoration(
                  border: Border.all(color: context.colors.accent.primary, width: 2.0),
                )
              : null,
          child: child,
        );
      },
    );
  }
}

class _NodeGapDragTarget extends StatelessWidget {
  const _NodeGapDragTarget({
    super.key,
    required this.parent,
    required this.index,
  });

  final int index;
  final Node parent;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      hitTestBehavior: .translucent,
      onWillAcceptWithDetails: (details) {
        final draggedNode = details.data as Node;
        if (draggedNode.isAncestorOf(parent)) return false;
        return true;
      },
      onAcceptWithDetails: (details) {
        final draggedNode = (details.data as MutableNode)..detach();
        final mutableParent = parent as MutableNode;
        mutableParent.insertChild(index, draggedNode);
      },
      builder: (context, candidateData, rejectedData) {
        if (candidateData.isEmpty) return SizedBox();

        return Container(
          color: context.colors.accent.primary,
        );
      },
    );
  }
}

class _NodeBody extends HookWidget {
  const _NodeBody({
    super.key,
    required this.node,
    required this.isSelected,
    required this.depth,
    this.trailing,
  });

  final Node node;
  final bool isSelected;
  final int depth;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final name = useComputedValue(() => node.name);
    final icon = switch (node) {
      ContainerNode() => Icons.container(),
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
              color: context.colors.inverse.withScaledAlpha(0.25),
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
            style: context.typography.caption2,
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

class _NodeChildrenTreePainter extends CustomPainter {
  _NodeChildrenTreePainter({required this.depth, required this.color});

  final int depth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const childHeight = NodeTile.height;
    const indent = NodeTile.indent;

    final localIndent = depth * indent;
    final paddingLeft = 12.0 + 4.0 + localIndent;

    canvas.drawLine(
      Offset(paddingLeft, 0.0),
      Offset(paddingLeft, size.height - childHeight / 2.0),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(_NodeChildrenTreePainter oldDelegate) => true;
}

class _NodeChildTreeBranchPainter extends CustomPainter {
  _NodeChildTreeBranchPainter({required this.color, required this.depth});

  final Color color;
  final int depth;

  @override
  void paint(Canvas canvas, Size size) {
    if (depth == 0) return;

    const indent = NodeTile.indent;
    final paddingLeft = (depth - 1) * indent + (indent / 2.0) - 2.0;

    canvas.drawLine(
      Offset(paddingLeft, 0.0),
      Offset(paddingLeft + 4.0, 0.0),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(_NodeChildTreeBranchPainter oldDelegate) => true;
}
