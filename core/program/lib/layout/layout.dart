part of '../program.dart';

abstract interface class LayoutBox {
  StatementId get id;
  StatementId? get parentId;

  Mat4 get transform;
  LayoutSize get size;
  Size2 get intrinsicSize;
}

abstract interface class LayoutContainer extends LayoutBox {
  Layout get layout;
}

// enum LayoutJustify { start, center, end, spaceBetween }

sealed class Layout {
  const Layout({this.padding = .zero});

  final LayoutInsets padding;

  static const default_ = Layout.stack();

  const factory Layout.stack({
    LayoutAlign alignHorizontal,
    LayoutAlign alignVertical,
    LayoutInsets padding,
  }) = StackLayout;

  const factory Layout.flex({
    required FlexDirection direction,
    double gap,
    LayoutJustify justify,
    LayoutAlign crossAlign,
    LayoutInsets padding,
  }) = FlexLayout;
}

final class const Placement(final Vec2? offset, final Size2 size) {
  @override
  int get hashCode => Object.hash(offset, size);

  @override
  bool operator ==(Object other) {
    if (other is! Placement) return false;
    if (!other.size.equals(size)) return false;
    if (other.offset != null && offset != null) return other.offset!.equals(offset!);
    return other.offset == offset;
  }
}

final class _LayoutNode {
  _LayoutNode(this.box);

  LayoutBox box;
  Size2? natural;
  Placement? placement;
  var dirty = false;

  Size2 fitSize(Size2 available) => box.size.fit(natural!, available);
  Aabb2 bounds(Size2 size) => size.toAabb()..transformDelta(box.transform);
  Size2 get naturalBounds => bounds(natural!).size;
}
