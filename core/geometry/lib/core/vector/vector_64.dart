import 'dart:math' as math;
import 'dart:typed_data';

extension type Vec2List._(Float64x2List buffer) implements Object {
  Vec2List(int length) : this._(Float64x2List(length));
  Vec2List.view(Float64x2List value) : this._(value);
  Vec2List.fromBuffer(Float64x2List buffer) : this._(.fromList(buffer));
  Vec2List.fromElementList(List<Float64x2> elements) : this._(.fromList(elements));
  Vec2List.fromFlat(Float64List elements) : this._(.sublistView(elements));
  Vec2List.sublistView(TypedData data, [int start = 0, int? end]) : this._(.sublistView(data, start, end));

  Vec2 operator [](int index) => ._(buffer[index]);
  void operator []=(int index, Vec2 vec) => buffer[index] = vec;

  int get length => buffer.length;
  bool get isEmpty => buffer.isEmpty;
  bool get isNotEmpty => buffer.isNotEmpty;

  Vec2List sublist(int start, [int? end]) => ._(buffer.sublist(start, end));
  Vec2List sublistView(int start, [int? end]) => ._(.sublistView(buffer, start, end));
}

extension type Vec2._(Float64x2 value) implements Float64x2 {
  Vec2(double x, double y) : this._(.new(x, y));
  Vec2.from(Float64x2 value) : this._(value);
  Vec2.zero() : this._(.zero());
  Vec2.min(Vec2 a, Vec2 b) : this._(a.value.min(b.value));
  Vec2.max(Vec2 a, Vec2 b) : this._(a.value.max(b.value));
  Vec2.lerp(Vec2 a, Vec2 b, double t) : this._(a.value + (b.value - a.value).scale(t));
  Vec2.rotation(double angleRad) : this._(.new(math.cos(angleRad), math.sin(angleRad)));

  Vec2 operator +(Vec2 other) => ._(value + other.value);
  Vec2 operator -(Vec2 other) => ._(value - other.value);
  Vec2 operator *(num scalar) => scale(scalar.toDouble());
  Vec2 operator /(num scalar) => scale(1.0 / scalar);
  Vec2 operator -() => ._(-value);

  Vec2 scale(double s) => ._(value.scale(s));
  Vec2 abs() => ._(value.abs());
  Vec2 sqrt() => ._(value.sqrt());

  Vec2 clamp(Vec2 min, Vec2 max) => ._(value.clamp(min, max));
  Vec2 min(Vec2 other) => ._(value.min(other));
  Vec2 max(Vec2 other) => ._(value.max(other));

  Vec2 withX(double x) => ._(value.withX(x));
  Vec2 withY(double y) => ._(value.withY(y));
}
