part of '../program.dart';

enum LayoutAlign {
  start,
  center,
  end;

  double offset(double outer, double inner) => switch (this) {
    .start => 0.0,
    .center => (outer - inner) / 2.0,
    .end => outer - inner,
  };
}

enum LayoutJustify { start, center, end, spaceBetween }

enum ChildLayoutType { stack, flex }

sealed class ChildLayout {
  const ChildLayout({this.padding = .zero});

  final LayoutInsets padding;

  static const default_ = ChildLayout.stack();

  const factory ChildLayout.stack({
    LayoutAlign alignHorizontal,
    LayoutAlign alignVertical,
    LayoutInsets padding,
  }) = StackChildLayout;

  const factory ChildLayout.flex({
    required FlexDirection direction,
    double gap,
    LayoutJustify justify,
    LayoutAlign crossAlign,
    LayoutInsets padding,
  }) = FlexChildLayout;

  ChildLayoutType get type;

  // Size layout(LayoutSize size, LayoutConstraints constraints, List<SceneObject> children);
}

final class StackChildLayout extends ChildLayout {
  const StackChildLayout({
    this.alignHorizontal,
    this.alignVertical,
    super.padding,
  });

  final LayoutAlign? alignHorizontal;
  final LayoutAlign? alignVertical;

  @override
  ChildLayoutType get type => .stack;

  @override
  bool operator ==(Object other) =>
      other is StackChildLayout &&
      other.alignHorizontal == alignHorizontal &&
      other.alignVertical == alignVertical &&
      other.padding == padding;

  @override
  int get hashCode => Object.hash(type, alignHorizontal, alignVertical, padding);
}

final class FlexChildLayout extends ChildLayout {
  const FlexChildLayout({
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
  ChildLayoutType get type => .flex;

  @override
  bool operator ==(Object other) =>
      other is FlexChildLayout &&
      other.direction == direction &&
      other.gap == gap &&
      other.justify == justify &&
      other.crossAlign == crossAlign &&
      other.padding == padding;

  @override
  int get hashCode => Object.hash(type, direction, gap, justify, crossAlign, padding);
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
