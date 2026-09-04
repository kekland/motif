import 'dart:math' as math;
import 'dart:typed_data';

import 'package:geometry/geometry.dart';

final class Aabb2 {
  Aabb2(double left, double top, double right, double bottom)
    : this.minMax(
        .new(left, top),
        .new(right, bottom),
      );

  Aabb2.ltwh(double left, double top, double width, double height)
    : this.minMax(
        .new(left, top),
        .new(left + width, top + height),
      );

  Aabb2.minMax(this._min, this._max);
  Aabb2.point(Vec2 p) : this.minMax(p, p);
  Aabb2.copy(Aabb2 other) : this.minMax(other.min, other.max);
  Aabb2.empty() : this.minMax(.zero(), .zero());
  Aabb2.invertedInfinity()
    : this.minMax(
        .new(.infinity, .infinity),
        .new(.negativeInfinity, .negativeInfinity),
      );

  Aabb2.center(Vec2 center, double width, double height)
    : this.minMax(
        .new(center.x - width * 0.5, center.y - height * 0.5),
        .new(center.x + width * 0.5, center.y + height * 0.5),
      );

  factory Aabb2.bbox(Iterable<Float64x2> points) {
    if (points.isEmpty) return Aabb2.minMax(.zero(), .zero());
    var min = points.first, max = points.first;
    for (final p in points) {
      min = min.min(p);
      max = max.max(p);
    }
    return Aabb2.minMax(Vec2.from(min), Vec2.from(max));
  }

  factory Aabb2.bbox2(Vec2 a, Vec2 b) => .minMax(
    .min(a, b),
    .max(a, b),
  );

  Vec2 _min;
  Vec2 get min => _min;

  Vec2 _max;
  Vec2 get max => _max;

  void hull(Aabb2 other) {
    _min = min.min(other.min);
    _max = max.max(other.max);
  }

  void hullPoint(Vec2 p) {
    _min = min.min(p);
    _max = max.max(p);
  }

  Aabb2 inflated(double amount) => Aabb2.minMax(
    .new(min.x - amount, min.y - amount),
    .new(max.x + amount, max.y + amount),
  );

  bool contains(Vec2 p, {double inflate = 0}) =>
      p.x >= min.x - inflate && p.x <= max.x + inflate && p.y >= min.y - inflate && p.y <= max.y + inflate;

  bool containsAabb(Aabb2 other) =>
      other.min.x >= min.x && other.max.x <= max.x && other.min.y >= min.y && other.max.y <= max.y;

  bool intersectsAabb(Aabb2 other) =>
      min.x <= other.max.x && max.x >= other.min.x && min.y <= other.max.y && max.y >= other.min.y;

  double distance2To(Vec2 p) {
    final dx = math.max(math.max(min.x - p.x, 0.0), p.x - max.x);
    final dy = math.max(math.max(min.y - p.y, 0.0), p.y - max.y);
    return dx * dx + dy * dy;
  }

  double distanceTo(Vec2 p) => math.sqrt(distance2To(p));

  Aabb2 transformed(Mat4 m) {
    final a = m.transform2(Vec2(min.x, min.y));
    final b = m.transform2(Vec2(max.x, min.y));
    final c = m.transform2(Vec2(max.x, max.y));
    final d = m.transform2(Vec2(min.x, max.y));
    return .minMax(.min(a, .min(b, .min(c, d))), .max(a, .max(b, .max(c, d))));
  }

  Size2 get size => .new(max.x - min.x, max.y - min.y);
  double get width => max.x - min.x;
  double get height => max.y - min.y;
  double get aspectRatio => width / height;

  double get left => min.x;
  double get top => min.y;
  double get right => max.x;
  double get bottom => max.y;

  Vec2 get topLeft => min;
  Vec2 get topRight => .new(max.x, min.y);
  Vec2 get bottomRight => max;
  Vec2 get bottomLeft => .new(min.x, max.y);
  Vec2 get center => .new((min.x + max.x) * 0.5, (min.y + max.y) * 0.5);

  @override
  String toString() {
    return 'Aabb2(min: $min, max: $max)';
  }
}
