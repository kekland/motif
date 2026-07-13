part of 'core.dart';

abstract class RenderSceneNode extends RenderProxyBox {
  RenderSceneNode({required this._node}) {
    _node.addLayoutListener(markNeedsLayout);
    _node.addPaintListener(markNeedsPaint);
  }

  SceneNode _node;
  SceneNode get node => _node;
  set node(covariant SceneNode value) {
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
    _sceneRoot?._registerNode(_node, this);
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
    _sceneRoot?._unregisterNode(_node);
    _sceneParent = null;
    _sceneRoot = null;
    super.detach();
  }

  @override
  @mustCallSuper
  void performLayout() {
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

  // ----------
  // Hit testing
  // ----------

  @override
  bool hitTestSelf(Offset position) => size.contains(position);

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
      result.add(SceneObjectHitTestEntry(this, position));
      return true;
    }

    return false;
  }

  // ----------
  // Node hit testing
  // ----------


  bool objectHitTest(SceneObjectHitTestResult result, {required Offset position}) {
    if (objectHitTestChildren(result, position: position) || objectHitTestSelf(position)) {
      result.add(SceneObjectHitTestEntry(this, position));
      return true;
    }

    return false;
  }

  bool objectHitTestSelf(Offset position) => hitTestSelf(position);

  bool objectHitTestChildren(SceneObjectHitTestResult result, {required Offset position}) {
    if (object is! MultiChildSceneObject) return false;

    // Hit test cells first
    final cells = _childrenObjects.whereType<RenderCell>();
    final cellHits = hitTestCells(this, cells.toList(), position);

    // Hit test other children
    for (final child in _childrenObjects.reversed.where((v) => v is! RenderCell)) {
      final localPosition = MatrixUtils.transformPoint(getTransformTo(child), position);
      if (child.objectHitTestSelf(localPosition)) {
        for (final c in cellHits) result.add(c);
        child.objectHitTest(result, position: localPosition);
        return true;
      }
    }

    for (final c in cellHits) result.add(c);
    return false;
  }
}
