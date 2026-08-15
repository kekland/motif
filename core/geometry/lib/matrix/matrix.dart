import 'dart:math' as math;
import 'dart:typed_data';

import 'package:geometry/geometry.dart';

extension type const Mat4._(Float64x2List storage) {
  Mat4.fromList(List<Float64x2> storage) : this._(Float64x2List.fromList(storage));
  Mat4.fromListFloat64(List<double> storage) : this._(Float64List.fromList(storage).buffer.asFloat64x2List());
  Mat4.zero() : this._(Float64x2List(8));
  Mat4.copy(Mat4 other) : this._(.fromList(other.storage));
  Mat4.view(Float64x2List storage) : this._(storage);
  Mat4.viewFloat64(Float64List storage) : this._(storage.buffer.asFloat64x2List());

  factory Mat4.identity() {
    final s = Float64x2List(8);
    s[0] = Float64x2(1, 0);
    s[2] = Float64x2(0, 1);
    s[5] = Float64x2(1, 0);
    s[7] = Float64x2(0, 1);
    return Mat4._(s);
  }

  factory Mat4.inverse(Mat4 other) {
    final m = Mat4.copy(other);
    m.invert();
    return m;
  }

  factory Mat4.translation(double x, double y, [double z = 0]) {
    final m = Mat4.identity();
    m.storage[6] = .new(x, y);
    m.storage[7] = .new(z, 1);
    return m;
  }

  factory Mat4.translation2(Vec2 p) {
    final m = Mat4.identity();
    m.storage[6] = p;
    return m;
  }

  factory Mat4.scale(double sx, double sy, [double sz = 1]) {
    final s = Float64x2List(8);
    s[0] = .new(sx, 0);
    s[2] = .new(0, sy);
    s[5] = .new(sz, 0);
    s[7] = .new(0, 1);
    return Mat4._(s);
  }

  factory Mat4.rotationZ(double radians) {
    final c = math.cos(radians), s = math.sin(radians);
    final m = Mat4.identity();
    m.storage[0] = .new(c, s);
    m.storage[2] = .new(-s, c);
    return m;
  }

  double operator [](int index) {
    final slot = index >> 1;
    final isHigh = (index & 1) == 1;
    final value = storage[slot];
    return isHigh ? value.y : value.x;
  }

  void operator []=(int index, double v) {
    final slot = index >> 1;
    final isHigh = (index & 1) == 1;
    final value = storage[slot];
    storage[slot] = isHigh ? value.withY(v) : value.withX(v);
  }

  bool get isFlat2 {
    final c0hi = storage[1], c1hi = storage[3], c2lo = storage[4], c2hi = storage[5], c3hi = storage[7];
    return c0hi.x == 0 &&
        c0hi.y == 0 &&
        c1hi.x == 0 &&
        c1hi.y == 0 &&
        c2lo.x == 0 &&
        c2lo.y == 0 &&
        c2hi.x == 1 &&
        c2hi.y == 0 &&
        c3hi.x == 0 &&
        c3hi.y == 1;
  }

  Vec2 transform2(Vec2 p) {
    final r = storage[0].scale(p.x) + storage[2].scale(p.y) + storage[6];
    return .new(r.x, r.y);
  }

  Vec2 transformDelta2(Vec2 p) {
    final r = storage[0].scale(p.x) + storage[2].scale(p.y);
    return .new(r.x, r.y);
  }

  void multiply(Mat4 other) {
    final s = storage;
    final a0 = s[0], a0h = s[1], a1 = s[2], a1h = s[3];
    final a2 = s[4], a2h = s[5], a3 = s[6], a3h = s[7];
    final os = other.storage;
    for (var c = 0; c < 8; c += 2) {
      final blo = os[c], bhi = os[c + 1];
      s[c] = a0.scale(blo.x) + a1.scale(blo.y) + a2.scale(bhi.x) + a3.scale(bhi.y);
      s[c + 1] = a0h.scale(blo.x) + a1h.scale(blo.y) + a2h.scale(bhi.x) + a3h.scale(bhi.y);
    }
  }

  double invert() {
    if (isFlat2) {
      final c0 = storage[0], c1 = storage[2], t = storage[6];
      final det = c0.x * c1.y - c0.y * c1.x;
      if (det == 0) return 0;
      final inv = 1 / det;
      final i0 = Float64x2(c1.y * inv, -c0.y * inv);
      final i1 = Float64x2(-c1.x * inv, c0.x * inv);
      storage[0] = i0;
      storage[2] = i1;
      storage[6] = -(i0.scale(t.x) + i1.scale(t.y));
      return det;
    }

    return _invertMat4(this);
  }

  Mat4 operator *(Mat4 other) {
    final result = Mat4.copy(this);
    result.multiply(other);
    return result;
  }

  void scale(double sx, double sy, [double sz = 1]) {
    storage[0] = storage[0].scale(sx);
    storage[1] = storage[1].scale(sx);
    storage[2] = storage[2].scale(sy);
    storage[3] = storage[3].scale(sy);
    storage[4] = storage[4].scale(sz);
    storage[5] = storage[5].scale(sz);
  }

  double get scaleX => math.sqrt(this[0] * this[0] + this[1] * this[1] + this[2] * this[2]);
  double get scaleY => math.sqrt(this[4] * this[4] + this[5] * this[5] + this[6] * this[6]);
  double get scaleZ => math.sqrt(this[8] * this[8] + this[9] * this[9] + this[10] * this[10]);

  Mat4 withNormalizedScale() {
    final sx = scaleX;
    final sy = scaleY;
    final sz = scaleZ;
    final m = Mat4.copy(this);

    // dart format off
    if (sx > 0) { m[0] /= sx; m[1] /= sx; m[2] /= sx; }
    if (sy > 0) { m[4] /= sy; m[5] /= sy; m[6] /= sy; }
    if (sz > 0) { m[8] /= sz; m[9] /= sz; m[10] /= sz; }
    // dart format on

    return m;
  }

  Mat4 copy() => Mat4.view(.fromList(storage));

  // *******************************************************************************************************************
  // Translation
  // *******************************************************************************************************************

  Vec2 get translation2 => .from(storage[6]);

  void setTranslation(double x, double y, [double z = 0]) {
    storage[6] = .new(x, y);
    storage[7] = .new(z, 1);
  }

  void translate2(Vec2 v) => translate(v.x, v.y);
  void translate(double x, double y, [double z = 0]) {
    final t1 = this[0] * x + this[4] * y + this[8] * z + this[12];
    final t2 = this[1] * x + this[5] * y + this[9] * z + this[13];
    final t3 = this[2] * x + this[6] * y + this[10] * z + this[14];
    final t4 = this[3] * x + this[7] * y + this[11] * z + this[15];

    storage[6] = .new(t1, t2);
    storage[7] = .new(t3, t4);
  }

  Mat4 translated2(Vec2 v) => translated(v.x, v.y);
  Mat4 translated(double x, double y, [double z = 0]) {
    final m = copy();
    m.translate(x, y, z);
    return m;
  }

  Mat4 withTranslation2(Vec2 v) => withTranslation(v.x, v.y);
  Mat4 withTranslation(double x, double y, [double z = 0]) => copy()..setTranslation(x, y, z);

  // *******************************************************************************************************************
  // Rotation
  // *******************************************************************************************************************

  double get rotationZ {
    final c0 = storage[0];
    return math.atan2(c0.y, c0.x);
  }

  void setRotationZ(double rad) {
    final c = math.cos(rad), s = math.sin(rad);
    storage[0] = .new(c, s);
    storage[1] = .new(-s, c);
  }

  void rotateZ(double rad) {
    final c = math.cos(rad), s = math.sin(rad);

    final t1 = this[0] * c + this[4] * s;
    final t2 = this[1] * c + this[5] * s;
    final t3 = this[2] * c + this[6] * s;
    final t4 = this[3] * c + this[7] * s;
    final t5 = this[0] * -s + this[4] * c;
    final t6 = this[1] * -s + this[5] * c;
    final t7 = this[2] * -s + this[6] * c;
    final t8 = this[3] * -s + this[7] * c;
    this[0] = t1;
    this[1] = t2;
    this[2] = t3;
    this[3] = t4;
    this[4] = t5;
    this[5] = t6;
    this[6] = t7;
    this[7] = t8;
  }

  Mat4 rotatedZ(double rad) {
    final m = copy();
    m.rotateZ(rad);
    return m;
  }

  Mat4 withRotationZ(double rad) => copy()..setRotationZ(rad);
}

double _invertMat4(Mat4 m) {
  final s = m.storage;
  final s0 = s[0], s0h = s[1], s1 = s[2], s1h = s[3];
  final s2 = s[4], s2h = s[5], s3 = s[6], s3h = s[7];
  final a00 = s0.x, a01 = s0.y, a02 = s0h.x, a03 = s0h.y;
  final a10 = s1.x, a11 = s1.y, a12 = s1h.x, a13 = s1h.y;
  final a20 = s2.x, a21 = s2.y, a22 = s2h.x, a23 = s2h.y;
  final a30 = s3.x, a31 = s3.y, a32 = s3h.x, a33 = s3h.y;
  final b00 = a00 * a11 - a01 * a10;
  final b01 = a00 * a12 - a02 * a10;
  final b02 = a00 * a13 - a03 * a10;
  final b03 = a01 * a12 - a02 * a11;
  final b04 = a01 * a13 - a03 * a11;
  final b05 = a02 * a13 - a03 * a12;
  final b06 = a20 * a31 - a21 * a30;
  final b07 = a20 * a32 - a22 * a30;
  final b08 = a20 * a33 - a23 * a30;
  final b09 = a21 * a32 - a22 * a31;
  final b10 = a21 * a33 - a23 * a31;
  final b11 = a22 * a33 - a23 * a32;
  final det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;
  if (det == 0.0) return 0.0;
  final iv = 1.0 / det;
  s[0] = Float64x2((a11 * b11 - a12 * b10 + a13 * b09) * iv, (-a01 * b11 + a02 * b10 - a03 * b09) * iv);
  s[1] = Float64x2((a31 * b05 - a32 * b04 + a33 * b03) * iv, (-a21 * b05 + a22 * b04 - a23 * b03) * iv);
  s[2] = Float64x2((-a10 * b11 + a12 * b08 - a13 * b07) * iv, (a00 * b11 - a02 * b08 + a03 * b07) * iv);
  s[3] = Float64x2((-a30 * b05 + a32 * b02 - a33 * b01) * iv, (a20 * b05 - a22 * b02 + a23 * b01) * iv);
  s[4] = Float64x2((a10 * b10 - a11 * b08 + a13 * b06) * iv, (-a00 * b10 + a01 * b08 - a03 * b06) * iv);
  s[5] = Float64x2((a30 * b04 - a31 * b02 + a33 * b00) * iv, (-a20 * b04 + a21 * b02 - a23 * b00) * iv);
  s[6] = Float64x2((-a10 * b09 + a11 * b07 - a12 * b06) * iv, (a00 * b09 - a01 * b07 + a02 * b06) * iv);
  s[7] = Float64x2((-a30 * b03 + a31 * b01 - a32 * b00) * iv, (a20 * b03 - a21 * b01 + a22 * b00) * iv);
  return det;
}
