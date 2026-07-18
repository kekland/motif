part of 'core.dart';

extension type const NodeId(int id) {
  static NodeId generate() => .new(_id++);
  static var _id = 0;

  static const NodeId keep = .new(-1);
  static const NodeId none = .new(-2);

  static NodeId resolve(NodeId existing, NodeId requested) {
    if (requested == .keep) return existing;
    if (requested == .none) return generate();
    return requested;
  }
}

sealed class SceneNode {
  SceneNode() {
    _initialize();
  }

  NodeId get id;

  // dart format off
  factory SceneNode.vertex(Vector2 position, {NodeId id}) = Vertex;
  factory SceneNode.edge(Vertex start, Vertex end, {NodeId id, EdgePath path}) = Edge;
  factory SceneNode.rectangle({NodeId id, ObjectTransform transform, ObjectSize size}) = RectangleObject;
  factory SceneNode.container({NodeId id, ObjectTransform transform, ObjectSize size, List<SceneNode> children}) = ContainerObject;
  factory SceneNode.root({List<SceneNode> children}) = RootObject;
  // dart format on

  // --------------------
  // Parent/child mechanisms
  // --------------------

  SceneNode? get _parent;
  set _parent(covariant SceneNode? value);

  SceneNode? get parent;
  set parent(covariant SceneNode? value);
  void detach();

  @protected
  List<SceneNode> get children;

  void _addChild(SceneNode child);
  SceneNode _removeChild(SceneNode child);

  SceneNode? get owner;
  bool get isOwned;

  // --------------------
  // Initialization, scene attachment, layout
  // --------------------

  void _initialize();

  void _attachToScene(Scene scene);
  void _detachFromScene();

  void _markNeedsLayout();
  void _markNeedsPaint();

  ResolvedSize get resolvedSize;
  Aabb2 get boundingBox;
  bool get isLayoutBoundary;
  void layout(LayoutConstraints constraints);
  void transformWith(Matrix4 transform);

  // --------------------
  // Tree traversal
  // --------------------

  int get depth;
  bool isAncestorOf(SceneNode node);
  bool isDescendantOf(SceneNode node);
  bool isVirtualAncestorOf(SceneNode node);
  bool isVirtualDescendantOf(SceneNode node);

  // --------------------
  // Hit testing
  // --------------------
  Matrix4 getTransformTo(SceneNode? node);
  void applyTransform(Matrix4 transform);
  Vector2 sceneToLocal(Vector2 globalPosition, {SceneNode? ancestor});
  Vector2 localToScene(Vector2 localPosition, {SceneNode? ancestor});

  bool hitTest(SceneHitTestResult result, Vector2 localPosition, {Matrix4? globalToScene});
  bool hitTestSelf(Vector2 localPosition, {Matrix4? globalToScene});

  bool hitTestRect(SceneHitTestResult result, Aabb2 localRect, {HitTestRectMode mode = .normal});

  // --------------------
  // Snapshotting
  // --------------------

  NodeSnapshot snapshot();
  void applySnapshot(covariant NodeSnapshot snapshot);

  // --------------------
  // Other stuff
  // --------------------

  void addLayoutListener(VoidCallback callback);
  void removeLayoutListener(VoidCallback callback);
  void addPaintListener(VoidCallback callback);
  void removePaintListener(VoidCallback callback);

  ReadonlySignal<SceneNode> call();

  @override
  String toString();
}

mixin SceneNodeImpl implements SceneNode {
  // --------------------
  // Parent/child mechanisms
  // --------------------

  @override
  SceneNode? _parent;

  @override
  SceneNode? get parent => _parent;

  @override
  set parent(covariant SceneNode? value) {
    if (_parent == value) return;

    if (value == null) {
      detach();
    } else {
      value._addChild(this);
      _markNeedsLayout();
    }
  }

  @override
  void detach() {
    _parent?._removeChild(this);
  }

  final _children = <SceneNode>[];

  @override
  List<SceneNode> get children => _children;

  @override
  void _addChild(SceneNode child) => _insertChild(_children.length, child);

  void _insertChild(int index, SceneNode child) {
    assert(!_children.contains(child) || child._parent == this, '$child is already a child of this node');

    child.detach();
    _children.insert(index, child);
    child._parent = this;
    if (_scene != null) child._attachToScene(_scene!);

    child._markNeedsLayout();
    _markNeedsLayout();
  }

  void _addChildren(Iterable<SceneNode> children) => _insertChildren(_children.length, children);

  void _insertChildren(int index, Iterable<SceneNode> children) {
    assert(children.every((child) => !_children.contains(child) || child._parent == this));

    for (final child in children) child.detach();
    _children.insertAll(index, children);

    for (final child in children) {
      child._parent = this;
      if (_scene != null) child._attachToScene(_scene!);
      child._markNeedsLayout();
    }

    _markNeedsLayout();
  }

  @override
  SceneNode _removeChild(SceneNode child) {
    assert(!_children.contains(child) || child._parent == this, '$child is not a child of this node');

    _children.remove(child);
    child._parent = null;
    child._detachFromScene();

    child._markNeedsLayout();
    _markNeedsLayout();

    return child;
  }

  List<SceneNode> _clearChildren() => _removeChildren(_children.toList());

  List<SceneNode> _removeChildren(Iterable<SceneNode> children) {
    final removed = <SceneNode>[];

    for (final child in children) {
      if (_children.contains(child)) {
        _children.remove(child);
        child._parent = null;
        child._detachFromScene();

        child._markNeedsLayout();
        removed.add(child);
      }
    }

    _markNeedsLayout();
    return removed;
  }

  @override
  SceneNode? get owner => _owner;
  SceneNode? _owner;

  @override
  bool get isOwned => _owner != null;

  // --------------------
  // Initialization, scene attachment, layout
  // --------------------

  @override
  @mustCallSuper
  void _initialize() {
    for (final child in _children) child._parent = this;
  }

  Scene? _scene;

  @override
  @mustCallSuper
  void _attachToScene(Scene scene) {
    scene._onNodeAttached(this);
    _scene = scene;
    for (final child in _children) child._attachToScene(scene);
  }

  @override
  @mustCallSuper
  void _detachFromScene() {
    for (final child in _children) child._detachFromScene();
    _scene!._onNodeDetached(this);
    _scene = null;
  }

  @override
  void _markNeedsLayout() {
    _scene?._markNeedsLayout(this);
  }

  @override
  void _markNeedsPaint() {
    _scene?._markNeedsPaint(this);
  }

  ResolvedSize? _resolvedSize;

  @override
  ResolvedSize get resolvedSize => _resolvedSize!;

  @override
  void layout(LayoutConstraints constraints) {}

  // --------------------
  // Tree traversal
  // --------------------

  @override
  void applyTransform(Matrix4 transform) {}

  @override
  Matrix4 getTransformTo(SceneNode? target) {
    // Adapted from RenderObject.getTransformTo in Flutter
    List<SceneNode>? fromPath;
    List<SceneNode>? toPath;

    SceneNode from = this;
    SceneNode to = target ?? _scene!.root;

    while (!identical(from, to)) {
      final fromDepth = from.depth;
      final toDepth = to.depth;

      if (fromDepth >= toDepth) {
        final fromParent = from.parent!;
        fromPath ??= [this];
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
      for (var i = fromPath.length - 1; i >= 0; i--) {
        fromPath[i].applyTransform(fromTransform);
      }
    }
    if (toPath == null) return fromTransform ?? .identity();

    final toTransform = Matrix4.identity();
    for (var i = toPath.length - 2; i >= 0; i--) {
      toPath[i].applyTransform(toTransform);
    }

    if (toTransform.invert() == 0) return .zero();
    return (fromTransform?..multiply(toTransform)) ?? toTransform;
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

  // --------------------
  // Other stuff
  // --------------------

  @override
  void addLayoutListener(VoidCallback callback) => _scene!._addObjectLayoutListener(id, callback);

  @override
  void removeLayoutListener(VoidCallback callback) => _scene?._removeObjectLayoutListener(id, callback);

  @override
  void addPaintListener(VoidCallback callback) => _scene!._addObjectPaintListener(id, callback);

  @override
  void removePaintListener(VoidCallback callback) => _scene?._removeObjectPaintListener(id, callback);

  @override
  ReadonlySignal<SceneNode> call() => _scene!._signalFor(this);

  @override
  String toString() => '$runtimeType[id: $id, depth: ${_scene != null ? depth : "detached"}]';
}
