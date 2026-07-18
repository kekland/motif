part of 'core.dart';

sealed class SceneObject extends SceneNode with SceneNodeImpl {
  SceneObject({ObjectTransform? transform, ObjectSize? size, NodeId? id})
    : _transform = transform ?? .identity(),
      _size = size ?? .zero,
      id = id ?? .generate(),
      super();

  @override
  final NodeId id;

  @override
  MultiChildSceneObject? get parent => super.parent as MultiChildSceneObject?;

  final ObjectTransform _transform;
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

  @override
  Aabb2 get boundingBox => .minMax(.zero(), .new(resolvedSize.width, resolvedSize.height));

  @override
  bool get isLayoutBoundary => !size.dependsOnParent;

  @override
  ResolvedSize get resolvedSize {
    if (size.isFixed) return size.resolve(.new());
    return super.resolvedSize;
  }

  ResolvedSize performLayout(LayoutConstraints constraints) {
    return size.resolve(constraints);
  }

  @override
  void layout(LayoutConstraints constraints) {
    _resolvedSize = performLayout(constraints);
  }

  @override
  void applyTransform(Matrix4 transform) {
    transform.multiply(_transform.value);
  }

  @override
  void transformWith(Matrix4 transform) {
    final bbox = boundingBox;
    size = .fixed(bbox.width * transform.scaleX, bbox.height * transform.scaleY);

    final normalized = transform.getWithNormalizedScale();
    final current = _transform.value.clone();
    current.multiply(normalized);

    this.transform = .raw(current);
  }

  @override
  bool hitTest(SceneHitTestResult result, Vector2 localPosition, {Matrix4? globalToScene}) {
    if (hitTestChildren(result, localPosition, globalToScene: globalToScene) ||
        hitTestSelf(localPosition, globalToScene: globalToScene)) {
      result.add(SceneObjectHitTestEntry(this, localPosition));
      return true;
    }

    return false;
  }

  @override
  bool hitTestSelf(Vector2 localPosition, {Matrix4? globalToScene}) => resolvedSize.contains(localPosition);
  bool hitTestChildren(SceneHitTestResult result, Vector2 localPosition, {Matrix4? globalToScene}) => false;

  @override
  bool hitTestRect(SceneHitTestResult result, Aabb2 localRect, {HitTestRectMode mode = .normal}) {
    return _objectHitTestRect(result, this, localRect, mode: mode);
  }

  @override
  ObjectSnapshot snapshot() {
    return ObjectSnapshot(id: id, transform: transform.clone(), size: size);
  }

  @override
  @mustCallSuper
  void applySnapshot(covariant ObjectSnapshot snapshot) {
    transform = snapshot.transform;
    size = snapshot.size;
  }
}
