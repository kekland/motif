part of '../_nodes.dart';

int _debugColor = 0;
Color _debugGetColor() => Colors.primaries[(_debugColor++ % Colors.primaries.length)];
const _kDebugShowNodeBounds = false;

class _NodeLayoutTransform extends SingleChildRenderObjectWidget {
  const _NodeLayoutTransform({
    required this.node,
    super.child,
    this.localTransientTransformStream,
    this.globalTransientTransformStream,
  });

  final Node node;
  final Stream<Matrix4?>? localTransientTransformStream;
  final Stream<Matrix4?>? globalTransientTransformStream;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderNodeLayoutTransform(
    node: node,
    localTransientTransformStream: localTransientTransformStream,
    globalTransientTransformStream: globalTransientTransformStream,
  );

  @override
  void updateRenderObject(BuildContext context, covariant _RenderNodeLayoutTransform renderObject) {
    renderObject.node = node;
    renderObject.transientTransformStream = localTransientTransformStream;
    renderObject.globalTransientTransformStream = globalTransientTransformStream;
  }
}

class _RenderNodeLayoutTransform extends RenderProxyBox {
  _RenderNodeLayoutTransform({
    required Node node,
    Stream<Matrix4?>? localTransientTransformStream,
    Stream<Matrix4?>? globalTransientTransformStream,
  }) : _node = node,
       _localTransientTransformStream = localTransientTransformStream,
       _globalTransientTransformStream = globalTransientTransformStream {
    _setupEffect();
    _localTransientTransformSubscription = localTransientTransformStream?.listen(_onLocalTransientTransformChanged);
    _globalTransientTransformSubscription = globalTransientTransformStream?.listen(_onGlobalTransientTransformChanged);
  }

  late RenderRootNode _rootNode;
  RenderNode? _parentRenderNode;
  late Color _debugColor;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _parentRenderNode = findAncestorRenderObjectOfType<RenderNode>();
    _rootNode = findAncestorRenderObjectOfType<RenderRootNode>()!;
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

  late StreamSubscription<Matrix4?>? _localTransientTransformSubscription;
  late Stream<Matrix4?>? _localTransientTransformStream;
  Stream<Matrix4?>? get transientTransformStream => _localTransientTransformStream;
  set transientTransformStream(Stream<Matrix4?>? stream) {
    if (_localTransientTransformStream == stream) return;

    _localTransientTransformSubscription?.cancel();
    _localTransientTransformSubscription = null;

    _localTransientTransformStream = stream;
    _localTransientTransformSubscription = stream?.listen(_onLocalTransientTransformChanged);
  }

  late StreamSubscription<Matrix4?>? _globalTransientTransformSubscription;
  late Stream<Matrix4?>? _globalTransientTransformStream;
  Stream<Matrix4?>? get globalTransientTransformStream => _globalTransientTransformStream;
  set globalTransientTransformStream(Stream<Matrix4?>? stream) {
    if (_globalTransientTransformStream == stream) return;

    _globalTransientTransformSubscription?.cancel();
    _globalTransientTransformSubscription = null;

    _globalTransientTransformStream = stream;
    _globalTransientTransformSubscription = stream?.listen(_onGlobalTransientTransformChanged);
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
    _localTransientTransformSubscription?.cancel();
    _localTransientTransformSubscription = null;
    super.dispose();
  }

  void _onLocalTransientTransformChanged(Matrix4? transientTransform) {
    _localTransientTransform = transientTransform;
    markNeedsLayout();
  }

  void _onGlobalTransientTransformChanged(Matrix4? transientTransform) {
    _globalTransientTransform = transientTransform;
    markNeedsLayout();
  }

  void _applyPaintTransform(Matrix4 transform) {
    if (_globalTransientTransform != null) {
      // Global transient transform is applied from the root down to this node.
      final transformToRoot = getTransformTo(_rootNode);
      final rootToThis = Matrix4.inverted(transformToRoot);
      transform.multiply(_globalTransientTransform! * rootToThis);
    }
    
    if (_localTransientTransform != null) {
      transform.multiply(_localTransientTransform!);
    }

    transform.multiply(_effectiveTransform);
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) => _applyPaintTransform(transform);

  /// Returns a layout-only transform from this render object to the [child]. This means that any transient transforms
  /// (e.g. from dragging in a flex/grid layout) are not included in the resulting transform.
  void applyLayoutTransform(RenderObject child, Matrix4 transform) {
    transform.multiply(_effectiveTransform);
  }

  late Matrix4 _effectiveTransform;
  Matrix4? _localTransientTransform;
  Matrix4? _globalTransientTransform;

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
    final transform = Matrix4.identity();
    _applyPaintTransform(transform);

    layer = context.pushTransform(
      child!.needsCompositing,
      offset,
      transform,
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
