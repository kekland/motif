part of '../_program.dart';

abstract interface class LayoutBox {
  StatementId get id;
  StatementId? get parentId;

  Mat4 get transform;
  LayoutSize resolveSize(EvalContext context);
  Size2 intrinsicSize(Evaluation evaluation);

  static bool isLayoutEqual(EvalContext context, LayoutNode old, LayoutBox incoming) {
    if (old.box.runtimeType != incoming.runtimeType) return false;
    if (!old.transform.equals(incoming.transform)) return false;

    final intrinsicSize = old.intrinsicSize;
    if (!intrinsicSize.equals(incoming.intrinsicSize(context._evaluation))) return false;

    if (old.size != incoming.resolveSize(context)) return false;
    if (old.layout != null && incoming is LayoutContainer) {
      if (old.layout != incoming.resolveLayout(context)) return false;
    }

    return true;
  }
}

abstract interface class LayoutContainer extends LayoutBox {
  Layout resolveLayout(EvalContext context);
}

enum LayoutKind { stack, flexRow, flexColumn }

sealed class Layout {
  const Layout({this.padding = .zero});

  final LayoutInsets padding;
  LayoutKind get kind;

  static const default_ = Layout.stack();

  const factory Layout.stack({
    LayoutAlign alignHorizontal,
    LayoutAlign alignVertical,
    LayoutInsets padding,
  }) = StackLayout;

  factory Layout.flex({
    required FlexDirection direction,
    double gap,
    LayoutJustify justify,
    LayoutAlign crossAlign,
    LayoutInsets padding,
  }) = FlexLayout.create;

  Layout copyWith({
    LayoutInsets? padding,
  });
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

final class LayoutNode {
  LayoutNode(this.box);

  LayoutBox box;
  late LayoutSize size;
  late Mat4 transform;
  late Size2 intrinsicSize;
  Layout? layout;

  Size2? natural;
  Placement? placement;
  var dirty = false;

  Size2 fitSize(Size2 available) => size.fit(natural!, available);
  Aabb2 bounds(Size2 size) => size.toAabb()..transformDelta(transform);
  Size2 get naturalBounds => bounds(natural!).size;
}
