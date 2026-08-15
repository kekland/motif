part of 'core.dart';

abstract class RenderSceneNode<T extends SceneNode> extends RenderProxyBox {
  RenderSceneNode({required this._node}) {
    _addListeners();
  }

  T _node;
  T get node => _node;
  set node(covariant T value) {
    if (_node == value) return;
    _removeListeners();
    _node = value;
    _addListeners();
    markNeedsLayout();
  }

  void _addListeners() {
    _node(.layout).addListener(_onLayoutChanged);
    _node(.paint).addListener(_onPaintChanged);
    _node(.children).addListener(_onChildrenChanged);
    _node(.transientTransform).addListener(_onTransientTransformChanged);
  }

  void _removeListeners() {
    if (!_node.isAttached) return;
    _node(.layout).removeListener(_onLayoutChanged);
    _node(.paint).removeListener(_onPaintChanged);
    _node(.children).removeListener(_onChildrenChanged);
    _node(.transientTransform).removeListener(_onTransientTransformChanged);
  }

  void _onLayoutChanged() => markNeedsLayout();
  void _onPaintChanged() => markNeedsPaint();
  void _onTransientTransformChanged() => markNeedsPaint();

  bool _sortChildren = true;
  void _onChildrenChanged() => _sortChildren = true;

  RenderSceneNode? _sceneParent;
  RenderScene? _sceneRoot;
  RenderSceneNode get sceneParent => _sceneParent!;
  RenderScene get sceneRoot => _sceneRoot!;

  final _childrenNodes = <RenderSceneNode>[];

  Rect get boundingBox;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    var current = parent!;
    while (true) {
      if (current is RenderSceneNode) {
        _sceneParent ??= current;
      }

      if (current is RenderScene) {
        _sceneRoot = current;
        break;
      }

      if (current.parent == null) break;
      current = current.parent!;
    }

    _sceneParent?._childrenNodes.add(this);
    // _sceneRoot?._registerNode(this);
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  @override
  void detach() {
    _sceneParent?._childrenNodes.remove(this);
    // _sceneRoot?._unregisterNode(this);
    _sceneParent = null;
    _sceneRoot = null;
    super.detach();
  }

  @mustCallSuper
  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    node.cascadePaintTransform(transform);
  }

  void _maybeSortChildrenList() {
    if (!_sortChildren) return;
    _sortChildren = false;

    if (_childrenNodes.isNotEmpty) {
      final node = _node;
      // ignore: invalid_use_of_protected_member
      final children = node.children;

      _childrenNodes.sort((a, b) {
        final aIndex = children.indexOf(a.node);
        final bIndex = children.indexOf(b.node);
        return aIndex.compareTo(bIndex);
      });
    }
  }
}
