import 'dart:math' as math;
import 'dart:typed_data';

extension type Vec2List._(Float32List buffer) implements Object {
  Vec2List(int length) : this._(Float32List(length * 2));
  Vec2List.view(Float32List value) : this._(value);
  Vec2List.fromBuffer(Float32List buffer) : this._(.fromList(buffer));
  factory Vec2List.fromElementList(List<Vec2> elements) {
    final flat = Float32List(elements.length * 2);
    for (var i = 0; i < elements.length; i++) {
      flat[i * 2] = elements[i].value.$1;
      flat[i * 2 + 1] = elements[i].value.$2;
    }
    return Vec2List.fromFlat(flat);
  }

  Vec2List.fromFlat(Float32List elements) : this._(.fromList(elements));
  Vec2List.sublistView(TypedData data, [int start = 0, int? end])
    : this._(.sublistView(data, start * 2, end != null ? end * 2 : null));

  Vec2 operator [](int index) => ._((buffer[index * 2], buffer[index * 2 + 1]));
  void operator []=(int index, Vec2 vec) {
    buffer[index * 2] = vec.value.$1;
    buffer[index * 2 + 1] = vec.value.$2;
  }

  int get length => buffer.length ~/ 2;
  bool get isEmpty => buffer.isEmpty;
  bool get isNotEmpty => buffer.isNotEmpty;

  Vec2List sublist(int start, [int? end]) => ._(buffer.sublist(start * 2, end != null ? end * 2 : null));
  Vec2List sublistView(int start, [int? end]) => ._(.sublistView(buffer, start * 2, end != null ? end * 2 : null));
}

extension type Vec2._((double, double) value) implements Object {
  Vec2(double x, double y) : this._((x, y));
  Vec2.zero() : this._((0, 0));
  Vec2.min(Vec2 a, Vec2 b) : this._((math.min(a.x, b.x), math.min(a.y, b.y)));
  Vec2.max(Vec2 a, Vec2 b) : this._((math.max(a.x, b.x), math.max(a.y, b.y)));
  Vec2.lerp(Vec2 a, Vec2 b, double t) : this._((a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t));
  Vec2.rotation(double angleRad) : this._((math.cos(angleRad), math.sin(angleRad)));

  double get x => value.$1;
  double get y => value.$2;

  Vec2 operator +(Vec2 other) => .new(x + other.x, y + other.y);
  Vec2 operator -(Vec2 other) => .new(x - other.x, y - other.y);
  Vec2 operator *(num scalar) => scale(scalar.toDouble());
  Vec2 operator /(num scalar) => scale(1.0 / scalar);
  Vec2 operator -() => .new(-x, -y);

  Vec2 scale(double s) => .new(x * s, y * s);
  Vec2 abs() => .new(x.abs(), y.abs());
  Vec2 sqrt() => .new(math.sqrt(x), math.sqrt(y));

  Vec2 clamp(Vec2 min, Vec2 max) => .new(x.clamp(min.x, max.x), y.clamp(min.y, max.y));
  Vec2 min(Vec2 other) => .new(math.min(x, other.x), math.min(y, other.y));
  Vec2 max(Vec2 other) => .new(math.max(x, other.x), math.max(y, other.y));

  Vec2 withX(double x) => .new(x, y);
  Vec2 withY(double y) => .new(x, y);
}
