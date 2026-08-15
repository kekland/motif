import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

mixin OverflowHitTestable on RenderBox {
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }

    return false;
  }
}

class OverflowHitTestableStack extends Stack {
  const OverflowHitTestableStack({
    super.key,
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
    super.children,
  });

  @override
  RenderStack createRenderObject(BuildContext context) {
    return RenderOverflowHitTestableStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.maybeOf(context),
      fit: fit,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderStack renderObject) {
    renderObject
      ..alignment = alignment
      ..textDirection = textDirection ?? Directionality.maybeOf(context)
      ..fit = fit
      ..clipBehavior = clipBehavior;
  }
}

class RenderOverflowHitTestableStack extends RenderStack with OverflowHitTestable {
  RenderOverflowHitTestableStack({
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
    super.children,
  });
}

class OverflowHitTestableSizedOverflowBox extends SizedOverflowBox {
  const OverflowHitTestableSizedOverflowBox({
    super.key,
    required super.size,
    super.alignment,
    super.child,
  });

  @override
  RenderSizedOverflowBox createRenderObject(BuildContext context) {
    return RenderOverflowHitTestableSizedOverflowBox(
      textDirection: Directionality.of(context),
      requestedSize: size,
      alignment: alignment,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderSizedOverflowBox renderObject) {
    renderObject
      ..textDirection = Directionality.of(context)
      ..requestedSize = size
      ..alignment = alignment;
  }
}

class RenderOverflowHitTestableSizedOverflowBox extends RenderSizedOverflowBox with OverflowHitTestable {
  RenderOverflowHitTestableSizedOverflowBox({
    required super.requestedSize,
    super.alignment,
    super.child,
    super.textDirection,
  });
}
