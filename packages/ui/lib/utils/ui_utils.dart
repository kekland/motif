import 'dart:ui' as ui;

import 'package:ui/ui.dart';
import 'package:geometry/geometry.dart';

extension RectUtils on ui.Rect {
  bool containsVector2(Vector2 point) {
    return point.x >= left && point.x < right && point.y >= top && point.y < bottom;
  }

  bool containsAabb2(Aabb2 aabb) {
    return aabb.min.x >= left && aabb.max.x <= right && aabb.min.y >= top && aabb.max.y <= bottom;
  }

  bool overlapsAabb2(Aabb2 aabb) {
    return !(aabb.max.x < left || aabb.min.x > right || aabb.max.y < top || aabb.min.y > bottom);
  }

  bool containsRect(ui.Rect other) {
    return other.left >= left && other.right <= right && other.top >= top && other.bottom <= bottom;
  }
}

extension Aabb2RectUtils on Aabb2 {
  ui.Rect get asRect => ui.Rect.fromPoints(min.offset, max.offset);
}

extension EdgeUtils on Edge {
  double _edge(Aabb2 bbox) => switch (this) {
    .top => bbox.min.y,
    .right => bbox.max.x,
    .bottom => bbox.max.y,
    .left => bbox.min.x,
  };

  Aabb2 applyResize(Aabb2 bbox, Vector2 delta, {bool symmetric = false, bool keepAspectRatio = false}) {
    final center = bbox.center;
    final target = Vector2(_edge(bbox), _edge(bbox)) + delta;
    final aspectRatio = bbox.aspectRatio;
    final anchor = symmetric ? center : Vector2(opposite._edge(bbox), opposite._edge(bbox));
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

    late final Vector2 newCenter;
    if (symmetric) {
      newCenter = center;
    } else {
      newCenter = switch (this) {
        .left || .right => Vector2(anchor.x + (newWidth / 2.0 * sx), center.y),
        .top || .bottom => Vector2(center.x, anchor.y + (newHeight / 2.0 * sy)),
      };
    }

    return .centerAndHalfExtents(newCenter, .new(newWidth / 2.0, newHeight / 2.0));
  }
}

extension CornerUtils on Corner {
  Vector2 corner(Aabb2 bbox) => switch (this) {
    .topLeft => bbox.topLeft,
    .topRight => bbox.topRight,
    .bottomRight => bbox.bottomRight,
    .bottomLeft => bbox.bottomLeft,
  };

  Aabb2 applyResize(Aabb2 bbox, Vector2 delta, {bool symmetric = false, bool keepAspectRatio = false}) {
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

    if (symmetric) return .centerAndHalfExtents(anchor, .new(newWidth / 2.0, newHeight / 2.0));

    final sx = _delta.x.sign;
    final sy = _delta.y.sign;

    return anchor.aabb2(anchor + .new(newWidth * sx, newHeight * sy));
  }
}
