import 'dart:math' as math;

import 'package:geometry/gen/_import.dart';

extension Vec2ListImpl on Vec2List {
  void transform(Mat4 m) {
    for (var i = 0; i < length; i++) this[i] = m.transform2(this[i]);
  }
}

extension Vec2Impl on Vec2 {
  double dot(Vec2 other) => x * other.x + y * other.y;
  double cross(Vec2 other) => x * other.y - y * other.x;

  double get length2 => x * x + y * y;
  double get length => math.sqrt(length2);
  Vec2 normalized() => this / length;

  double distance2To(Vec2 other) => (x - other.x) * (x - other.x) + (y - other.y) * (y - other.y);
  double distanceTo(Vec2 other) => math.sqrt(distance2To(other));

  Vec2 multiply(Vec2 other) => .new(x * other.x, y * other.y);

  bool equals(Vec2 other, [double epsilon = 1e-12]) {
    return (x - other.x).abs() < epsilon && (y - other.y).abs() < epsilon;
  }

  bool isZero([double epsilon = 1e-12]) => x.abs() < epsilon && y.abs() < epsilon;
  bool get isFinite => x.isFinite && y.isFinite;

  Vec2 pointReflect(Vec2 p) {
    return p * 2 - this;
  }

  bool exactEquals(Vec2 other) => x == other.x && y == other.y;

  Aabb2 aabb(Vec2 other) => Aabb2.bbox2(this, other);
  Aabb2 operator &(Size2 size) => Aabb2.ltwh(x, y, size.width, size.height);

  Vec2 round() => .new(x.roundToDouble(), y.roundToDouble());
  Vec2 floor() => .new(x.floorToDouble(), y.floorToDouble());
  Vec2 ceil() => .new(x.ceilToDouble(), y.ceilToDouble());

  Vec2 snappedToAxis() {
    if (x.abs() > y.abs()) {
      return Vec2(x, 0);
    } else {
      return Vec2(0, y);
    }
  }

  Vec2 snappedToAngle(double angleRad) {
    if (angleRad == 0.0) return this;
    final length = this.length;
    if (length == 0) return this;

    final currentAngle = math.atan2(y, x);
    final snappedAngle = (currentAngle / angleRad).round() * angleRad;
    final delta = snappedAngle - currentAngle;
    if (delta == 0.0) return this;

    final cosD = math.cos(delta);
    final sinD = math.sin(delta);

    return .new(x * cosD - y * sinD, x * sinD + y * cosD);
  }
}
