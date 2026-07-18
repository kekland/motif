part of '../core.dart';

class ResolvedSize {
  const ResolvedSize(this.width, this.height);

  static const ResolvedSize zero = .new(0, 0);

  final double width;
  final double height;

  bool contains(Vector2 point) {
    return point.x >= 0 && point.x <= width && point.y >= 0 && point.y <= height;
  }
  
  Aabb2 get boundingBox => .minMax(.zero(), .new(width, height));
}
