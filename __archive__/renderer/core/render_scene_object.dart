part of 'core.dart';

class RenderSceneObjectWidget extends SingleChildRenderObjectWidget {
  const RenderSceneObjectWidget({
    super.key,
    required this.object,
    required super.child,
  });

  final SceneObject object;

  @override
  RenderSceneObject createRenderObject(BuildContext context) {
    final object = this.object;
    return RenderSceneObject(object: object);
  }

  @override
  void updateRenderObject(BuildContext context, RenderSceneObject renderObject) {
    renderObject.object = object;
  }
}

class RenderSceneObject extends RenderProxyBox {
  RenderSceneObject({required this._object}) {
    _object.addLayoutListener(markNeedsLayout);
    _object.addPaintListener(markNeedsPaint);
  }

  SceneObject _object;
  SceneObject get object => _object;
  set object(covariant SceneObject value) {
    if (_object == value) return;
    _object.removeLayoutListener(markNeedsLayout);
    _object.removePaintListener(markNeedsPaint);
    _object = value;
    _object.addLayoutListener(markNeedsLayout);
    _object.addPaintListener(markNeedsPaint);
    markNeedsLayout();
  }

  RenderSceneObject? _sceneParent;
  RenderScene? _sceneRoot;
  RenderSceneObject get sceneParent => _sceneParent!;
  RenderScene get sceneRoot => _sceneRoot!;

  final _childrenObjects = <RenderSceneObject>[];

  Rect get bounds {
    final bbox = object.bbox;
    return .fromPoints(bbox.min.offset, bbox.max.offset);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    var current = parent!;
    while (true) {
      if (current is RenderSceneObject) {
        _sceneParent ??= current;
      }

      if (current is RenderScene) {
        _sceneRoot = current;
        break;
      }

      if (current.parent == null) break;
      current = current.parent!;
    }

    _sceneParent?._childrenObjects.add(this);
    _sceneRoot?._registerObject(_object, this);
  }

  @override
  void dispose() {
    _object.removeLayoutListener(markNeedsLayout);
    _object.removePaintListener(markNeedsPaint);
    super.dispose();
  }

  @override
  void detach() {
    _sceneParent?._childrenObjects.remove(this);
    _sceneRoot?._unregisterObject(_object);
    _sceneParent = null;
    _sceneRoot = null;
    super.detach();
  }

  @override
  void performLayout() {
    size = object.resolvedSize;
    child?.layout(BoxConstraints.tight(size));

    if (_childrenObjects.isNotEmpty) {
      final object = _object as MultiChildSceneObject;
      _childrenObjects.sort((a, b) {
        final aIndex = object.indexOf(a.object);
        final bIndex = object.indexOf(b.object);
        return aIndex.compareTo(bIndex);
      });
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);

    context.canvas.drawRect(
      offset & size,
      Paint()
        ..style = .stroke
        ..color = .new(0xFFFF00FF),
    );
  }

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

  // --------------------
  // Object hit testing
  // --------------------

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

  // --------------------
  // Rect hit testing
  // --------------------

  bool objectHitTestRect(SceneObjectHitTestResult result, {required Rect rect, ObjectHitTestRectMode mode = .normal}) {
    if (!bounds.overlaps(rect)) return false;

    final isLeaf = object.isLeaf;
    final isIntersecting = bounds.overlaps(rect);
    final isContained = rect.containsRect(bounds);

    bool _addSelf() {
      result.add(SceneObjectHitTestEntry(this, bounds.center));
      return true;
    }

    if (isContained) return _addSelf();
    if (isLeaf && isIntersecting && mode != .contain) return _addSelf();
    if (!isLeaf && isIntersecting && mode == .intersect) return _addSelf();
    return objectHitTestRectChildren(result, rect: rect, mode: mode);
  }

  bool objectHitTestRectChildren(
    SceneObjectHitTestResult result, {
    required Rect rect,
    ObjectHitTestRectMode mode = .normal,
  }) {
    if (object.isLeaf) return false;
    var _result = false;

    for (final child in _childrenObjects.reversed) {
      final transform = getTransformTo(child);
      final childRect = MatrixUtils.transformRect(transform, rect);
      if (child.objectHitTestRect(result, rect: childRect, mode: mode)) {
        _result = true;
      }
    }

    return _result;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => '${super.toString()}[$object]';
}
