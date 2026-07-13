part of 'core.dart';

extension type const ObjectId(int id) {
  static ObjectId generate() => .new(_id++);
  static var _id = 0;

  static const ObjectId keep = .new(-1);
  static const ObjectId none = .new(-2);

  static ObjectId resolve(ObjectId existing, ObjectId requested) {
    if (requested == .keep) return existing;
    if (requested == .none) return generate();
    return requested;
  }
}

sealed class SceneObject implements SelectableObject {
  SceneObject({
    ObjectId? id,
    ObjectTransform? transform,
    ObjectSize? size,
  }) : id = id ?? .generate(),
       _transform = transform ?? .identity(),
       _size = size ?? .zero {
    _initialize();
  }

  // dart format off
  factory SceneObject.root() = RootObject;
  factory SceneObject.rectangle({ObjectId id, ObjectTransform transform, ObjectSize size}) = RectangleObject;
  factory SceneObject.container({ObjectId id, ObjectTransform transform, ObjectSize size, List<SceneObject> children}) = ContainerObject;
  factory SceneObject.vertex(Vector2 position, {ObjectId id}) = Vertex;
  factory SceneObject.edge(Vertex start, Vertex end, {ObjectId id}) = Edge;
  // dart format on

  final ObjectId id;

  MultiChildSceneObject? _parent;
  MultiChildSceneObject? get parent => _parent;
  set parent(MultiChildSceneObject? value) {
    if (_parent == value) return;
    _parent = value;
    _markNeedsLayout();
  }

  @override
  int get depth => (parent?.depth ?? -1) + 1;

  @mustCallSuper
  void _initialize() {}

  ObjectTransform _transform;
  ObjectTransform get transform => _transform;
  set transform(ObjectTransform value) {
    if (_transform == value) return;
    _transform._setFrom(value);
    _markNeedsLayout();
  }

  ObjectSize _size;
  ObjectSize get size => _size;
  set size(ObjectSize value) {
    if (_size == value) return;
    _size = value;
    _markNeedsLayout();
  }

  bool get isLeaf => this is! MultiChildSceneObject;

  Size? _resolvedSize;
  Size get resolvedSize => _resolvedSize!;

  Scene? _scene;

  @mustCallSuper
  void _attachToScene(Scene scene) {
    scene._attachObject(this);
    _markNeedsLayout();
  }

  @mustCallSuper
  void _detachFromScene() {
    _scene?._detachObject(this);
  }

  void _markNeedsLayout() {
    _scene?._markNeedsLayout(this);
  }

  void _markNeedsPaint() {
    _scene?._markNeedsPaint(this);
  }

  Size performLayout(BoxConstraints constraints) {
    return size.resolve(constraints);
  }

  void layout(BoxConstraints constraints) {
    _resolvedSize = performLayout(constraints);
  }

  SceneObject detach() {
    if (parent == null) return this;
    parent!.removeChild(this);
    return this;
  }

  void addLayoutListener(VoidCallback callback) => _scene!._addObjectLayoutListener(id, callback);
  void removeLayoutListener(VoidCallback callback) => _scene!._removeObjectLayoutListener(id, callback);
  void addPaintListener(VoidCallback callback) => _scene!._addObjectPaintListener(id, callback);
  void removePaintListener(VoidCallback callback) => _scene!._removeObjectPaintListener(id, callback);

  @override
  SceneObject get sceneObject => this;

  @override
  bool isAncestorOf(SelectableObject object) {
    SceneObject? current;

    if (object is SceneObject) {
      current = object;
    } else {
      current = object.sceneObject;
    }

    while (current != null) {
      if (current == this) return true;
      current = current.parent;
    }
    return false;
  }

  @override
  bool isDescendantOf(SelectableObject object) => object.isAncestorOf(this);

  @override
  Aabb2 get bbox => Aabb2.minMax(.zero(), .new(resolvedSize.width, resolvedSize.height));

  @override
  ReadonlySignal<SceneObject> call() => _scene!._signalFor(this);

  @override
  String toString() => '$runtimeType[id: $id, depth: $depth]';
}
