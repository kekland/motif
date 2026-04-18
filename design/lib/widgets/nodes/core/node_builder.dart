part of '../_nodes.dart';

class NodeBuilder extends HookWidget {
  const NodeBuilder({
    super.key,
    required this.node,
    required this.builder,
    this.shape,
  });

  final Node node;
  final ShapeBorder? shape;
  final Widget Function(BuildContext context, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    final controller = DesignController.of(context);

    return _NodeLayoutTransform(
      node: node,
      localTransientTransformStream: controller.localTransientTransforms.streamFor(node),
      globalTransientTransformStream: controller.globalTransientTransforms.streamFor(node),
      child: _NodeBuilderWidget(
        node: node,
        shape: shape,
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
        final key = controller.globalKeyCache.getKeyForNode(c);
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
        final key = controller.globalKeyCache.getKeyForNode(c);
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
  const _NodeBuilderWidget({required super.child, required this.node, this.shape});

  final ShapeBorder? shape;
  final Node node;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderNode(
    node: node,
    shape: shape,
  );

  @override
  void updateRenderObject(BuildContext context, RenderNode renderObject) {
    renderObject.node = node;
    renderObject.shape = shape;
  }
}

class RenderNode extends tree.RenderNode<Node, RenderNode, RenderRootNode> {
  RenderNode({required super.node, ShapeBorder? shape}) : _shape = shape;

  ShapeBorder? _shape;
  ShapeBorder? get shape => _shape;
  set shape(ShapeBorder? value) {
    if (_shape == value) return;
    _shape = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    super.performLayout();
    _cachedChildrenLayoutRects = null;
  }

  bool get isChildrenTranslationIgnored => node.layout.childLayout.isTranslationIgnored;

  /// Returns a layout-only transform from this render object to the [target]. This means that any transient transforms
  /// (e.g. from dragging in a flex/grid layout) are not included in the resulting transform.
  ///
  /// The implementation is a copy of [RenderObject.getTransformTo] with the difference being that any transient
  /// transforms (coming from `_RenderNodeLayoutTransform`) are not included in the resulting transform.
  Matrix4 getLayoutTransformTo(RenderObject? target) {
    assert(attached);
    List<RenderObject>? fromPath;
    List<RenderObject>? toPath;

    RenderObject from = this;
    RenderObject to = target ?? owner!.rootNode!;

    while (!identical(from, to)) {
      final int fromDepth = from.depth;
      final int toDepth = to.depth;

      if (fromDepth >= toDepth) {
        final fromParent = from.parent ?? (throw FlutterError('$target and $this are not in the same render tree.'));
        (fromPath ??= <RenderObject>[this]).add(fromParent);
        from = fromParent;
      }
      if (fromDepth <= toDepth) {
        final toParent = to.parent ?? (throw FlutterError('$target and $this are not in the same render tree.'));
        assert(
          target != null,
          '$this has a depth that is less than or equal to ${owner?.rootNode}',
        );
        (toPath ??= <RenderObject>[target!]).add(toParent);
        to = toParent;
      }
    }

    // Addition: to ignore transient transforms from `_RenderNodeLayoutTransform`.
    void _applyTransform(RenderObject a, RenderObject child, Matrix4 transform) {
      if (a is _RenderNodeLayoutTransform) {
        a.applyLayoutTransform(child, transform);
      } else {
        a.applyPaintTransform(child, transform);
      }
    }

    Matrix4? fromTransform;
    if (fromPath != null) {
      assert(fromPath.length > 1);
      fromTransform = Matrix4.identity();
      final int lastIndex = target == null ? fromPath.length - 2 : fromPath.length - 1;
      for (var index = lastIndex; index > 0; index -= 1) {
        _applyTransform(fromPath[index], fromPath[index - 1], fromTransform);
      }
    }
    if (toPath == null) {
      return fromTransform ?? Matrix4.identity();
    }

    assert(toPath.length > 1);
    final toTransform = Matrix4.identity();
    for (int index = toPath.length - 1; index > 0; index -= 1) {
      _applyTransform(toPath[index], toPath[index - 1], toTransform);
    }
    if (toTransform.invert() == 0) {
      // If the matrix is singular then `invert()` doesn't do anything.
      return Matrix4.zero();
    }
    return (fromTransform?..multiply(toTransform)) ?? toTransform;
  }

  List<Rect>? _cachedChildrenLayoutRects;

  /// Computes a list of layout rects (i.e. without transient transforms) for the children of this render node.
  List<Rect> computeChildrenLayoutRects() {
    if (_cachedChildrenLayoutRects != null) return _cachedChildrenLayoutRects!;

    final result = <Rect>[];

    for (final node in childrenNodes) {
      final rect = MatrixUtils.transformRect(
        node.getLayoutTransformTo(this),
        Offset.zero & node.size,
      );

      result.add(rect);
    }

    _cachedChildrenLayoutRects = result;
    return result;
  }
}

extension GetRenderNodeExtension on Node {
  RenderNode? getRenderNode(RenderRootNode root) => root.getRenderNode(this);
}
