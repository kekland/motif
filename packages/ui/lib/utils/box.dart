import 'dart:math' as math;
import 'dart:ui';

import 'package:geometry/geometry.dart';

enum Corner {
  topLeft([Side.top, Side.left]),
  topRight([Side.top, Side.right]),
  bottomLeft([Side.bottom, Side.left]),
  bottomRight([Side.bottom, Side.right]);

  const Corner(this.edges);

  static Corner of(Side vertical, Side horizontal) => switch ((vertical, horizontal)) {
    (.top, .left) => .topLeft,
    (.top, .right) => .topRight,
    (.bottom, .left) => .bottomLeft,
    (.bottom, .right) => .bottomRight,
    _ => throw ArgumentError('invalid corner: $vertical, $horizontal'),
  };

  final List<Side> edges;
  bool get isTop => edges.contains(Side.top);
  bool get isLeft => edges.contains(Side.left);
  bool get isBottom => edges.contains(Side.bottom);
  bool get isRight => edges.contains(Side.right);

  Corner get opposite => switch (this) {
    .topLeft => .bottomRight,
    .topRight => .bottomLeft,
    .bottomLeft => .topRight,
    .bottomRight => .topLeft,
  };
}

enum Side {
  top,
  right,
  bottom,
  left;

  bool get isHorizontal => this == .top || this == .bottom;
  bool get isVertical => this == .left || this == .right;

  Side get opposite => switch (this) {
    .top => .bottom,
    .right => .left,
    .bottom => .top,
    .left => .right,
  };

  Vec2 midpoint(Aabb2 box) => switch (this) {
    .top => .new(box.center.x, box.top),
    .right => .new(box.right, box.center.y),
    .bottom => .new(box.center.x, box.bottom),
    .left => .new(box.left, box.center.y),
  };
}

extension RectBoxExtensions on Rect {
  Offset corner(Corner corner) => switch (corner) {
    .topLeft => topLeft,
    .topRight => topRight,
    .bottomLeft => bottomLeft,
    .bottomRight => bottomRight,
  };

  double side(Side edge) => switch (edge) {
    .top => top,
    .right => right,
    .bottom => bottom,
    .left => left,
  };
}

typedef ResizeResult = ({Vec2 anchor, Vec2 scale});

extension SideUtils on Side {
  ResizeResult applyResize(
    Aabb2 bbox,
    Vec2 delta, {
    bool symmetric = false,
    bool keepAspectRatio = false,
  }) {
    final anchor = symmetric ? bbox.center : opposite.midpoint(bbox);
    final from = midpoint(bbox) - anchor;
    final to = from + delta;
    final s = isVertical ? (from.x == 0.0 ? 1.0 : to.x / from.x) : (from.y == 0.0 ? 1.0 : to.y / from.y);
    final cross = keepAspectRatio ? s.abs() : 1.0;
    return (anchor: anchor, scale: isVertical ? .new(s, cross) : .new(cross, s));
  }
}

extension CornerUtils on Corner {
  Vec2 corner(Aabb2 bbox) => switch (this) {
    .topLeft => bbox.topLeft,
    .topRight => bbox.topRight,
    .bottomRight => bbox.bottomRight,
    .bottomLeft => bbox.bottomLeft,
  };

  ResizeResult applyResize(
    Aabb2 bbox,
    Vec2 delta, {
    bool symmetric = false,
    bool keepAspectRatio = false,
  }) {
    final anchor = symmetric ? bbox.center : opposite.corner(bbox);
    final from = corner(bbox) - anchor;
    final to = from + delta;
    var sx = from.x == 0.0 ? 1.0 : to.x / from.x;
    var sy = from.y == 0.0 ? 1.0 : to.y / from.y;
    if (keepAspectRatio) {
      final s = math.max(sx.abs(), sy.abs());
      sx = sx.sign * s;
      sy = sy.sign * s;
    }
    return (anchor: anchor, scale: .new(sx, sy));
  }
}
