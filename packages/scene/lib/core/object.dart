part of 'core.dart';

/// A scene object is a node in the scene graph that has a transform and a rectangular size.
sealed class SceneObject extends SceneNode with SceneNodeBase {
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
    _markNeedsLayout(.transform);
  }

  ObjectSize _size;
  ObjectSize get size => _size;
  set size(ObjectSize value) {
    if (_size == value) return;
    _size = value;
    _markNeedsLayout(.size);
  }

  bool get isLeaf => this is! MultiChildSceneObject;

  @override
  Aabb2 get bbox => .minMax(.zero(), .new(_resolvedSize!.width, _resolvedSize!.height));

  @override
  bool get isLayoutBoundary => !size.dependsOnParent;

  @override
  bool get isTransformControlled => parent?.controlsChildTransform(this) ?? false;

  ResolvedSize? _resolvedSize;

  @override
  void performLayout(LayoutConstraints constraints) {
    _resolvedSize = size.resolve(constraints);
  }

  @override
  void cascadeTransform(Matrix4 transform) {
    transform.multiply(_transform.value);
  }

  @override
  void applyTransform(Matrix4 transform) {
    final bbox = this.bbox;
    size = .fixed(bbox.width * transform.scaleX, bbox.height * transform.scaleY);

    final normalized = transform.getWithNormalizedScale();
    final current = _transform.value.clone();
    current.multiply(normalized);

    this.transform = .raw(current);
  }

  @override
  bool hitTest(
    SceneHitTestResult result,
    Vector2 localPosition, {
    Matrix4? globalToScene,
    List<SceneNode> ignore = const [],
  }) {
    if (ignore.contains(this)) return false;

    if (hitTestChildren(result, localPosition, globalToScene: globalToScene, ignore: ignore) ||
        hitTestSelf(localPosition, globalToScene: globalToScene)) {
      result.add(SceneObjectHitTestEntry(this, localPosition));
      return true;
    }

    return false;
  }

  @override
  bool hitTestSelf(Vector2 localPosition, {Matrix4? globalToScene}) => bbox.containsVector2(localPosition);
  bool hitTestChildren(
    SceneHitTestResult result,
    Vector2 localPosition, {
    Matrix4? globalToScene,
    List<SceneNode> ignore = const [],
  }) => false;

  @override
  bool hitTestRect(SceneHitTestResult result, Aabb2 localRect, {HitTestRectMode mode = .normal}) {
    return _objectHitTestRect(result, this, localRect, mode: mode);
  }

  @override
  ObjectSnapshot snapshot() {
    return ObjectSnapshot(
      id: id,
      transform: transform.clone(),
      size: size,
      resolvedSize: _resolvedSize,
    );
  }

  @override
  @mustCallSuper
  void applySnapshot(covariant ObjectSnapshot snapshot) {
    transform = snapshot.transform;
    size = snapshot.size;
    _resolvedSize = snapshot.resolvedSize;
  }
}
