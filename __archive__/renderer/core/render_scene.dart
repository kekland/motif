part of 'core.dart';

class RenderSceneWidget extends SingleChildRenderObjectWidget {
  const RenderSceneWidget({super.key, required this.scene, super.child});

  final Scene scene;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderScene(scene: scene);
  }

  @override
  void updateRenderObject(BuildContext context, RenderScene renderObject) {
    renderObject.scene = scene;
  }
}

final class RenderScene extends RenderSceneObject {
  RenderScene({required this._scene}) : super(object: _scene.root) {
    _scene.addListener(markNeedsLayout);
  }

  Scene _scene;
  Scene get scene => _scene;
  set scene(Scene value) {
    if (_scene == value) return;
    _scene.removeListener(markNeedsLayout);
    _scene = value;
    _scene.addListener(markNeedsLayout);
    object = _scene.root;
    markNeedsLayout();
  }

  // dart format off
  @override RootObject get object => super.object as RootObject;
  @override set object(RootObject value) => super.object = value;
  // dart format on

  final _objects = <SceneObject, RenderSceneObject>{};

  void _registerObject(SceneObject object, RenderSceneObject renderObject) {
    assert(_objects[object] == null, 'object is already registered.');
    _objects[object] = renderObject;
  }

  void _unregisterObject(SceneObject object) {
    assert(_objects[object] != null, 'object is not registered.');
    _objects.remove(object);
  }

  RenderSceneObject getRenderObject(SceneObject object) {
    final renderObject = _objects[object];
    assert(renderObject != null, 'object is not registered.');
    return renderObject!;
  }

  @override
  void dispose() {
    _scene.removeListener(markNeedsLayout);
    super.dispose();
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    child!.layout(constraints);
  }

  @override
  void reassemble() {
    super.reassemble();
    scene.reassemble();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool objectHitTestRect(SceneObjectHitTestResult result, {required Rect rect, ObjectHitTestRectMode mode = .normal}) {
    return objectHitTestRectChildren(result, rect: rect, mode: mode);
  }
}
