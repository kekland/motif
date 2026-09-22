part of '../../program.dart';

enum LayoutJustify { start, center, end, spaceBetween }

final class FlexLayout extends Layout {
  const FlexLayout({
    required this.direction,
    this.gap = 0.0,
    this.justify = .start,
    this.crossAlign = .start,
    super.padding,
  });

  final FlexDirection direction;
  final LayoutJustify justify;
  final LayoutAlign crossAlign;
  final double gap;

  @override
  bool operator ==(Object other) =>
      other is FlexLayout &&
      other.direction == direction &&
      other.gap == gap &&
      other.justify == justify &&
      other.crossAlign == crossAlign &&
      other.padding == padding;

  @override
  int get hashCode => Object.hash(direction, gap, justify, crossAlign, padding);
}

enum FlexDirection {
  row,
  column;

  bool get isRow => this == .row;

  LayoutDimension mainOf(LayoutSize size) => isRow ? size.width : size.height;
  LayoutDimension crossOf(LayoutSize size) => isRow ? size.height : size.width;

  double main(double x, double y) => isRow ? x : y;
  double cross(double x, double y) => isRow ? y : x;

  double mainOfSize(Size2 size) => isRow ? size.width : size.height;
  double crossOfSize(Size2 size) => isRow ? size.height : size.width;

  Vec2 vec({required double main, required double cross}) => isRow ? Vec2(main, cross) : Vec2(cross, main);
  Size2 size({required double main, required double cross}) => isRow ? Size2(main, cross) : Size2(cross, main);
}

extension _FlexLayoutImpl on LayoutTree {
  Size2 _measureFlex(List<_LayoutNode> children, Size2 intrinsic, FlexLayout l) {
    final dir = l.direction;
    var main = 0.0, cross = 0.0;
    for (final c in children) {
      final bounds = c.naturalBounds;
      main += dir.mainOfSize(bounds);
      cross = math.max(cross, dir.crossOfSize(bounds));
    }

    if (children.length > 1) main += l.gap * (children.length - 1);
    return dir.size(main: main, cross: cross).hull(intrinsic);
  }

  List<Placement> _placeFlex(List<_LayoutNode> children, Size2 inner, FlexLayout l) {
    final dir = l.direction, k = children.length;
    final innerMain = dir.mainOfSize(inner), innerCross = dir.crossOfSize(inner);
    final gaps = k > 1 ? l.gap * (k - 1) : 0.0;

    final sizes = List<Size2?>.filled(k, null);
    final bounds = List<Aabb2?>.filled(k, null);

    final main = List.filled(k, 0.0);
    var used = gaps, expanding = 0;
    for (var i = 0; i < k; i++) {
      final child = children[i];
      final dimension = dir.mainOf(child.box.size);
      if (dimension.isExpand) {
        expanding++;
      } else {
        final childSize = child.fitSize(dir.size(main: innerMain, cross: innerCross));
        sizes[i] = childSize;

        final childBounds = child.bounds(childSize);
        bounds[i] = childBounds;
        used += dir.mainOfSize(childBounds.size);
      }
    }

    if (expanding > 0) {
      final share = math.max(0.0, (innerMain - used) / expanding);
      for (var i = 0; i < k; i++) {
        final child = children[i];
        if (!dir.mainOf(child.box.size).isExpand) continue;

        final size = child.fitSize(dir.size(main: share, cross: innerCross));
        sizes[i] = size;
        bounds[i] = child.bounds(size);
      }
    }

    var consumed = gaps;
    for (final m in main) consumed += m;
    final slack = innerMain - consumed;
    final (start, between) = switch (l.justify) {
      .start => (0.0, l.gap),
      .center => (slack / 2.0, l.gap),
      .end => (slack, l.gap),
      .spaceBetween => (0.0, k > 1 ? l.gap + slack / (k - 1) : l.gap),
    };

    final out = <Placement>[];
    var cursor = start;
    for (var i = 0; i < k; i++) {
      final childSize = sizes[i]!;
      final childBounds = bounds[i]!;

      final translation = dir.vec(
        main: cursor,
        cross: l.crossAlign.offset(innerCross, dir.crossOfSize(childBounds.size)),
      );

      out.add(.new(l.padding.origin + translation - childBounds.min, childSize));
      cursor += dir.mainOfSize(childBounds.size) + between;
    }

    return out;
  }
}
