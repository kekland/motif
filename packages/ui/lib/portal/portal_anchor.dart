part of 'portal.dart';

class PortalAnchor {
  const PortalAnchor({required this.rect, this.alignment});

  static PortalAnchor compute(
    BuildContext context, {
    Rect? rect,
    EdgeInsets padding = .zero,
    Alignment? alignment,
    Axis axis = .vertical,
  }) {
    final root = context.findAncestorStateOfType<PortalRootState>()!;
    final rootBox = root.context.findRenderObject() as RenderBox;
    final renderBox = context.findRenderObject() as RenderBox;

    final localRect = rect ?? (Offset.zero & renderBox.size);
    final rootRect = MatrixUtils.transformRect(renderBox.getTransformTo(rootBox), localRect);

    final Alignment resolvedAlignment;

    if (alignment != null) {
      resolvedAlignment = alignment;
    } else {
      resolvedAlignment = switch (axis) {
        .vertical => .new(0.0, rootBox.size.height - rootRect.bottom >= rootRect.top ? 1.0 : -1.0),
        .horizontal => .new(rootBox.size.width - rootRect.right >= rootRect.left ? 1.0 : -1.0, 0.0),
      };
    }

    return .new(
      rect: padding.inflateRect(rootRect),
      alignment: resolvedAlignment,
    );
  }

  final Rect rect;
  final Alignment? alignment;

  PortalAnchor transform(Matrix4 transform) {
    return .new(
      rect: MatrixUtils.transformRect(transform, rect),
      alignment: alignment,
    );
  }
}

class PortalPositioned extends SingleChildRenderObjectWidget {
  const PortalPositioned({
    super.key,
    required Widget super.child,
    this.rect,
    this.anchor,
    this.onInitialRectComputed,
    this.portalConstraints,
    this.edgePadding = .zero,
  });

  final Rect? rect;
  final PortalAnchor? anchor;
  final ValueChanged<Rect>? onInitialRectComputed;
  final BoxConstraints? portalConstraints;
  final EdgeInsets edgePadding;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPortalPositioned(
      rect: rect,
      anchor: anchor,
      onInitialRectComputed: onInitialRectComputed,
      portalConstraints: portalConstraints,
      edgePadding: edgePadding,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderPortalPositioned renderObject,
  ) {
    renderObject
      ..rect = rect
      ..portalConstraints = portalConstraints
      ..edgePadding = edgePadding;
  }
}

class RenderPortalPositioned extends RenderProxyBox {
  RenderPortalPositioned({
    this._portalConstraints,
    this._rect,
    this._anchor,
    this._onInitialRectComputed,
    this._edgePadding = .zero,
  });

  BoxConstraints? _portalConstraints;
  BoxConstraints? get portalConstraints => _portalConstraints;
  set portalConstraints(BoxConstraints? value) {
    if (value == _portalConstraints) return;
    _portalConstraints = value;
    markNeedsLayout();
  }

  Rect? _rect;
  Rect? get rect => _rect;
  set rect(Rect? value) {
    if (value == _rect) return;
    _rect = value;
    markNeedsLayout();
  }

  EdgeInsets _edgePadding;
  EdgeInsets get edgePadding => _edgePadding;
  set edgePadding(EdgeInsets value) {
    if (value == _edgePadding) return;
    _edgePadding = value;
    markNeedsLayout();
  }

  final PortalAnchor? _anchor;
  final ValueChanged<Rect>? _onInitialRectComputed;

  static Rect _fitRect(Rect r, Rect container) {
    double _d(double start, double end, double min, double max) {
      if (start < min) return min - start;
      if (end > max) return max - end;
      return 0.0;
    }

    return r.shift(
      .new(
        _d(r.left, r.right, container.left, container.right),
        _d(r.top, r.bottom, container.top, container.bottom),
      ),
    );
  }

  void _recomputeRect() {
    child!.layout(portalConstraints ?? constraints.loosen(), parentUsesSize: true);

    final childSize = child!.size;
    final container = _edgePadding.deflateRect(Offset.zero & constraints.biggest);

    final Offset topLeft;
    final anchor = _anchor;

    if (anchor == null) {
      topLeft = container.center - childSize.center(.zero);
    } else if (anchor.alignment != null) {
      final a = anchor.alignment!;
      topLeft = a.withinRect(anchor.rect) - (-a).alongSize(childSize);
    } else {
      print(anchor.rect);
      final below = anchor.rect.bottom + 8.0;
      final above = anchor.rect.top - 8.0 - childSize.height;
      final fitsBelow = below + childSize.height <= container.bottom;
      final fitsAbove = above >= container.top;
      topLeft = Offset(
        anchor.rect.center.dx - childSize.width / 2.0,
        !fitsBelow && fitsAbove ? above : below,
      );
    }

    _rect = _fitRect(topLeft & childSize, container);
    _onInitialRectComputed?.call(_rect!);
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // If no rect is passed - try to compute an initial rect.
    if (rect == null) {
      _recomputeRect();
      return;
    }

    final rectConstraints = BoxConstraints.tight(rect!.size);
    child!.layout(rectConstraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final childOffset = offset + rect!.topLeft;
    context.paintChild(child!, childOffset);
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    transform.translateByDouble(rect!.left, rect!.top, 0.0, 1.0);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintOffset(
      offset: rect!.topLeft,
      position: position,
      hitTest: (result, position) => child!.hitTest(result, position: position),
    );
  }
}
