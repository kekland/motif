import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'interactive_viewer/interactive_viewer.dart' as iv;

/// An infinitely scrollable canvas widget.
///
/// Children of the viewport must be [CanvasPositioned] widgets, which are positioned using absolute coordinates.
///
/// The center of the viewport is at (0, 0), x increases to the right, and y increases downwards.
class InteractiveCanvas extends StatefulWidget {
  const InteractiveCanvas({
    super.key,
    this.transformationController,
    this.overlayBuilders = const [],
    this.centerOrigin = true,
    required this.child,
  });

  final TransformationController? transformationController;
  final List<Widget Function(BuildContext context, Widget child)> overlayBuilders;
  final bool centerOrigin;
  final Widget child;

  @override
  State<InteractiveCanvas> createState() => _InteractiveCanvasState();
}

class _InteractiveCanvasState extends State<InteractiveCanvas> {
  final _internalController = TransformationController();
  TransformationController get controller => widget.transformationController ?? _internalController;

  @override
  void dispose() {
    _internalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        return iv.InteractiveViewer.builder(
          transformationController: widget.transformationController,
          minScale: 0.1,
          maxScale: 10.0,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          scaleFactor: 200.0,
          builder: (context, _) {
            final rawTransform = controller.value;

            final translate = widget.centerOrigin
                ? Matrix4.translationValues(size.width / 2, size.height / 2, 0.0)
                : Matrix4.identity();

            final transform = rawTransform * translate;

            Widget child = SizedBox.fromSize(
              size: size,
              child: CanvasViewport(
                transform: transform,
                child: widget.child,
              ),
            );

            Widget overlays = Transform(
              transform: transform,
              child: SizedBox.fromSize(
                size: size,
                child: Stack(
                  children: [
                    for (final builder in widget.overlayBuilders) builder(context, const SizedBox.expand()),
                  ],
                ),
              ),
            );

            return Stack(
              children: [
                child,
                overlays,
              ],
            );
          },
        );
      },
    );
  }
}

class CanvasViewport extends SingleChildRenderObjectWidget {
  const CanvasViewport({
    super.key,
    required this.transform,
    required super.child,
  });

  final Matrix4 transform;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCanvasViewport(transform: transform);
  }

  @override
  void updateRenderObject(BuildContext context, RenderCanvasViewport renderObject) {
    renderObject.transform = transform;
  }
}

class RenderCanvasViewport extends RenderProxyBox {
  RenderCanvasViewport({Matrix4? transform}) : _transform = transform ?? Matrix4.identity();

  late Matrix4 _transform;
  Matrix4 get transform => _transform;
  set transform(Matrix4 value) {
    if (_transform == value) return;
    _transform = value;
    markNeedsPaint();
  }

  Rect? _viewport;
  Rect get viewport => _viewport!;

  @override
  void performLayout() {
    size = constraints.biggest;
    child!.layout(constraints);

    _viewport = Offset.zero & size;
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
    return result.addWithPaintTransform(
      transform: transform,
      position: position,
      hitTest: (BoxHitTestResult result, Offset position) {
        return super.hitTestChildren(result, position: position);
      },
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    super.applyPaintTransform(child, transform);
    transform.multiply(this.transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    layer = context.pushTransform(
      needsCompositing,
      offset,
      transform,
      super.paint,
      oldLayer: layer is TransformLayer ? layer as TransformLayer? : null,
    );
  }
}

class CanvasPositioned extends SingleChildRenderObjectWidget {
  const CanvasPositioned({
    super.key,
    required this.rect,
    super.child,
  });

  CanvasPositioned.fromLTWH({
    super.key,
    required double left,
    required double top,
    required double width,
    required double height,
    super.child,
  }) : rect = Rect.fromLTWH(left, top, width, height);

  final Rect rect;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCanvasPositioned(rect: rect);
  }

  @override
  void updateRenderObject(BuildContext context, RenderCanvasPositioned renderObject) {
    renderObject.rect = rect;
  }
}

class RenderCanvasPositioned extends RenderProxyBox {
  RenderCanvasPositioned({required Rect rect}) : _rect = rect;

  late Rect _rect;
  Rect get rect => _rect;
  set rect(Rect value) {
    if (_rect == value) return;
    _rect = value;
    _updateParentData();
    markNeedsLayout();
  }

  RenderCanvasViewport? _viewportStack;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    RenderObject? current = this;
    while (current != null) {
      if (current is RenderCanvasViewport) {
        _viewportStack = current;
        break;
      }

      current = current.parent;
    }
  }

  @override
  void detach() {
    _viewportStack = null;
    super.detach();
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! StackParentData) {
      child.parentData = StackParentData();
      _updateParentData();
    }
  }

  void _updateParentData() {
    if (parentData is! StackParentData) return;

    final data = parentData as StackParentData;
    data.left = rect.left;
    data.top = rect.top;
    data.width = rect.width;
    data.height = rect.height;
    data.offset = rect.topLeft;
  }

  @override
  void performLayout() {
    size = constraints.constrain(_rect.size);
    child?.layout(BoxConstraints.tight(size));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_viewportStack == null) return super.paint(context, offset);

    // Paint only if we're within the viewport.
    final stackRect = MatrixUtils.transformRect(getTransformTo(_viewportStack!), paintBounds);
    if (stackRect.overlaps(_viewportStack!.viewport)) {
      super.paint(context, offset);
    }
  }
}
