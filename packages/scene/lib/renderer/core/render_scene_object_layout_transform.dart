part of 'core.dart';

class RenderSceneObjectLayoutTransformWidget extends SingleChildRenderObjectWidget {
  const RenderSceneObjectLayoutTransformWidget({super.key, required this.object, super.child});

  final SceneObject object;

  @override
  RenderSceneObjectLayoutTransform createRenderObject(BuildContext context) {
    return RenderSceneObjectLayoutTransform(object: object);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderSceneObjectLayoutTransform renderObject) {
    renderObject.object = object;
  }
}

class RenderSceneObjectLayoutTransform extends RenderProxyBox {
  RenderSceneObjectLayoutTransform({required this._object}) {
    _object.addLayoutListener(markNeedsLayout);
  }

  SceneObject _object;
  SceneObject get object => _object;
  set object(covariant SceneObject value) {
    if (_object == value) return;
    _object.removeLayoutListener(markNeedsLayout);
    _object = value;
    _object.addLayoutListener(markNeedsLayout);
    markNeedsLayout();
  }

  @override
  void performLayout() {
    size = .new(object.resolvedSize.width, object.resolvedSize.height);
    child!.layout(BoxConstraints.tight(size));
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    transform.multiply(object.transform.value);
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

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) => child!.hitTest(result, position: position);
}
