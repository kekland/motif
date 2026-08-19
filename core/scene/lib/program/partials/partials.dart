part of '../program.dart';

final class Vec2Partial({final double? x, final double? y}) {
  Vec2Partial.from(Vec2 value) : this(x: value.x, y: value.y);
  Vec2 apply(Vec2 value) => Vec2(x ?? value.x, y ?? value.y);

  Vec2 get unwrap {
    assert(x != null && y != null, 'Vec2Partial is not fully defined');
    return Vec2(x!, y!);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || (other is Vec2Partial && x == other.x && y == other.y);

  @override
  int get hashCode => Object.hash(x, y);
}

final class LayoutSizePartial({final LayoutDimension? width, final LayoutDimension? height}) {
  LayoutSizePartial.from(LayoutSize value) : this(width: value.width, height: value.height);
  LayoutSize apply(LayoutSize value) => LayoutSize(width ?? value.width, height ?? value.height);

  LayoutSize get unwrap {
    assert(width != null && height != null, 'LayoutSizePartial is not fully defined');
    return LayoutSize(width!, height!);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is LayoutSizePartial && width == other.width && height == other.height);

  @override
  int get hashCode => Object.hash(width, height);
}
