part of 'handles.dart';

class HandlesParentData extends ContainerBoxParentData<RenderBox> {
  HandlesParentData({required this.position});

  Offset? position;
}

class HandleWidget extends ParentDataWidget<HandlesParentData> {
  const HandleWidget({
    super.key,
    required this.position,
    required super.child,
  });

  final Offset position;

  @override
  void applyParentData(RenderObject renderObject) {
    if (renderObject.parentData is! HandlesParentData) return;
    final parentData = renderObject.parentData as HandlesParentData;

    if (parentData.position == position) return;
    parentData.position = position;
    renderObject.parent?.markNeedsPaint();
  }

  @override
  Type get debugTypicalAncestorWidgetClass => HandlesLayout;
}

class HandlesLayout extends MultiChildRenderObjectWidget {
  const HandlesLayout({super.key, required super.children, required this.childPaintTransform});

  final Matrix4 childPaintTransform;

  @override
  RenderHandles createRenderObject(BuildContext context) => RenderHandles(childPaintTransform: childPaintTransform);

  @override
  void updateRenderObject(BuildContext context, RenderHandles renderObject) {
    renderObject.childPaintTransform = childPaintTransform;
  }
}

class RenderHandles extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, HandlesParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, HandlesParentData> {
  RenderHandles({required this._childPaintTransform});

  late Matrix4 _childPaintTransform;
  Matrix4 get childPaintTransform => _childPaintTransform;
  set childPaintTransform(Matrix4 value) {
    if (_childPaintTransform == value) return;
    _childPaintTransform = value;
    markNeedsPaint();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! HandlesParentData) {
      child.parentData = HandlesParentData(position: null);
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    var child = firstChild;
    const childConstraints = BoxConstraints();
    while (child != null) {
      final childParentData = child.parentData as HandlesParentData;

      if (childParentData.position != null) {
        child.layout(childConstraints);
      } else {
        child.layout(constraints);
      }

      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as HandlesParentData;

      if (childParentData.position != null) {
        var transformedOffset = MatrixUtils.transformPoint(childPaintTransform, childParentData.position!);
        transformedOffset -= child.size.center(Offset.zero);
        context.paintChild(child, transformedOffset + offset);
      } else {
        context.paintChild(child, offset);
      }

      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }

    return false;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    var child = lastChild;

    while (child != null) {
      final childParentData = child.parentData as HandlesParentData;

      if (childParentData.position != null) {
        var transformedOffset = MatrixUtils.transformPoint(childPaintTransform, childParentData.position!);
        transformedOffset -= child.size.center(Offset.zero);

        final didHit = result.addWithPaintOffset(
          offset: transformedOffset,
          position: position,
          hitTest: (result, position) {
            return child!.hitTest(result, position: position);
          },
        );

        if (didHit) return true;
      } else {
        if (child.hitTest(result, position: position)) return true;
      }

      child = childParentData.previousSibling;
    }

    return false;
  }
}
