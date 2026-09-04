import 'dart:math' as math;
import 'dart:typed_data';

import 'package:geometry/geometry.dart';

extension type Vec2List._(Float64x2List value) implements Float64x2List {
  Vec2List(int length) : this._(Float64x2List(length));
  Vec2List.view(Float64x2List value) : this._(value);
  Vec2List.fromList(List<Float64x2> elements) : this._(.fromList(elements));
  Vec2List.sublistView(TypedData data, [int start = 0, int? end]) : this._(.sublistView(data, start, end));

  Vec2 operator [](int index) => Vec2.from(value[index]);
  void operator []=(int index, Vec2 vec) => value[index] = vec;

  int get length => value.length;

  Vec2List sublist(int start, [int? end]) => ._(value.sublist(start, end));
}

extension type Vec2._(Float64x2 value) implements Float64x2 {
  Vec2(double x, double y) : this._(.new(x, y));
  Vec2.from(Float64x2 value) : this._(value);
  Vec2.zero() : this._(.zero());
  Vec2.min(Vec2 a, Vec2 b) : this._(a.value.min(b.value));
  Vec2.max(Vec2 a, Vec2 b) : this._(a.value.max(b.value));

  Vec2 operator +(Vec2 other) => .from(value + other);
  Vec2 operator -(Vec2 other) => .from(value - other);
  Vec2 operator *(num scalar) => scale(scalar.toDouble());
  Vec2 operator /(num scalar) => scale(1.0 / scalar);
  Vec2 operator -() => .from(-value);

  double dot(Vec2 other) => x * other.x + y * other.y;
  double cross(Vec2 other) => x * other.y - y * other.x;

  double get length2 => value.x * value.x + value.y * value.y;
  double get length => math.sqrt(length2);

  double distance2To(Vec2 other) => (x - other.x) * (x - other.x) + (y - other.y) * (y - other.y);
  double distanceTo(Vec2 other) => math.sqrt(distance2To(other));

  Vec2 multiply(Vec2 other) => .new(x * other.x, y * other.y);

  Vec2 normalized() => this / length;
  Vec2 abs() => .from(value.abs());

  Vec2 scale(double s) => .from(value.scale(s));
  Vec2 sqrt() => .from(value.sqrt());

  Vec2 clamp(Vec2 min, Vec2 max) => .from(value.clamp(min, max));
  Vec2 min(Vec2 other) => .from(value.min(other));
  Vec2 max(Vec2 other) => .from(value.max(other));

  Vec2 withX(double x) => .from(value.withX(x));
  Vec2 withY(double y) => .from(value.withY(y));

  bool equals(Vec2 other, [double epsilon = 1e-12]) {
    return (x - other.x).abs() < epsilon && (y - other.y).abs() < epsilon;
  }

  Vec2 pointReflect(Vec2 p) {
    return p * 2 - this;
  }

  bool exactEquals(Vec2 other) => value.x == other.x && value.y == other.y;

  Aabb2 aabb(Vec2 other) => Aabb2.minMax(this, other);
  Aabb2 operator &(Size2 size) => Aabb2.ltwh(x, y, size.width, size.height);
}
