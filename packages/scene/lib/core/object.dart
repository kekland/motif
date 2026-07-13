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

  ResolvedSize? _resolvedSize;
  ResolvedSize get resolvedSize => _resolvedSize!;

  bool get isLeaf => this is! MultiChildSceneObject;

  @override
  Aabb2 get boundingBox => .minMax(.zero(), .new(resolvedSize.width, resolvedSize.height));

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
  bool hitTestRect(SceneHitTestResult result, Aabb2 localRect, {RectHitTestMode mode = .normal}) {
    return _objectHitTestRect(result, this, localRect, mode: mode);
  }
}
