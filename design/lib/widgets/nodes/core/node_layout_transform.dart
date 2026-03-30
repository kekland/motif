part of '../_nodes.dart';

int _debugColor = 0;
Color _debugGetColor() => Colors.primaries[(_debugColor++ % Colors.primaries.length)];
const _kDebugShowNodeBounds = false;

class _NodeLayoutTransform extends SingleChildRenderObjectWidget {
  const _NodeLayoutTransform({required this.node, super.child});

  final Node node;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderNodeLayoutTransform(node: node);

  @override
  void updateRenderObject(BuildContext context, covariant _RenderNodeLayoutTransform renderObject) {
    renderObject.node = node;
  }
}

class _RenderNodeLayoutTransform extends RenderProxyBox {
  _RenderNodeLayoutTransform({required Node node}) : _node = node {
    _setupEffect();
  }

  _RenderNode? _parentRenderNode;
  late Color _debugColor;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _parentRenderNode = findAncestorRenderObjectOfType<_RenderNode>();
    _debugColor = _debugGetColor();
  }

  late Node _node;
  Node get node => _node;
  set node(Node newNode) {
    if (_node != newNode) {
      _node = newNode;
      _setupEffect();
      markNeedsLayout();
    }
  }

  VoidCallback? _disposeEffect;
  void _setupEffect() {
    _disposeEffect?.call();
    _disposeEffect = effect(() {
      node.transform;
      node.layout;
      markNeedsLayout();
    });
  }

  @override
  void dispose() {
    _parentRenderNode = null;
    _disposeEffect?.call();
    super.dispose();
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(_effectiveTransform);
  }

  late Matrix4 _effectiveTransform;

  @override
  void performLayout() {
    child!.layout(_nodeConstraints, parentUsesSize: true);
    final childSize = child!.size;

    var transform = node.transform.value;
    final transformed = MatrixUtils.transformRect(transform, Offset.zero & childSize);
    size = constraints.constrain(transformed.size);

    if (_parentRenderNode?.isChildrenTranslationIgnored == true) {
      transform = Matrix4.copy(transform);
      transform[12] -= transformed.left;
      transform[13] -= transformed.top;
    }

    _effectiveTransform = transform;
  }

  BoxConstraints get _nodeConstraints {
    final size = node.layout.size;

    final (minWidth, maxWidth) = _dimensionConstraints(size.width, constraints.minWidth, constraints.maxWidth);
    final (minHeight, maxHeight) = _dimensionConstraints(size.height, constraints.minHeight, constraints.maxHeight);
    return BoxConstraints(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight);
  }

  (double, double) _dimensionConstraints(NodeLayoutDimension d, double min, double max) {
    if (d.type == .fixed) return (d.value!, d.value!);
    if (d.type == .contain) return (min, max);
    if (d.type == .expand) return (max, max);

    throw UnimplementedError('Unknown NodeLayoutDimensionType: ${d.type}');
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    layer = context.pushTransform(
      child!.needsCompositing,
      offset,
      _effectiveTransform,
      (context, offset) => context.paintChild(child!, offset),
      oldLayer: layer as TransformLayer?,
    );

    if (_kDebugShowNodeBounds) {
      final paint = Paint()
        ..color = _debugColor
        ..style = .stroke;

      final rect = MatrixUtils.transformRect(_effectiveTransform, Offset.zero & child!.size);
      context.canvas.drawRect(rect.shift(offset), paint);
    }
  }
}
