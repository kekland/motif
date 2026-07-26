part of '../core.dart';

/// Core implementation of the [SceneNode] interface.
mixin SceneNodeBase implements SceneNode {
  String? _name;

  @override
  String get name => _name ?? '${type.typeName} ($id)';

  @override
  set name(String? value) {
    if (_name == value) return;
    _name = value;
    _markNeedsUpdate({.name});
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Scene attachment and initialization
  // @-----------------------------------------------------------------------------------------------------------------@

  @override
  @mustCallSuper
  void _initialize() {
    for (final child in _children) child._setParent(this);
  }

  Scene? _scene;

  @override
  @mustCallSuper
  void _attachToScene(Scene scene) {
    assert(_scene == null, 'Node is already attached to a scene');
    scene._onNodeAttached(this);
    _scene = scene;
    for (final child in children.toList()) child._attachToScene(scene);
  }

  @override
  @mustCallSuper
  void _detachFromScene() {
    assert(_scene != null, 'Node is not attached to a scene');
    for (final child in children) child._detachFromScene();
    _scene!._onNodeDetached(this);
    _scene = null;
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Scene graph relationships
  // @-----------------------------------------------------------------------------------------------------------------@

  SceneNode? _parent;

  @override
  SceneNode? get parent => _parent;

  @override
  set parent(covariant SceneNode? value) {
    if (_parent == value) return;

    if (value == null) {
      _parent?._removeChild(this);
    } else {
      value._addChild(this);
    }
  }

  @override
  void detach() => parent = null;

  @override
  void _setParent(SceneNode? parent) => _parent = parent;

  final _children = <SceneNode>[];

  @override
  List<SceneNode> get children => _children;

  @override
  Iterable<Cell> get cells => _children.whereType<Cell>();

  @override
  void _addChild(SceneNode child) => _insertChild(_children.length, child);
  void _insertChild(int index, SceneNode child) {
    assert(!_children.contains(child), '$child is already a child of $this');

    child.detach();
    _children.insert(index, child);
    child._setParent(this);
    if (_scene != null) child._attachToScene(_scene!);

    child._markNeedsLayout(.parent);
    _markNeedsLayout(.children);
  }

  void _addChildren(Iterable<SceneNode> children) => _insertChildren(_children.length, children);

  @override
  void _insertChildren(int index, Iterable<SceneNode> children) {
    assert(!children.any(_children.contains), 'Some children are already children of $this');

    for (final child in children) child.detach();
    _children.insertAll(index, children);

    for (final child in children) {
      child._setParent(this);
      if (_scene != null) child._attachToScene(_scene!);
      child._markNeedsLayout(.parent);
    }

    _markNeedsLayout(.children);
  }

  @override
  SceneNode _removeChild(SceneNode child) {
    assert(_children.contains(child), '$child is not a child of $this');
    _children.remove(child);
    child._setParent(null);
    child._detachFromScene();

    _markNeedsLayout(.children);
    return child;
  }

  List<SceneNode> _clearChildren() => _removeChildren(_children);

  List<SceneNode> _removeChildren(Iterable<SceneNode> children) {
    assert(children.every(_children.contains), 'Some children are not children of $this');

    final childrenSet = children.toSet();
    _children.removeWhere(childrenSet.contains);

    for (final child in childrenSet) {
      child._setParent(null);
      child._detachFromScene();
    }

    _markNeedsLayout(.children);
    return children.toList();
  }

  SceneNode? _owner;

  @override
  SceneNode? get owner => _owner;

  @override
  bool get isOwned => _owner != null;

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Tree traversal
  // @-----------------------------------------------------------------------------------------------------------------@

  @override
  int get depth => (parent?.depth ?? -1) + 1;

  @override
  bool isAncestorOf(SceneNode node) {
    SceneNode? current = node;

    while (current != null) {
      if (current == this) return true;
      current = current.parent;
    }

    return false;
  }

  @override
  bool isDescendantOf(SceneNode node) => node.isAncestorOf(this);

  @override
  bool isVirtualAncestorOf(SceneNode node) {
    if (isAncestorOf(node)) return true;
    if (node.isOwned) return isAncestorOf(node.owner!);
    return false;
  }

  @override
  bool isVirtualDescendantOf(SceneNode node) {
    if (isDescendantOf(node)) return true;
    if (isOwned) return node == owner! || node.isAncestorOf(owner!);
    return false;
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Invalidation and updates
  // @-----------------------------------------------------------------------------------------------------------------@

  var _dirtyFlags = NodeUpdateAspect.none;

  @override
  var _needsLayout = false;

  @override
  bool get needsLayout => _needsLayout;

  @override
  void _markNeedsUpdate(Set<NodeUpdateAspect> aspects) {
    for (final flag in aspects) _dirtyFlags |= flag;
    _scene?._markNodeDirty(this);
  }

  @override
  void _markNeedsLayout([NodeUpdateAspect? aspect]) {
    if (aspect != null) _dirtyFlags |= aspect;
    // if (_needsLayout) return;
    if (_scene == null) return;

    _needsLayout = true;
    _scene!._markNodeDirty(this);

    var current = parent;
    while (current != null && !current.isLayoutBoundary) {
      current._needsLayout = true;
      current = current.parent;
    }

    _scene!._markBoundaryNeedsLayout(current ?? _scene!.root);
  }

  @override
  void _$flushUpdates(SceneNodeNotifier notifier) {
    notifier.notify(_dirtyFlags);
    _dirtyFlags = .none;
    _needsLayout = false;
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Layout and transformation
  // @-----------------------------------------------------------------------------------------------------------------@

  @override
  bool get isTransformControlled => false;

  @override
  bool get isLayoutBoundary => false;

  @override
  Matrix4 getTransformTo(SceneNode? target) {
    return _getTransformTo(this, target ?? _scene!.root, (n, t) => n.cascadeTransform(t));
  }

  @override
  void cascadeTransform(Matrix4 transform) {}

  @override
  Matrix4 getPaintTransformTo(SceneNode? target) {
    return _getTransformTo(this, target ?? _scene!.root, (n, t) => n.cascadePaintTransform(t));
  }

  @override
  void cascadePaintTransform(Matrix4 transform) {
    final globalTransient = transientTransform?.global;
    if (globalTransient != null) {
      final rootToThis = _scene!.root.getTransformTo(this);
      transform.multiply(globalTransient * rootToThis);
    }

    final localTransient = transientTransform?.local;
    if (localTransient != null) {
      transform.multiply(localTransient);
    }

    cascadeTransform(transform);
  }

  @override
  Vector2 sceneToLocal(Vector2 globalPosition, {SceneNode? ancestor}) {
    final transform = getTransformTo(ancestor);
    if (transform.invert() == 0.0) return .zero();
    return transform.unproject2(globalPosition);
  }

  @override
  Vector2 localToScene(Vector2 localPosition, {SceneNode? ancestor}) {
    final transform = getTransformTo(ancestor);
    return transform.transform2(localPosition);
  }

  @override
  LayoutConstraints? _lastConstraints;

  @override
  void layout(LayoutConstraints constraints) {
    if (_lastConstraints == constraints && !_needsLayout) return;
    _lastConstraints = constraints;
    _needsLayout = false;

    performLayout(constraints);
  }

  @override
  void relayout() {
    performLayout(_lastConstraints!);
  }

  @override
  void performLayout(LayoutConstraints constraints) {}

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Transient transformations
  // @-----------------------------------------------------------------------------------------------------------------@

  TransientTransform? _transientTransform;

  @override
  TransientTransform? get transientTransform => _transientTransform;

  @override
  set transientTransform(TransientTransform? value) {
    if (_transientTransform == value) return;
    _transientTransform = value;
    _markNeedsUpdate({.transientTransform});
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Hit testing
  // @-----------------------------------------------------------------------------------------------------------------@

  @override
  bool hitTest(
    SceneHitTestResult result,
    Vector2 localPosition, {
    Matrix4? globalToScene,
    List<SceneNode> ignore = const [],
  }) => false;

  @override
  bool hitTestSelf(Vector2 localPosition, {Matrix4? globalToScene}) => false;

  @override
  bool hitTestRect(SceneHitTestResult result, Aabb2 localRect, {HitTestRectMode mode = .normal}) => false;

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Other stuff
  // @-----------------------------------------------------------------------------------------------------------------@

  @override
  ChangeNotifier call([NodeUpdateAspect aspect = .all]) {
    final notifier = _scene!.notifierForNode(id);
    if (aspect == .all) return notifier;
    return notifier.aspect(aspect);
  }

  @override
  String toString() => '$runtimeType[id: $id, depth: ${_scene != null ? depth : "detached"}]';

  @override
  bool operator ==(Object other) => identical(this, other) || (other is SceneNode && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

Matrix4 _getTransformTo(
  SceneNode from,
  SceneNode target,
  void Function(SceneNode node, Matrix4 transform) cascadeTransform,
) {
  // Adapted from RenderObject.getTransformTo in Flutter
  List<SceneNode>? fromPath;
  List<SceneNode>? toPath;

  SceneNode to = target;

  while (!identical(from, to)) {
    final fromDepth = from.depth;
    final toDepth = to.depth;

    if (fromDepth >= toDepth) {
      final fromParent = from.parent!;
      fromPath ??= [from];
      fromPath.add(fromParent);
      from = fromParent;
    }
    if (fromDepth <= toDepth) {
      final toParent = to.parent!;
      toPath ??= [to];
      toPath.add(toParent);
      to = toParent;
    }
  }

  Matrix4? fromTransform;
  if (fromPath != null) {
    fromTransform = .identity();
    for (var i = fromPath.length - 2; i >= 0; i--) {
      cascadeTransform(fromPath[i], fromTransform);
    }
  }
  if (toPath == null) return fromTransform ?? .identity();

  final toTransform = Matrix4.identity();
  for (var i = toPath.length - 2; i >= 0; i--) {
    cascadeTransform(toPath[i], toTransform);
  }

  if (toTransform.invert() == 0) return .zero();
  return (fromTransform?..multiply(toTransform)) ?? toTransform;
}
