part of '../core.dart';

class ResolvedSize {
  ResolvedSize(this.width, this.height);

  final double width;
  final double height;

  bool contains(Vector2 point) {
    return point.x >= 0 && point.x <= width && point.y >= 0 && point.y <= height;
  }
  
  Aabb2 get boundingBox => .minMax(.zero(), .new(width, height));
}
