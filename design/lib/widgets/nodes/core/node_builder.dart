part of '../_nodes.dart';

class NodeBuilder extends HookWidget {
  const NodeBuilder({super.key, required this.node, required this.builder});

  final Node node;
  final Widget Function(BuildContext context, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    return _NodeLayoutTransform(
      node: node,
      child: _NodeBuilderWidget(
        node: node,
        child: HookBuilder(
          builder: (context) => builder(
            context,
            _NodeChildLayoutWidget(node: node),
          ),
        ),
      ),
    );
  }
}

class _NodeChildLayoutWidget extends HookWidget {
  const _NodeChildLayoutWidget({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context) {
    final childLayout = useComputedValue(() => node.layout.childLayout);
    final children = useComputedValue(() => [...node.children]);

    final child = switch (childLayout) {
      StackNodeChildLayout s => _StackNodeChildLayoutWidget(layout: s, children: children),
      FlexNodeChildLayout f => _FlexNodeChildLayoutWidget(layout: f, children: children),
    };

    return child;
  }
}

class _StackNodeChildLayoutWidget extends StatelessWidget {
  const _StackNodeChildLayoutWidget({required this.layout, required this.children});

  final StackNodeChildLayout layout;
  final List<Node> children;

  Widget _buildChild(BuildContext context, Node c) {
    final controller = DesignController.of(context);

    return HookBuilder(
      builder: (context) {
        final key = controller.keyForNode(c);
        return NodeWidget(key: key, node: c);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverflowHitTestableStack(
      children: [
        for (final c in children) _buildChild(context, c),
      ],
    );
  }
}

class _FlexNodeChildLayoutWidget extends StatelessWidget {
  const _FlexNodeChildLayoutWidget({required this.layout, required this.children});

  final FlexNodeChildLayout layout;
  final List<Node> children;

  Widget _buildChild(BuildContext context, Node c) {
    final controller = DesignController.of(context);

    return HookBuilder(
      builder: (context) {
        final key = controller.keyForNode(c);
        final layoutSize = useComputedValue(() => c.layout.size);
        final dimension = switch (layout.direction) {
          .row => layoutSize.width,
          .column => layoutSize.height,
        };

        final child = NodeWidget(key: key, node: c);

        if (dimension.type == .expand) {
          return Expanded(child: child);
        } else {
          return child;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      mainAxisSize: .min,
      direction: switch (layout.direction) {
        .row => Axis.horizontal,
        .column => Axis.vertical,
      },
      spacing: layout.gap,
      children: [
        for (final c in children) _buildChild(context, c),
      ],
    );
  }
}

class _NodeBuilderWidget extends SingleChildRenderObjectWidget {
  const _NodeBuilderWidget({required super.child, required this.node});

  final Node node;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderNode(node: node);

  @override
  void updateRenderObject(BuildContext context, _RenderNode renderObject) {
    renderObject.node = node;
  }
}

class _RenderNode extends tree.RenderNode<Node> {
  _RenderNode({required super.node});

  bool get isChildrenTranslationIgnored => node.layout.childLayout.isChildrenTranslationIgnored;
}
