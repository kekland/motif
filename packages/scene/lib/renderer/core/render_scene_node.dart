part of 'core.dart';

abstract class RenderSceneNode<T extends SceneNode> extends RenderProxyBox {
  RenderSceneNode({required this._node}) {
    _node.addLayoutListener(markNeedsLayout);
    _node.addPaintListener(markNeedsPaint);
  }

  T _node;
  T get node => _node;
  set node(covariant T value) {
    if (_node == value) return;
    _node.removeLayoutListener(markNeedsLayout);
    _node.removePaintListener(markNeedsPaint);
    _node = value;
    _node.addLayoutListener(markNeedsLayout);
    _node.addPaintListener(markNeedsPaint);
    markNeedsLayout();
  }

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
    _sceneRoot?._registerNode(this);
  }

  @override
  void dispose() {
    _node.removeLayoutListener(markNeedsLayout);
    _node.removePaintListener(markNeedsPaint);
    super.dispose();
  }

  @override
  void detach() {
    _sceneParent?._childrenNodes.remove(this);
    _sceneRoot?._unregisterNode(this);
    _sceneParent = null;
    _sceneRoot = null;
    super.detach();
  }

  void _sortChildrenList() {
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
