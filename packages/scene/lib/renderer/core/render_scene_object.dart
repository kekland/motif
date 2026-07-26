part of 'core.dart';

class RenderSceneObjectWidget extends SingleChildRenderObjectWidget {
  const RenderSceneObjectWidget({
    super.key,
    required this.object,
    super.child,
  });

  final SceneObject object;

  @override
  RenderSceneObject createRenderObject(BuildContext context) {
    return RenderSceneObject(object: object);
  }

  @override
  void updateRenderObject(BuildContext context, RenderSceneObject renderObject) {
    renderObject.object = object;
  }
}

class RenderSceneObject extends RenderSceneNode<SceneObject> {
  RenderSceneObject({required SceneObject object}) : super(node: object);

  SceneObject get object => node;
  set object(SceneObject value) => node = value;

  @override
  Rect get boundingBox => Offset.zero & size;

  @override
  bool hitTestSelf(Offset position) => size.contains(position);

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }

    return false;
  }

  @override
  void performLayout() {
    size = .new(object.bbox.width, object.bbox.height);
    child!.layout(BoxConstraints.tight(size));
    _maybeSortChildrenList();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final transform = Matrix4.identity();
    applyPaintTransform(this, transform);

    layer = context.pushTransform(
      child!.needsCompositing,
      offset,
      transform,
      (context, offset) => context.paintChild(child!, offset),
      oldLayer: layer as TransformLayer?,
    );
  }
}
