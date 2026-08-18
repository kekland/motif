import 'dart:ui' as ui;

import 'package:geometry/geometry.dart';

extension Vec2UiUtils on Vec2 {
  ui.Offset get offset => ui.Offset(x, y);
}

extension Aabb2UiUtils on Aabb2 {
  ui.Rect get rect => ui.Rect.fromLTRB(min.x, min.y, max.x, max.y);
}

extension UiVec2Utils on ui.Offset {
  Vec2 get vec2 => Vec2(dx, dy);
}

extension UiAabb2Utils on ui.Rect {
  Aabb2 get aabb2 => Aabb2.ltwh(left, top, width, height);
}
