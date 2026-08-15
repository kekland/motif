import 'dart:ui';

import 'package:geometry/geometry.dart';

enum Corner {
  topLeft([Side.top, Side.left]),
  topRight([Side.top, Side.right]),
  bottomLeft([Side.bottom, Side.left]),
  bottomRight([Side.bottom, Side.right]);

  const Corner(this.edges);

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

  bool get isHorizontal => this == Side.top || this == Side.bottom;
  bool get isVertical => this == Side.left || this == Side.right;

  Side get opposite => switch (this) {
    .top => .bottom,
    .right => .left,
    .bottom => .top,
    .left => .right,
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

extension SideUtils on Side {
  double _edge(Aabb2 bbox) => switch (this) {
    .top => bbox.top,
    .right => bbox.right,
    .bottom => bbox.bottom,
    .left => bbox.left,
  };

  Aabb2 applyResize(Aabb2 bbox, Vec2 delta, {bool symmetric = false, bool keepAspectRatio = false}) {
    final center = bbox.center;
    final target = Vec2(_edge(bbox), _edge(bbox)) + delta;
    final aspectRatio = bbox.aspectRatio;
    final anchor = symmetric ? center : Vec2(opposite._edge(bbox), opposite._edge(bbox));
    var _delta = target - anchor;

    if (symmetric) _delta *= 2.0;

    var newWidth = bbox.width;
    var newHeight = bbox.height;

    if (isVertical) {
      newWidth = _delta.x.abs();
      if (keepAspectRatio) newHeight = newWidth / aspectRatio;
    } else {
      newHeight = _delta.y.abs();
      if (keepAspectRatio) newWidth = newHeight * aspectRatio;
    }

    final sx = _delta.x.sign;
    final sy = _delta.y.sign;

    late final Vec2 newCenter;
    if (symmetric) {
      newCenter = center;
    } else {
      newCenter = switch (this) {
        .left || .right => .new(anchor.x + (newWidth / 2.0 * sx), center.y),
        .top || .bottom => .new(center.x, anchor.y + (newHeight / 2.0 * sy)),
      };
    }

    return .center(newCenter, newWidth, newHeight);
  }
}

extension CornerUtils on Corner {
  Vec2 corner(Aabb2 bbox) => switch (this) {
    .topLeft => bbox.topLeft,
    .topRight => bbox.topRight,
    .bottomRight => bbox.bottomRight,
    .bottomLeft => bbox.bottomLeft,
  };

  Aabb2 applyResize(Aabb2 bbox, Vec2 delta, {bool symmetric = false, bool keepAspectRatio = false}) {
    final target = corner(bbox) + delta;
    final aspectRatio = bbox.aspectRatio;
    final anchor = symmetric ? bbox.center : opposite.corner(bbox);
    final _delta = target - anchor;

    var newWidth = _delta.x.abs() * (symmetric ? 2.0 : 1.0);
    var newHeight = _delta.y.abs() * (symmetric ? 2.0 : 1.0);

    if (keepAspectRatio) {
      if (newWidth / newHeight < aspectRatio) {
        newWidth = newHeight * aspectRatio;
      } else {
        newHeight = newWidth / aspectRatio;
      }
    }

    if (symmetric) return .center(anchor, newWidth, newHeight);

    final sx = _delta.x.sign;
    final sy = _delta.y.sign;

    return anchor.aabb(anchor + .new(newWidth * sx, newHeight * sy));
  }
}
