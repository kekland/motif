part of '_nodes.dart';

class RootNodeWidget extends HookWidget {
  const RootNodeWidget({super.key, required this.node});

  final RootNode node;

  @override
  Widget build(BuildContext context) {
    final children = useComputedValue(() => [...node.children]);

    return _RootNodeWidget(
      node: node,
      child: _StackNodeChildLayoutWidget(
        layout: .new(),
        children: children,
      ),
    );
  }
}

class _RootNodeWidget extends SingleChildRenderObjectWidget {
  const _RootNodeWidget({required this.node, required super.child});

  final RootNode node;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final renderRootNode = RenderRootNode(node: node);

    final controller = DesignController.of(context);
    controller.onRootNodeCreated(renderRootNode);

    return renderRootNode;
  }

  @override
  void updateRenderObject(BuildContext context, RenderRootNode renderObject) {
    renderObject.node = node;
  }
}

class RenderRootNode extends RenderNode with tree.RenderRootNodeBase<Node, RenderNode, RenderRootNode> {
  RenderRootNode({required super.node});
}
