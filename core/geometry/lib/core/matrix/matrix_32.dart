import 'dart:math' as math;
import 'dart:typed_data';

import 'package:geometry/geometry_32.dart';

extension type const Mat4List._(Float32List buffer) implements Object {
  Mat4List(int length) : this._(Float32List(length * _stride));
  Mat4List.fromList(List<double> list) : this._(.fromList(list));
  Mat4List.fromBuffer(Float32List buffer): this._(.fromList(buffer));
  Mat4List.view(Float32List storage) : this._(storage);
  Mat4List.viewFlat(Float32List storage) : this._(storage);

  static const _stride = 16;

  int get length => buffer.length ~/ _stride;
  bool get isNotEmpty => buffer.isNotEmpty;
  bool get isEmpty => buffer.isEmpty;

  Mat4 operator [](int index) => .view(.sublistView(buffer, index * _stride, (index + 1) * _stride));
  void operator []=(int index, Mat4 value) => buffer.setRange(index * _stride, (index + 1) * _stride, value.storage);
}

extension type const Mat4._(Float32List storage) implements Object {
  Mat4.fromFlat(Float32List storage) : this._(.sublistView(storage));
  Mat4.zero() : this._(Float32List(16));
  Mat4.copy(Mat4 other) : this._(.fromList(other.storage));
  Mat4.view(Float32List storage) : this._(storage);
  Mat4.viewFlat(Float32List storage) : this._(storage);

  // dart format off
  factory Mat4.from(
    double m00, double m01, double m02, double m03,
    double m10, double m11, double m12, double m13,
    double m20, double m21, double m22, double m23,
    double m30, double m31, double m32, double m33,
  ) {
    final s = Float32List(16);
    s[0] = m00; s[1] = m01; s[2] = m02; s[3] = m03;
    s[4] = m10; s[5] = m11; s[6] = m12; s[7] = m13;
    s[8] = m20; s[9] = m21; s[10] = m22; s[11] = m23;
    s[12] = m30; s[13] = m31; s[14] = m32; s[15] = m33;
    return Mat4._(s);
  }

  double get m00 => this[0];  double get m01 => this[1];  double get m02 => this[2];  double get m03 => this[3];
  double get m10 => this[4];  double get m11 => this[5];  double get m12 => this[6];  double get m13 => this[7];
  double get m20 => this[8];  double get m21 => this[9];  double get m22 => this[10]; double get m23 => this[11];
  double get m30 => this[12]; double get m31 => this[13]; double get m32 => this[14]; double get m33 => this[15];

  bool get isFlat2 => this[2] == 0 && this[3] == 0 && this[6] == 0 && this[7] == 0 && this[8] == 0 && this[9] == 0 && this[10] == 1 && this[11] == 0 && this[14] == 0 && this[15] == 1;
  // dart format on

  Float32List get storageFlat => storage;

  factory Mat4.identity() {
    final s = Float32List(16);
    s[0] = 1;
    s[5] = 1;
    s[10] = 1;
    s[15] = 1;
    return Mat4._(s);
  }

  factory Mat4.inverse(Mat4 other) {
    final m = Mat4.copy(other);
    _invertMat4(m);
    return m;
  }

  factory Mat4.translation(double x, double y, [double z = 0]) {
    final m = Mat4.identity();
    m[12] = x;
    m[13] = y;
    m[14] = z;
    m[15] = 1;
    return m;
  }

  factory Mat4.translation2(Vec2 p) {
    final m = Mat4.identity();
    m[12] = p.x;
    m[13] = p.y;
    return m;
  }

  factory Mat4.scale(double sx, double sy, [double sz = 1]) {
    final s = Float32List(16);
    s[0] = sx;
    s[5] = sy;
    s[10] = sz;
    s[15] = 1;
    return Mat4._(s);
  }

  factory Mat4.rotationZ(double radians) {
    final c = math.cos(radians), s = math.sin(radians);
    final m = Mat4.identity();
    m[0] = c;
    m[1] = s;
    m[4] = -s;
    m[5] = c;
    return m;
  }

  double operator [](int index) => storage[index];
  void operator []=(int index, double v) => storage[index] = v;

  Vec2 transform2(Vec2 p) {
    return .new(
      this[0] * p.x + this[4] * p.y + this[12],
      this[1] * p.x + this[5] * p.y + this[13],
    );
  }

  Vec2 transformDelta2(Vec2 p) {
    return .new(
      this[0] * p.x + this[4] * p.y,
      this[1] * p.x + this[5] * p.y,
    );
  }

  Mat4 operator *(Mat4 other) {
    final result = Mat4.copy(this);
    result.multiply(other);
    return result;
  }

  void multiply(Mat4 other) {
    final os = other.storage;
    for (var c = 0; c < 16; c += 4) {
      final b0 = os[c], b1 = os[c + 1], b2 = os[c + 2], b3 = os[c + 3];
      this[c + 0] = m00 * b0 + m10 * b1 + m20 * b2 + m30 * b3;
      this[c + 1] = m01 * b0 + m11 * b1 + m21 * b2 + m31 * b3;
      this[c + 2] = m02 * b0 + m12 * b1 + m22 * b2 + m32 * b3;
      this[c + 3] = m03 * b0 + m13 * b1 + m23 * b2 + m33 * b3;
    }
  }

  double invert() {
    if (isFlat2) {
      final det = this[0] * this[5] - this[1] * this[4];
      if (det == 0) return 0;
      final inv = 1.0 / det;
      final i0x = this[5] * inv, i0y = -this[1] * inv;
      final i1x = -this[4] * inv, i1y = this[0] * inv;
      this[0] = i0x;
      this[1] = i0y;
      this[4] = i1x;
      this[5] = i1y;
      final tx = this[12], ty = this[13];
      this[12] = -(i0x * tx + i1x * ty);
      this[13] = -(i0y * tx + i1y * ty);
      return det;
    }

    return _invertMat4(this);
  }

  void scale(double sx, double sy, [double sz = 1]) {
    final s = storage;
    s[0] *= sx;
    s[1] *= sx;
    s[2] *= sx;
    s[3] *= sx;
    s[4] *= sy;
    s[5] *= sy;
    s[6] *= sy;
    s[7] *= sy;
    s[8] *= sz;
    s[9] *= sz;
    s[10] *= sz;
    s[11] *= sz;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Translation
  // -------------------------------------------------------------------------------------------------------------------

Vec2 get translation2 => .new(this[12], this[13]);

  void setTranslation(double x, double y, [double z = 0]) {
    this[12] = x;
    this[13] = y;
    this[14] = z;
    this[15] = 1;
  }

  void translate2(Vec2 v) => translate(v.x, v.y);
  void translate(double x, double y, [double z = 0]) {
    final t1 = this[0] * x + this[4] * y + this[8] * z + this[12];
    final t2 = this[1] * x + this[5] * y + this[9] * z + this[13];
    final t3 = this[2] * x + this[6] * y + this[10] * z + this[14];
    final t4 = this[3] * x + this[7] * y + this[11] * z + this[15];

    this[12] = t1;
    this[13] = t2;
    this[14] = t3;
    this[15] = t4;
  }

  Mat4 translated2(Vec2 v) => translated(v.x, v.y);
  Mat4 translated(double x, double y, [double z = 0]) {
    final m = Mat4.copy(this);
    m.translate(x, y, z);
    return m;
  }

  Mat4 withTranslation2(Vec2 v) => withTranslation(v.x, v.y);
  Mat4 withTranslation(double x, double y, [double z = 0]) => Mat4.copy(this)..setTranslation(x, y, z);

  // -------------------------------------------------------------------------------------------------------------------
  // Rotation
  // -------------------------------------------------------------------------------------------------------------------

  double get rotationZ => math.atan2(this[1], this[0]);

  void setRotationZ(double rad) {
    final c = math.cos(rad), s = math.sin(rad);
    this[0] = c;
    this[1] = s;
    this[4] = -s;
    this[5] = c;
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
    final m = Mat4.copy(this);
    m.rotateZ(rad);
    return m;
  }

  Mat4 withRotationZ(double rad) => Mat4.copy(this)..setRotationZ(rad);
}

double _invertMat4(Mat4 m) {
  final a00 = m[0], a01 = m[1], a02 = m[2], a03 = m[3];
  final a10 = m[4], a11 = m[5], a12 = m[6], a13 = m[7];
  final a20 = m[8], a21 = m[9], a22 = m[10], a23 = m[11];
  final a30 = m[12], a31 = m[13], a32 = m[14], a33 = m[15];
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
  m[0] = (a11 * b11 - a12 * b10 + a13 * b09) * iv;
  m[1] = (-a01 * b11 + a02 * b10 - a03 * b09) * iv;
  m[2] = (a31 * b05 - a32 * b04 + a33 * b03) * iv;
  m[3] = (-a21 * b05 + a22 * b04 - a23 * b03) * iv;
  m[4] = (-a10 * b11 + a12 * b08 - a13 * b07) * iv;
  m[5] = (a00 * b11 - a02 * b08 + a03 * b07) * iv;
  m[6] = (-a30 * b05 + a32 * b02 - a33 * b01) * iv;
  m[7] = (a20 * b05 - a22 * b02 + a23 * b01) * iv;
  m[8] = (a10 * b10 - a11 * b08 + a13 * b06) * iv;
  m[9] = (-a00 * b10 + a01 * b08 - a03 * b06) * iv;
  m[10] = (a30 * b04 - a31 * b02 + a33 * b00) * iv;
  m[11] = (-a20 * b04 + a21 * b02 - a23 * b00) * iv;
  m[12] = (-a10 * b09 + a11 * b07 - a12 * b06) * iv;
  m[13] = (a00 * b09 - a01 * b07 + a02 * b06) * iv;
  m[14] = (-a30 * b03 + a31 * b01 - a32 * b00) * iv;
  m[15] = (a20 * b03 - a21 * b01 + a22 * b00) * iv;
  return det;
}
