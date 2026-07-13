import 'dart:ui' as ui;

import 'package:ui/ui.dart';
import 'package:vector_math/vector_math_64.dart';

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
