// ignore_for_file: non_constant_identifier_names, unused_element

part of 'wgsl.dart';

// dart format off
extension type const F32(double _) implements double {
  static const F32 zero = F32(0);

  @pragma('vm:prefer-inline')
  F32.from(double v): this(v);

  @pragma('vm:prefer-inline')
  F32.read(ByteData data, int offset): this(data.getFloat32(offset, .little));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) => data.setFloat32(offset, _, .little);
}

extension type const I32(int _) implements int {
  static const I32 zero = I32(0);

  @pragma('vm:prefer-inline')
  I32.from(int v): this(v);

  @pragma('vm:prefer-inline')
  I32.read(ByteData data, int offset): this(data.getInt32(offset, .little));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) => data.setInt32(offset, _, .little);
}

extension type const U32(int _) implements int {
  static const U32 zero = U32(0);

  @pragma('vm:prefer-inline')
  U32.from(int v): this(v);

  @pragma('vm:prefer-inline')
  U32.read(ByteData data, int offset): this(data.getUint32(offset, .little));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) => data.setUint32(offset, _, .little);
}

extension type const F16(double _) implements double {
  static const F16 zero = F16(0);

  @pragma('vm:prefer-inline')
  F16.from(double v): this(v);

  @pragma('vm:prefer-inline')
  F16.read(ByteData data, int offset): this(data.getFloat16(offset, .little));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) => data.setFloat16(offset, _, .little);
}

extension type const Vec2f((double, double) _) {
  static const Vec2f zero = Vec2f((0, 0));

  F32 get x => F32(_.$1);
  F32 get y => F32(_.$2);

  @pragma('vm:prefer-inline')
  Vec2f.fromVector32(vm32.Vector2 v): this((
    v.x,
    v.y,
  ));

  @pragma('vm:prefer-inline')
  Vec2f.fromVector64(vm64.Vector2 v): this((
    v.x,
    v.y,
  ));

  @pragma('vm:prefer-inline')
  vm32.Vector2 toVector32() => vm32.Vector2(
    _.$1,
    _.$2,
  );

  @pragma('vm:prefer-inline')
  vm64.Vector2 toVector64() => vm64.Vector2(
    _.$1,
    _.$2,
  );

  @pragma('vm:prefer-inline')
  Vec2f.read(ByteData data, int offset): this((
    data.getFloat32(offset + 0, .little),
    data.getFloat32(offset + 4, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat32(offset + 0, _.$1, .little);
    data.setFloat32(offset + 4, _.$2, .little);
  }
}

extension type const Vec3f((double, double, double) _) {
  static const Vec3f zero = Vec3f((0, 0, 0));

  F32 get x => F32(_.$1);
  F32 get y => F32(_.$2);
  F32 get z => F32(_.$3);

  @pragma('vm:prefer-inline')
  Vec3f.fromVector32(vm32.Vector3 v): this((
    v.x,
    v.y,
    v.z,
  ));

  @pragma('vm:prefer-inline')
  Vec3f.fromVector64(vm64.Vector3 v): this((
    v.x,
    v.y,
    v.z,
  ));

  @pragma('vm:prefer-inline')
  vm32.Vector3 toVector32() => vm32.Vector3(
    _.$1,
    _.$2,
    _.$3,
  );

  @pragma('vm:prefer-inline')
  vm64.Vector3 toVector64() => vm64.Vector3(
    _.$1,
    _.$2,
    _.$3,
  );

  @pragma('vm:prefer-inline')
  Vec3f.read(ByteData data, int offset): this((
    data.getFloat32(offset + 0, .little),
    data.getFloat32(offset + 4, .little),
    data.getFloat32(offset + 8, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat32(offset + 0, _.$1, .little);
    data.setFloat32(offset + 4, _.$2, .little);
    data.setFloat32(offset + 8, _.$3, .little);
  }
}

extension type const Vec4f((double, double, double, double) _) {
  static const Vec4f zero = Vec4f((0, 0, 0, 0));

  F32 get x => F32(_.$1);
  F32 get y => F32(_.$2);
  F32 get z => F32(_.$3);
  F32 get w => F32(_.$4);

  @pragma('vm:prefer-inline')
  Vec4f.fromVector32(vm32.Vector4 v): this((
    v.x,
    v.y,
    v.z,
    v.w,
  ));

  @pragma('vm:prefer-inline')
  Vec4f.fromVector64(vm64.Vector4 v): this((
    v.x,
    v.y,
    v.z,
    v.w,
  ));

  @pragma('vm:prefer-inline')
  vm32.Vector4 toVector32() => vm32.Vector4(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
  );

  @pragma('vm:prefer-inline')
  vm64.Vector4 toVector64() => vm64.Vector4(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
  );

  @pragma('vm:prefer-inline')
  Vec4f.read(ByteData data, int offset): this((
    data.getFloat32(offset + 0, .little),
    data.getFloat32(offset + 4, .little),
    data.getFloat32(offset + 8, .little),
    data.getFloat32(offset + 12, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat32(offset + 0, _.$1, .little);
    data.setFloat32(offset + 4, _.$2, .little);
    data.setFloat32(offset + 8, _.$3, .little);
    data.setFloat32(offset + 12, _.$4, .little);
  }
}

extension type const Vec2i((int, int) _) {
  static const Vec2i zero = Vec2i((0, 0));

  I32 get x => I32(_.$1);
  I32 get y => I32(_.$2);

  @pragma('vm:prefer-inline')
  Vec2i.fromVector32(vm32.Vector2 v): this((
    v.x.toInt(),
    v.y.toInt(),
  ));

  @pragma('vm:prefer-inline')
  Vec2i.fromVector64(vm64.Vector2 v): this((
    v.x.toInt(),
    v.y.toInt(),
  ));

  @pragma('vm:prefer-inline')
  vm32.Vector2 toVector32() => vm32.Vector2(
    _.$1.toDouble(),
    _.$2.toDouble(),
  );

  @pragma('vm:prefer-inline')
  vm64.Vector2 toVector64() => vm64.Vector2(
    _.$1.toDouble(),
    _.$2.toDouble(),
  );

  @pragma('vm:prefer-inline')
  Vec2i.read(ByteData data, int offset): this((
    data.getInt32(offset + 0, .little),
    data.getInt32(offset + 4, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setInt32(offset + 0, _.$1, .little);
    data.setInt32(offset + 4, _.$2, .little);
  }
}

extension type const Vec3i((int, int, int) _) {
  static const Vec3i zero = Vec3i((0, 0, 0));

  I32 get x => I32(_.$1);
  I32 get y => I32(_.$2);
  I32 get z => I32(_.$3);

  @pragma('vm:prefer-inline')
  Vec3i.fromVector32(vm32.Vector3 v): this((
    v.x.toInt(),
    v.y.toInt(),
    v.z.toInt(),
  ));

  @pragma('vm:prefer-inline')
  Vec3i.fromVector64(vm64.Vector3 v): this((
    v.x.toInt(),
    v.y.toInt(),
    v.z.toInt(),
  ));

  @pragma('vm:prefer-inline')
  vm32.Vector3 toVector32() => vm32.Vector3(
    _.$1.toDouble(),
    _.$2.toDouble(),
    _.$3.toDouble(),
  );

  @pragma('vm:prefer-inline')
  vm64.Vector3 toVector64() => vm64.Vector3(
    _.$1.toDouble(),
    _.$2.toDouble(),
    _.$3.toDouble(),
  );

  @pragma('vm:prefer-inline')
  Vec3i.read(ByteData data, int offset): this((
    data.getInt32(offset + 0, .little),
    data.getInt32(offset + 4, .little),
    data.getInt32(offset + 8, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setInt32(offset + 0, _.$1, .little);
    data.setInt32(offset + 4, _.$2, .little);
    data.setInt32(offset + 8, _.$3, .little);
  }
}

extension type const Vec4i((int, int, int, int) _) {
  static const Vec4i zero = Vec4i((0, 0, 0, 0));

  I32 get x => I32(_.$1);
  I32 get y => I32(_.$2);
  I32 get z => I32(_.$3);
  I32 get w => I32(_.$4);

  @pragma('vm:prefer-inline')
  Vec4i.fromVector32(vm32.Vector4 v): this((
    v.x.toInt(),
    v.y.toInt(),
    v.z.toInt(),
    v.w.toInt(),
  ));

  @pragma('vm:prefer-inline')
  Vec4i.fromVector64(vm64.Vector4 v): this((
    v.x.toInt(),
    v.y.toInt(),
    v.z.toInt(),
    v.w.toInt(),
  ));

  @pragma('vm:prefer-inline')
  vm32.Vector4 toVector32() => vm32.Vector4(
    _.$1.toDouble(),
    _.$2.toDouble(),
    _.$3.toDouble(),
    _.$4.toDouble(),
  );

  @pragma('vm:prefer-inline')
  vm64.Vector4 toVector64() => vm64.Vector4(
    _.$1.toDouble(),
    _.$2.toDouble(),
    _.$3.toDouble(),
    _.$4.toDouble(),
  );

  @pragma('vm:prefer-inline')
  Vec4i.read(ByteData data, int offset): this((
    data.getInt32(offset + 0, .little),
    data.getInt32(offset + 4, .little),
    data.getInt32(offset + 8, .little),
    data.getInt32(offset + 12, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setInt32(offset + 0, _.$1, .little);
    data.setInt32(offset + 4, _.$2, .little);
    data.setInt32(offset + 8, _.$3, .little);
    data.setInt32(offset + 12, _.$4, .little);
  }
}

extension type const Vec2u((int, int) _) {
  static const Vec2u zero = Vec2u((0, 0));

  U32 get x => U32(_.$1);
  U32 get y => U32(_.$2);

  @pragma('vm:prefer-inline')
  Vec2u.fromVector32(vm32.Vector2 v): this((
    v.x.toInt(),
    v.y.toInt(),
  ));

  @pragma('vm:prefer-inline')
  Vec2u.fromVector64(vm64.Vector2 v): this((
    v.x.toInt(),
    v.y.toInt(),
  ));

  @pragma('vm:prefer-inline')
  vm32.Vector2 toVector32() => vm32.Vector2(
    _.$1.toDouble(),
    _.$2.toDouble(),
  );

  @pragma('vm:prefer-inline')
  vm64.Vector2 toVector64() => vm64.Vector2(
    _.$1.toDouble(),
    _.$2.toDouble(),
  );

  @pragma('vm:prefer-inline')
  Vec2u.read(ByteData data, int offset): this((
    data.getUint32(offset + 0, .little),
    data.getUint32(offset + 4, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setUint32(offset + 0, _.$1, .little);
    data.setUint32(offset + 4, _.$2, .little);
  }
}

extension type const Vec3u((int, int, int) _) {
  static const Vec3u zero = Vec3u((0, 0, 0));

  U32 get x => U32(_.$1);
  U32 get y => U32(_.$2);
  U32 get z => U32(_.$3);

  @pragma('vm:prefer-inline')
  Vec3u.fromVector32(vm32.Vector3 v): this((
    v.x.toInt(),
    v.y.toInt(),
    v.z.toInt(),
  ));

  @pragma('vm:prefer-inline')
  Vec3u.fromVector64(vm64.Vector3 v): this((
    v.x.toInt(),
    v.y.toInt(),
    v.z.toInt(),
  ));

  @pragma('vm:prefer-inline')
  vm32.Vector3 toVector32() => vm32.Vector3(
    _.$1.toDouble(),
    _.$2.toDouble(),
    _.$3.toDouble(),
  );

  @pragma('vm:prefer-inline')
  vm64.Vector3 toVector64() => vm64.Vector3(
    _.$1.toDouble(),
    _.$2.toDouble(),
    _.$3.toDouble(),
  );

  @pragma('vm:prefer-inline')
  Vec3u.read(ByteData data, int offset): this((
    data.getUint32(offset + 0, .little),
    data.getUint32(offset + 4, .little),
    data.getUint32(offset + 8, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setUint32(offset + 0, _.$1, .little);
    data.setUint32(offset + 4, _.$2, .little);
    data.setUint32(offset + 8, _.$3, .little);
  }
}

extension type const Vec4u((int, int, int, int) _) {
  static const Vec4u zero = Vec4u((0, 0, 0, 0));

  U32 get x => U32(_.$1);
  U32 get y => U32(_.$2);
  U32 get z => U32(_.$3);
  U32 get w => U32(_.$4);

  @pragma('vm:prefer-inline')
  Vec4u.fromVector32(vm32.Vector4 v): this((
    v.x.toInt(),
    v.y.toInt(),
    v.z.toInt(),
    v.w.toInt(),
  ));

  @pragma('vm:prefer-inline')
  Vec4u.fromVector64(vm64.Vector4 v): this((
    v.x.toInt(),
    v.y.toInt(),
    v.z.toInt(),
    v.w.toInt(),
  ));

  @pragma('vm:prefer-inline')
  vm32.Vector4 toVector32() => vm32.Vector4(
    _.$1.toDouble(),
    _.$2.toDouble(),
    _.$3.toDouble(),
    _.$4.toDouble(),
  );

  @pragma('vm:prefer-inline')
  vm64.Vector4 toVector64() => vm64.Vector4(
    _.$1.toDouble(),
    _.$2.toDouble(),
    _.$3.toDouble(),
    _.$4.toDouble(),
  );

  @pragma('vm:prefer-inline')
  Vec4u.read(ByteData data, int offset): this((
    data.getUint32(offset + 0, .little),
    data.getUint32(offset + 4, .little),
    data.getUint32(offset + 8, .little),
    data.getUint32(offset + 12, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setUint32(offset + 0, _.$1, .little);
    data.setUint32(offset + 4, _.$2, .little);
    data.setUint32(offset + 8, _.$3, .little);
    data.setUint32(offset + 12, _.$4, .little);
  }
}

extension type const Vec2h((double, double) _) {
  static const Vec2h zero = Vec2h((0, 0));

  F16 get x => F16(_.$1);
  F16 get y => F16(_.$2);

  @pragma('vm:prefer-inline')
  Vec2h.fromVector32(vm32.Vector2 v): this((
    v.x,
    v.y,
  ));

  @pragma('vm:prefer-inline')
  Vec2h.fromVector64(vm64.Vector2 v): this((
    v.x,
    v.y,
  ));

  @pragma('vm:prefer-inline')
  vm32.Vector2 toVector32() => vm32.Vector2(
    _.$1,
    _.$2,
  );

  @pragma('vm:prefer-inline')
  vm64.Vector2 toVector64() => vm64.Vector2(
    _.$1,
    _.$2,
  );

  @pragma('vm:prefer-inline')
  Vec2h.read(ByteData data, int offset): this((
    data.getFloat16(offset + 0, .little),
    data.getFloat16(offset + 4, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat16(offset + 0, _.$1, .little);
    data.setFloat16(offset + 4, _.$2, .little);
  }
}

extension type const Vec3h((double, double, double) _) {
  static const Vec3h zero = Vec3h((0, 0, 0));

  F16 get x => F16(_.$1);
  F16 get y => F16(_.$2);
  F16 get z => F16(_.$3);

  @pragma('vm:prefer-inline')
  Vec3h.fromVector32(vm32.Vector3 v): this((
    v.x,
    v.y,
    v.z,
  ));

  @pragma('vm:prefer-inline')
  Vec3h.fromVector64(vm64.Vector3 v): this((
    v.x,
    v.y,
    v.z,
  ));

  @pragma('vm:prefer-inline')
  vm32.Vector3 toVector32() => vm32.Vector3(
    _.$1,
    _.$2,
    _.$3,
  );

  @pragma('vm:prefer-inline')
  vm64.Vector3 toVector64() => vm64.Vector3(
    _.$1,
    _.$2,
    _.$3,
  );

  @pragma('vm:prefer-inline')
  Vec3h.read(ByteData data, int offset): this((
    data.getFloat16(offset + 0, .little),
    data.getFloat16(offset + 4, .little),
    data.getFloat16(offset + 8, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat16(offset + 0, _.$1, .little);
    data.setFloat16(offset + 4, _.$2, .little);
    data.setFloat16(offset + 8, _.$3, .little);
  }
}

extension type const Vec4h((double, double, double, double) _) {
  static const Vec4h zero = Vec4h((0, 0, 0, 0));

  F16 get x => F16(_.$1);
  F16 get y => F16(_.$2);
  F16 get z => F16(_.$3);
  F16 get w => F16(_.$4);

  @pragma('vm:prefer-inline')
  Vec4h.fromVector32(vm32.Vector4 v): this((
    v.x,
    v.y,
    v.z,
    v.w,
  ));

  @pragma('vm:prefer-inline')
  Vec4h.fromVector64(vm64.Vector4 v): this((
    v.x,
    v.y,
    v.z,
    v.w,
  ));

  @pragma('vm:prefer-inline')
  vm32.Vector4 toVector32() => vm32.Vector4(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
  );

  @pragma('vm:prefer-inline')
  vm64.Vector4 toVector64() => vm64.Vector4(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
  );

  @pragma('vm:prefer-inline')
  Vec4h.read(ByteData data, int offset): this((
    data.getFloat16(offset + 0, .little),
    data.getFloat16(offset + 4, .little),
    data.getFloat16(offset + 8, .little),
    data.getFloat16(offset + 12, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat16(offset + 0, _.$1, .little);
    data.setFloat16(offset + 4, _.$2, .little);
    data.setFloat16(offset + 8, _.$3, .little);
    data.setFloat16(offset + 12, _.$4, .little);
  }
}

extension type const Mat2x2f((double, double, double, double) _) {
  static const Mat2x2f identity = Mat2x2f((1, 0, 0, 1));

  F32 get m00 => F32(_.$1);
  F32 get m01 => F32(_.$2);
  F32 get m10 => F32(_.$3);
  F32 get m11 => F32(_.$4);

  @pragma('vm:prefer-inline')
  F32 operator [](int index) => switch (index) {
    0 => F32(_.$1),
    1 => F32(_.$2),
    2 => F32(_.$3),
    3 => F32(_.$4),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat2x2f.fromMatrix32(vm32.Matrix2 v): this((
    v[0],
    v[1],
    v[2],
    v[3],
  ));

  @pragma('vm:prefer-inline')
  Mat2x2f.fromMatrix64(vm64.Matrix2 v): this((
    v[0],
    v[1],
    v[2],
    v[3],
  ));

  @pragma('vm:prefer-inline')
  vm32.Matrix2 toMatrix32() => vm32.Matrix2(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
  );

  @pragma('vm:prefer-inline')
  vm64.Matrix2 toMatrix64() => vm64.Matrix2(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
  );

  @pragma('vm:prefer-inline')
  Mat2x2f.read(ByteData data, int offset): this((
    data.getFloat32(offset + 0, .little),
    data.getFloat32(offset + 4, .little),
    data.getFloat32(offset + 8, .little),
    data.getFloat32(offset + 12, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat32(offset + 0, _.$1, .little);
    data.setFloat32(offset + 4, _.$2, .little);
    data.setFloat32(offset + 8, _.$3, .little);
    data.setFloat32(offset + 12, _.$4, .little);
  }
}

extension type const Mat2x3f((double, double, double, double, double, double) _) {
  static const Mat2x3f identity = Mat2x3f((1, 0, 0, 0, 1, 0));

  F32 get m00 => F32(_.$1);
  F32 get m01 => F32(_.$2);
  F32 get m02 => F32(_.$3);
  F32 get m10 => F32(_.$4);
  F32 get m11 => F32(_.$5);
  F32 get m12 => F32(_.$6);

  @pragma('vm:prefer-inline')
  F32 operator [](int index) => switch (index) {
    0 => F32(_.$1),
    1 => F32(_.$2),
    2 => F32(_.$3),
    3 => F32(_.$4),
    4 => F32(_.$5),
    5 => F32(_.$6),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat2x3f.read(ByteData data, int offset): this((
    data.getFloat32(offset + 0, .little),
    data.getFloat32(offset + 4, .little),
    data.getFloat32(offset + 8, .little),
    data.getFloat32(offset + 12, .little),
    data.getFloat32(offset + 16, .little),
    data.getFloat32(offset + 20, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat32(offset + 0, _.$1, .little);
    data.setFloat32(offset + 4, _.$2, .little);
    data.setFloat32(offset + 8, _.$3, .little);
    data.setFloat32(offset + 12, _.$4, .little);
    data.setFloat32(offset + 16, _.$5, .little);
    data.setFloat32(offset + 20, _.$6, .little);
  }
}

extension type const Mat2x4f((double, double, double, double, double, double, double, double) _) {
  static const Mat2x4f identity = Mat2x4f((1, 0, 0, 0, 0, 1, 0, 0));

  F32 get m00 => F32(_.$1);
  F32 get m01 => F32(_.$2);
  F32 get m02 => F32(_.$3);
  F32 get m03 => F32(_.$4);
  F32 get m10 => F32(_.$5);
  F32 get m11 => F32(_.$6);
  F32 get m12 => F32(_.$7);
  F32 get m13 => F32(_.$8);

  @pragma('vm:prefer-inline')
  F32 operator [](int index) => switch (index) {
    0 => F32(_.$1),
    1 => F32(_.$2),
    2 => F32(_.$3),
    3 => F32(_.$4),
    4 => F32(_.$5),
    5 => F32(_.$6),
    6 => F32(_.$7),
    7 => F32(_.$8),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat2x4f.read(ByteData data, int offset): this((
    data.getFloat32(offset + 0, .little),
    data.getFloat32(offset + 4, .little),
    data.getFloat32(offset + 8, .little),
    data.getFloat32(offset + 12, .little),
    data.getFloat32(offset + 16, .little),
    data.getFloat32(offset + 20, .little),
    data.getFloat32(offset + 24, .little),
    data.getFloat32(offset + 28, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat32(offset + 0, _.$1, .little);
    data.setFloat32(offset + 4, _.$2, .little);
    data.setFloat32(offset + 8, _.$3, .little);
    data.setFloat32(offset + 12, _.$4, .little);
    data.setFloat32(offset + 16, _.$5, .little);
    data.setFloat32(offset + 20, _.$6, .little);
    data.setFloat32(offset + 24, _.$7, .little);
    data.setFloat32(offset + 28, _.$8, .little);
  }
}

extension type const Mat3x2f((double, double, double, double, double, double) _) {
  static const Mat3x2f identity = Mat3x2f((1, 0, 0, 1, 0, 0));

  F32 get m00 => F32(_.$1);
  F32 get m01 => F32(_.$2);
  F32 get m10 => F32(_.$3);
  F32 get m11 => F32(_.$4);
  F32 get m20 => F32(_.$5);
  F32 get m21 => F32(_.$6);

  @pragma('vm:prefer-inline')
  F32 operator [](int index) => switch (index) {
    0 => F32(_.$1),
    1 => F32(_.$2),
    2 => F32(_.$3),
    3 => F32(_.$4),
    4 => F32(_.$5),
    5 => F32(_.$6),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat3x2f.read(ByteData data, int offset): this((
    data.getFloat32(offset + 0, .little),
    data.getFloat32(offset + 4, .little),
    data.getFloat32(offset + 8, .little),
    data.getFloat32(offset + 12, .little),
    data.getFloat32(offset + 16, .little),
    data.getFloat32(offset + 20, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat32(offset + 0, _.$1, .little);
    data.setFloat32(offset + 4, _.$2, .little);
    data.setFloat32(offset + 8, _.$3, .little);
    data.setFloat32(offset + 12, _.$4, .little);
    data.setFloat32(offset + 16, _.$5, .little);
    data.setFloat32(offset + 20, _.$6, .little);
  }
}

extension type const Mat3x3f((double, double, double, double, double, double, double, double, double) _) {
  static const Mat3x3f identity = Mat3x3f((1, 0, 0, 0, 1, 0, 0, 0, 1));

  F32 get m00 => F32(_.$1);
  F32 get m01 => F32(_.$2);
  F32 get m02 => F32(_.$3);
  F32 get m10 => F32(_.$4);
  F32 get m11 => F32(_.$5);
  F32 get m12 => F32(_.$6);
  F32 get m20 => F32(_.$7);
  F32 get m21 => F32(_.$8);
  F32 get m22 => F32(_.$9);

  @pragma('vm:prefer-inline')
  F32 operator [](int index) => switch (index) {
    0 => F32(_.$1),
    1 => F32(_.$2),
    2 => F32(_.$3),
    3 => F32(_.$4),
    4 => F32(_.$5),
    5 => F32(_.$6),
    6 => F32(_.$7),
    7 => F32(_.$8),
    8 => F32(_.$9),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat3x3f.fromMatrix32(vm32.Matrix3 v): this((
    v[0],
    v[1],
    v[2],
    v[3],
    v[4],
    v[5],
    v[6],
    v[7],
    v[8],
  ));

  @pragma('vm:prefer-inline')
  Mat3x3f.fromMatrix64(vm64.Matrix3 v): this((
    v[0],
    v[1],
    v[2],
    v[3],
    v[4],
    v[5],
    v[6],
    v[7],
    v[8],
  ));

  @pragma('vm:prefer-inline')
  vm32.Matrix3 toMatrix32() => vm32.Matrix3(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
    _.$5,
    _.$6,
    _.$7,
    _.$8,
    _.$9,
  );

  @pragma('vm:prefer-inline')
  vm64.Matrix3 toMatrix64() => vm64.Matrix3(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
    _.$5,
    _.$6,
    _.$7,
    _.$8,
    _.$9,
  );

  @pragma('vm:prefer-inline')
  Mat3x3f.read(ByteData data, int offset): this((
    data.getFloat32(offset + 0, .little),
    data.getFloat32(offset + 4, .little),
    data.getFloat32(offset + 8, .little),
    data.getFloat32(offset + 12, .little),
    data.getFloat32(offset + 16, .little),
    data.getFloat32(offset + 20, .little),
    data.getFloat32(offset + 24, .little),
    data.getFloat32(offset + 28, .little),
    data.getFloat32(offset + 32, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat32(offset + 0, _.$1, .little);
    data.setFloat32(offset + 4, _.$2, .little);
    data.setFloat32(offset + 8, _.$3, .little);
    data.setFloat32(offset + 12, _.$4, .little);
    data.setFloat32(offset + 16, _.$5, .little);
    data.setFloat32(offset + 20, _.$6, .little);
    data.setFloat32(offset + 24, _.$7, .little);
    data.setFloat32(offset + 28, _.$8, .little);
    data.setFloat32(offset + 32, _.$9, .little);
  }
}

extension type const Mat3x4f((double, double, double, double, double, double, double, double, double, double, double, double) _) {
  static const Mat3x4f identity = Mat3x4f((1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0));

  F32 get m00 => F32(_.$1);
  F32 get m01 => F32(_.$2);
  F32 get m02 => F32(_.$3);
  F32 get m03 => F32(_.$4);
  F32 get m10 => F32(_.$5);
  F32 get m11 => F32(_.$6);
  F32 get m12 => F32(_.$7);
  F32 get m13 => F32(_.$8);
  F32 get m20 => F32(_.$9);
  F32 get m21 => F32(_.$10);
  F32 get m22 => F32(_.$11);
  F32 get m23 => F32(_.$12);

  @pragma('vm:prefer-inline')
  F32 operator [](int index) => switch (index) {
    0 => F32(_.$1),
    1 => F32(_.$2),
    2 => F32(_.$3),
    3 => F32(_.$4),
    4 => F32(_.$5),
    5 => F32(_.$6),
    6 => F32(_.$7),
    7 => F32(_.$8),
    8 => F32(_.$9),
    9 => F32(_.$10),
    10 => F32(_.$11),
    11 => F32(_.$12),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat3x4f.read(ByteData data, int offset): this((
    data.getFloat32(offset + 0, .little),
    data.getFloat32(offset + 4, .little),
    data.getFloat32(offset + 8, .little),
    data.getFloat32(offset + 12, .little),
    data.getFloat32(offset + 16, .little),
    data.getFloat32(offset + 20, .little),
    data.getFloat32(offset + 24, .little),
    data.getFloat32(offset + 28, .little),
    data.getFloat32(offset + 32, .little),
    data.getFloat32(offset + 36, .little),
    data.getFloat32(offset + 40, .little),
    data.getFloat32(offset + 44, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat32(offset + 0, _.$1, .little);
    data.setFloat32(offset + 4, _.$2, .little);
    data.setFloat32(offset + 8, _.$3, .little);
    data.setFloat32(offset + 12, _.$4, .little);
    data.setFloat32(offset + 16, _.$5, .little);
    data.setFloat32(offset + 20, _.$6, .little);
    data.setFloat32(offset + 24, _.$7, .little);
    data.setFloat32(offset + 28, _.$8, .little);
    data.setFloat32(offset + 32, _.$9, .little);
    data.setFloat32(offset + 36, _.$10, .little);
    data.setFloat32(offset + 40, _.$11, .little);
    data.setFloat32(offset + 44, _.$12, .little);
  }
}

extension type const Mat4x2f((double, double, double, double, double, double, double, double) _) {
  static const Mat4x2f identity = Mat4x2f((1, 0, 0, 1, 0, 0, 0, 0));

  F32 get m00 => F32(_.$1);
  F32 get m01 => F32(_.$2);
  F32 get m10 => F32(_.$3);
  F32 get m11 => F32(_.$4);
  F32 get m20 => F32(_.$5);
  F32 get m21 => F32(_.$6);
  F32 get m30 => F32(_.$7);
  F32 get m31 => F32(_.$8);

  @pragma('vm:prefer-inline')
  F32 operator [](int index) => switch (index) {
    0 => F32(_.$1),
    1 => F32(_.$2),
    2 => F32(_.$3),
    3 => F32(_.$4),
    4 => F32(_.$5),
    5 => F32(_.$6),
    6 => F32(_.$7),
    7 => F32(_.$8),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat4x2f.read(ByteData data, int offset): this((
    data.getFloat32(offset + 0, .little),
    data.getFloat32(offset + 4, .little),
    data.getFloat32(offset + 8, .little),
    data.getFloat32(offset + 12, .little),
    data.getFloat32(offset + 16, .little),
    data.getFloat32(offset + 20, .little),
    data.getFloat32(offset + 24, .little),
    data.getFloat32(offset + 28, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat32(offset + 0, _.$1, .little);
    data.setFloat32(offset + 4, _.$2, .little);
    data.setFloat32(offset + 8, _.$3, .little);
    data.setFloat32(offset + 12, _.$4, .little);
    data.setFloat32(offset + 16, _.$5, .little);
    data.setFloat32(offset + 20, _.$6, .little);
    data.setFloat32(offset + 24, _.$7, .little);
    data.setFloat32(offset + 28, _.$8, .little);
  }
}

extension type const Mat4x3f((double, double, double, double, double, double, double, double, double, double, double, double) _) {
  static const Mat4x3f identity = Mat4x3f((1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0));

  F32 get m00 => F32(_.$1);
  F32 get m01 => F32(_.$2);
  F32 get m02 => F32(_.$3);
  F32 get m10 => F32(_.$4);
  F32 get m11 => F32(_.$5);
  F32 get m12 => F32(_.$6);
  F32 get m20 => F32(_.$7);
  F32 get m21 => F32(_.$8);
  F32 get m22 => F32(_.$9);
  F32 get m30 => F32(_.$10);
  F32 get m31 => F32(_.$11);
  F32 get m32 => F32(_.$12);

  @pragma('vm:prefer-inline')
  F32 operator [](int index) => switch (index) {
    0 => F32(_.$1),
    1 => F32(_.$2),
    2 => F32(_.$3),
    3 => F32(_.$4),
    4 => F32(_.$5),
    5 => F32(_.$6),
    6 => F32(_.$7),
    7 => F32(_.$8),
    8 => F32(_.$9),
    9 => F32(_.$10),
    10 => F32(_.$11),
    11 => F32(_.$12),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat4x3f.read(ByteData data, int offset): this((
    data.getFloat32(offset + 0, .little),
    data.getFloat32(offset + 4, .little),
    data.getFloat32(offset + 8, .little),
    data.getFloat32(offset + 12, .little),
    data.getFloat32(offset + 16, .little),
    data.getFloat32(offset + 20, .little),
    data.getFloat32(offset + 24, .little),
    data.getFloat32(offset + 28, .little),
    data.getFloat32(offset + 32, .little),
    data.getFloat32(offset + 36, .little),
    data.getFloat32(offset + 40, .little),
    data.getFloat32(offset + 44, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat32(offset + 0, _.$1, .little);
    data.setFloat32(offset + 4, _.$2, .little);
    data.setFloat32(offset + 8, _.$3, .little);
    data.setFloat32(offset + 12, _.$4, .little);
    data.setFloat32(offset + 16, _.$5, .little);
    data.setFloat32(offset + 20, _.$6, .little);
    data.setFloat32(offset + 24, _.$7, .little);
    data.setFloat32(offset + 28, _.$8, .little);
    data.setFloat32(offset + 32, _.$9, .little);
    data.setFloat32(offset + 36, _.$10, .little);
    data.setFloat32(offset + 40, _.$11, .little);
    data.setFloat32(offset + 44, _.$12, .little);
  }
}

extension type const Mat4x4f((double, double, double, double, double, double, double, double, double, double, double, double, double, double, double, double) _) {
  static const Mat4x4f identity = Mat4x4f((1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1));

  F32 get m00 => F32(_.$1);
  F32 get m01 => F32(_.$2);
  F32 get m02 => F32(_.$3);
  F32 get m03 => F32(_.$4);
  F32 get m10 => F32(_.$5);
  F32 get m11 => F32(_.$6);
  F32 get m12 => F32(_.$7);
  F32 get m13 => F32(_.$8);
  F32 get m20 => F32(_.$9);
  F32 get m21 => F32(_.$10);
  F32 get m22 => F32(_.$11);
  F32 get m23 => F32(_.$12);
  F32 get m30 => F32(_.$13);
  F32 get m31 => F32(_.$14);
  F32 get m32 => F32(_.$15);
  F32 get m33 => F32(_.$16);

  @pragma('vm:prefer-inline')
  F32 operator [](int index) => switch (index) {
    0 => F32(_.$1),
    1 => F32(_.$2),
    2 => F32(_.$3),
    3 => F32(_.$4),
    4 => F32(_.$5),
    5 => F32(_.$6),
    6 => F32(_.$7),
    7 => F32(_.$8),
    8 => F32(_.$9),
    9 => F32(_.$10),
    10 => F32(_.$11),
    11 => F32(_.$12),
    12 => F32(_.$13),
    13 => F32(_.$14),
    14 => F32(_.$15),
    15 => F32(_.$16),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat4x4f.fromMatrix32(vm32.Matrix4 v): this((
    v[0],
    v[1],
    v[2],
    v[3],
    v[4],
    v[5],
    v[6],
    v[7],
    v[8],
    v[9],
    v[10],
    v[11],
    v[12],
    v[13],
    v[14],
    v[15],
  ));

  @pragma('vm:prefer-inline')
  Mat4x4f.fromMatrix64(vm64.Matrix4 v): this((
    v[0],
    v[1],
    v[2],
    v[3],
    v[4],
    v[5],
    v[6],
    v[7],
    v[8],
    v[9],
    v[10],
    v[11],
    v[12],
    v[13],
    v[14],
    v[15],
  ));

  @pragma('vm:prefer-inline')
  vm32.Matrix4 toMatrix32() => vm32.Matrix4(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
    _.$5,
    _.$6,
    _.$7,
    _.$8,
    _.$9,
    _.$10,
    _.$11,
    _.$12,
    _.$13,
    _.$14,
    _.$15,
    _.$16,
  );

  @pragma('vm:prefer-inline')
  vm64.Matrix4 toMatrix64() => vm64.Matrix4(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
    _.$5,
    _.$6,
    _.$7,
    _.$8,
    _.$9,
    _.$10,
    _.$11,
    _.$12,
    _.$13,
    _.$14,
    _.$15,
    _.$16,
  );

  @pragma('vm:prefer-inline')
  Mat4x4f.read(ByteData data, int offset): this((
    data.getFloat32(offset + 0, .little),
    data.getFloat32(offset + 4, .little),
    data.getFloat32(offset + 8, .little),
    data.getFloat32(offset + 12, .little),
    data.getFloat32(offset + 16, .little),
    data.getFloat32(offset + 20, .little),
    data.getFloat32(offset + 24, .little),
    data.getFloat32(offset + 28, .little),
    data.getFloat32(offset + 32, .little),
    data.getFloat32(offset + 36, .little),
    data.getFloat32(offset + 40, .little),
    data.getFloat32(offset + 44, .little),
    data.getFloat32(offset + 48, .little),
    data.getFloat32(offset + 52, .little),
    data.getFloat32(offset + 56, .little),
    data.getFloat32(offset + 60, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat32(offset + 0, _.$1, .little);
    data.setFloat32(offset + 4, _.$2, .little);
    data.setFloat32(offset + 8, _.$3, .little);
    data.setFloat32(offset + 12, _.$4, .little);
    data.setFloat32(offset + 16, _.$5, .little);
    data.setFloat32(offset + 20, _.$6, .little);
    data.setFloat32(offset + 24, _.$7, .little);
    data.setFloat32(offset + 28, _.$8, .little);
    data.setFloat32(offset + 32, _.$9, .little);
    data.setFloat32(offset + 36, _.$10, .little);
    data.setFloat32(offset + 40, _.$11, .little);
    data.setFloat32(offset + 44, _.$12, .little);
    data.setFloat32(offset + 48, _.$13, .little);
    data.setFloat32(offset + 52, _.$14, .little);
    data.setFloat32(offset + 56, _.$15, .little);
    data.setFloat32(offset + 60, _.$16, .little);
  }
}

extension type const Mat2x2h((double, double, double, double) _) {
  static const Mat2x2h identity = Mat2x2h((1, 0, 0, 1));

  F16 get m00 => F16(_.$1);
  F16 get m01 => F16(_.$2);
  F16 get m10 => F16(_.$3);
  F16 get m11 => F16(_.$4);

  @pragma('vm:prefer-inline')
  F16 operator [](int index) => switch (index) {
    0 => F16(_.$1),
    1 => F16(_.$2),
    2 => F16(_.$3),
    3 => F16(_.$4),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat2x2h.fromMatrix32(vm32.Matrix2 v): this((
    v[0],
    v[1],
    v[2],
    v[3],
  ));

  @pragma('vm:prefer-inline')
  Mat2x2h.fromMatrix64(vm64.Matrix2 v): this((
    v[0],
    v[1],
    v[2],
    v[3],
  ));

  @pragma('vm:prefer-inline')
  vm32.Matrix2 toMatrix32() => vm32.Matrix2(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
  );

  @pragma('vm:prefer-inline')
  vm64.Matrix2 toMatrix64() => vm64.Matrix2(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
  );

  @pragma('vm:prefer-inline')
  Mat2x2h.read(ByteData data, int offset): this((
    data.getFloat16(offset + 0, .little),
    data.getFloat16(offset + 4, .little),
    data.getFloat16(offset + 8, .little),
    data.getFloat16(offset + 12, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat16(offset + 0, _.$1, .little);
    data.setFloat16(offset + 4, _.$2, .little);
    data.setFloat16(offset + 8, _.$3, .little);
    data.setFloat16(offset + 12, _.$4, .little);
  }
}

extension type const Mat2x3h((double, double, double, double, double, double) _) {
  static const Mat2x3h identity = Mat2x3h((1, 0, 0, 0, 1, 0));

  F16 get m00 => F16(_.$1);
  F16 get m01 => F16(_.$2);
  F16 get m02 => F16(_.$3);
  F16 get m10 => F16(_.$4);
  F16 get m11 => F16(_.$5);
  F16 get m12 => F16(_.$6);

  @pragma('vm:prefer-inline')
  F16 operator [](int index) => switch (index) {
    0 => F16(_.$1),
    1 => F16(_.$2),
    2 => F16(_.$3),
    3 => F16(_.$4),
    4 => F16(_.$5),
    5 => F16(_.$6),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat2x3h.read(ByteData data, int offset): this((
    data.getFloat16(offset + 0, .little),
    data.getFloat16(offset + 4, .little),
    data.getFloat16(offset + 8, .little),
    data.getFloat16(offset + 12, .little),
    data.getFloat16(offset + 16, .little),
    data.getFloat16(offset + 20, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat16(offset + 0, _.$1, .little);
    data.setFloat16(offset + 4, _.$2, .little);
    data.setFloat16(offset + 8, _.$3, .little);
    data.setFloat16(offset + 12, _.$4, .little);
    data.setFloat16(offset + 16, _.$5, .little);
    data.setFloat16(offset + 20, _.$6, .little);
  }
}

extension type const Mat2x4h((double, double, double, double, double, double, double, double) _) {
  static const Mat2x4h identity = Mat2x4h((1, 0, 0, 0, 0, 1, 0, 0));

  F16 get m00 => F16(_.$1);
  F16 get m01 => F16(_.$2);
  F16 get m02 => F16(_.$3);
  F16 get m03 => F16(_.$4);
  F16 get m10 => F16(_.$5);
  F16 get m11 => F16(_.$6);
  F16 get m12 => F16(_.$7);
  F16 get m13 => F16(_.$8);

  @pragma('vm:prefer-inline')
  F16 operator [](int index) => switch (index) {
    0 => F16(_.$1),
    1 => F16(_.$2),
    2 => F16(_.$3),
    3 => F16(_.$4),
    4 => F16(_.$5),
    5 => F16(_.$6),
    6 => F16(_.$7),
    7 => F16(_.$8),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat2x4h.read(ByteData data, int offset): this((
    data.getFloat16(offset + 0, .little),
    data.getFloat16(offset + 4, .little),
    data.getFloat16(offset + 8, .little),
    data.getFloat16(offset + 12, .little),
    data.getFloat16(offset + 16, .little),
    data.getFloat16(offset + 20, .little),
    data.getFloat16(offset + 24, .little),
    data.getFloat16(offset + 28, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat16(offset + 0, _.$1, .little);
    data.setFloat16(offset + 4, _.$2, .little);
    data.setFloat16(offset + 8, _.$3, .little);
    data.setFloat16(offset + 12, _.$4, .little);
    data.setFloat16(offset + 16, _.$5, .little);
    data.setFloat16(offset + 20, _.$6, .little);
    data.setFloat16(offset + 24, _.$7, .little);
    data.setFloat16(offset + 28, _.$8, .little);
  }
}

extension type const Mat3x2h((double, double, double, double, double, double) _) {
  static const Mat3x2h identity = Mat3x2h((1, 0, 0, 1, 0, 0));

  F16 get m00 => F16(_.$1);
  F16 get m01 => F16(_.$2);
  F16 get m10 => F16(_.$3);
  F16 get m11 => F16(_.$4);
  F16 get m20 => F16(_.$5);
  F16 get m21 => F16(_.$6);

  @pragma('vm:prefer-inline')
  F16 operator [](int index) => switch (index) {
    0 => F16(_.$1),
    1 => F16(_.$2),
    2 => F16(_.$3),
    3 => F16(_.$4),
    4 => F16(_.$5),
    5 => F16(_.$6),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat3x2h.read(ByteData data, int offset): this((
    data.getFloat16(offset + 0, .little),
    data.getFloat16(offset + 4, .little),
    data.getFloat16(offset + 8, .little),
    data.getFloat16(offset + 12, .little),
    data.getFloat16(offset + 16, .little),
    data.getFloat16(offset + 20, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat16(offset + 0, _.$1, .little);
    data.setFloat16(offset + 4, _.$2, .little);
    data.setFloat16(offset + 8, _.$3, .little);
    data.setFloat16(offset + 12, _.$4, .little);
    data.setFloat16(offset + 16, _.$5, .little);
    data.setFloat16(offset + 20, _.$6, .little);
  }
}

extension type const Mat3x3h((double, double, double, double, double, double, double, double, double) _) {
  static const Mat3x3h identity = Mat3x3h((1, 0, 0, 0, 1, 0, 0, 0, 1));

  F16 get m00 => F16(_.$1);
  F16 get m01 => F16(_.$2);
  F16 get m02 => F16(_.$3);
  F16 get m10 => F16(_.$4);
  F16 get m11 => F16(_.$5);
  F16 get m12 => F16(_.$6);
  F16 get m20 => F16(_.$7);
  F16 get m21 => F16(_.$8);
  F16 get m22 => F16(_.$9);

  @pragma('vm:prefer-inline')
  F16 operator [](int index) => switch (index) {
    0 => F16(_.$1),
    1 => F16(_.$2),
    2 => F16(_.$3),
    3 => F16(_.$4),
    4 => F16(_.$5),
    5 => F16(_.$6),
    6 => F16(_.$7),
    7 => F16(_.$8),
    8 => F16(_.$9),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat3x3h.fromMatrix32(vm32.Matrix3 v): this((
    v[0],
    v[1],
    v[2],
    v[3],
    v[4],
    v[5],
    v[6],
    v[7],
    v[8],
  ));

  @pragma('vm:prefer-inline')
  Mat3x3h.fromMatrix64(vm64.Matrix3 v): this((
    v[0],
    v[1],
    v[2],
    v[3],
    v[4],
    v[5],
    v[6],
    v[7],
    v[8],
  ));

  @pragma('vm:prefer-inline')
  vm32.Matrix3 toMatrix32() => vm32.Matrix3(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
    _.$5,
    _.$6,
    _.$7,
    _.$8,
    _.$9,
  );

  @pragma('vm:prefer-inline')
  vm64.Matrix3 toMatrix64() => vm64.Matrix3(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
    _.$5,
    _.$6,
    _.$7,
    _.$8,
    _.$9,
  );

  @pragma('vm:prefer-inline')
  Mat3x3h.read(ByteData data, int offset): this((
    data.getFloat16(offset + 0, .little),
    data.getFloat16(offset + 4, .little),
    data.getFloat16(offset + 8, .little),
    data.getFloat16(offset + 12, .little),
    data.getFloat16(offset + 16, .little),
    data.getFloat16(offset + 20, .little),
    data.getFloat16(offset + 24, .little),
    data.getFloat16(offset + 28, .little),
    data.getFloat16(offset + 32, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat16(offset + 0, _.$1, .little);
    data.setFloat16(offset + 4, _.$2, .little);
    data.setFloat16(offset + 8, _.$3, .little);
    data.setFloat16(offset + 12, _.$4, .little);
    data.setFloat16(offset + 16, _.$5, .little);
    data.setFloat16(offset + 20, _.$6, .little);
    data.setFloat16(offset + 24, _.$7, .little);
    data.setFloat16(offset + 28, _.$8, .little);
    data.setFloat16(offset + 32, _.$9, .little);
  }
}

extension type const Mat3x4h((double, double, double, double, double, double, double, double, double, double, double, double) _) {
  static const Mat3x4h identity = Mat3x4h((1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0));

  F16 get m00 => F16(_.$1);
  F16 get m01 => F16(_.$2);
  F16 get m02 => F16(_.$3);
  F16 get m03 => F16(_.$4);
  F16 get m10 => F16(_.$5);
  F16 get m11 => F16(_.$6);
  F16 get m12 => F16(_.$7);
  F16 get m13 => F16(_.$8);
  F16 get m20 => F16(_.$9);
  F16 get m21 => F16(_.$10);
  F16 get m22 => F16(_.$11);
  F16 get m23 => F16(_.$12);

  @pragma('vm:prefer-inline')
  F16 operator [](int index) => switch (index) {
    0 => F16(_.$1),
    1 => F16(_.$2),
    2 => F16(_.$3),
    3 => F16(_.$4),
    4 => F16(_.$5),
    5 => F16(_.$6),
    6 => F16(_.$7),
    7 => F16(_.$8),
    8 => F16(_.$9),
    9 => F16(_.$10),
    10 => F16(_.$11),
    11 => F16(_.$12),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat3x4h.read(ByteData data, int offset): this((
    data.getFloat16(offset + 0, .little),
    data.getFloat16(offset + 4, .little),
    data.getFloat16(offset + 8, .little),
    data.getFloat16(offset + 12, .little),
    data.getFloat16(offset + 16, .little),
    data.getFloat16(offset + 20, .little),
    data.getFloat16(offset + 24, .little),
    data.getFloat16(offset + 28, .little),
    data.getFloat16(offset + 32, .little),
    data.getFloat16(offset + 36, .little),
    data.getFloat16(offset + 40, .little),
    data.getFloat16(offset + 44, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat16(offset + 0, _.$1, .little);
    data.setFloat16(offset + 4, _.$2, .little);
    data.setFloat16(offset + 8, _.$3, .little);
    data.setFloat16(offset + 12, _.$4, .little);
    data.setFloat16(offset + 16, _.$5, .little);
    data.setFloat16(offset + 20, _.$6, .little);
    data.setFloat16(offset + 24, _.$7, .little);
    data.setFloat16(offset + 28, _.$8, .little);
    data.setFloat16(offset + 32, _.$9, .little);
    data.setFloat16(offset + 36, _.$10, .little);
    data.setFloat16(offset + 40, _.$11, .little);
    data.setFloat16(offset + 44, _.$12, .little);
  }
}

extension type const Mat4x2h((double, double, double, double, double, double, double, double) _) {
  static const Mat4x2h identity = Mat4x2h((1, 0, 0, 1, 0, 0, 0, 0));

  F16 get m00 => F16(_.$1);
  F16 get m01 => F16(_.$2);
  F16 get m10 => F16(_.$3);
  F16 get m11 => F16(_.$4);
  F16 get m20 => F16(_.$5);
  F16 get m21 => F16(_.$6);
  F16 get m30 => F16(_.$7);
  F16 get m31 => F16(_.$8);

  @pragma('vm:prefer-inline')
  F16 operator [](int index) => switch (index) {
    0 => F16(_.$1),
    1 => F16(_.$2),
    2 => F16(_.$3),
    3 => F16(_.$4),
    4 => F16(_.$5),
    5 => F16(_.$6),
    6 => F16(_.$7),
    7 => F16(_.$8),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat4x2h.read(ByteData data, int offset): this((
    data.getFloat16(offset + 0, .little),
    data.getFloat16(offset + 4, .little),
    data.getFloat16(offset + 8, .little),
    data.getFloat16(offset + 12, .little),
    data.getFloat16(offset + 16, .little),
    data.getFloat16(offset + 20, .little),
    data.getFloat16(offset + 24, .little),
    data.getFloat16(offset + 28, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat16(offset + 0, _.$1, .little);
    data.setFloat16(offset + 4, _.$2, .little);
    data.setFloat16(offset + 8, _.$3, .little);
    data.setFloat16(offset + 12, _.$4, .little);
    data.setFloat16(offset + 16, _.$5, .little);
    data.setFloat16(offset + 20, _.$6, .little);
    data.setFloat16(offset + 24, _.$7, .little);
    data.setFloat16(offset + 28, _.$8, .little);
  }
}

extension type const Mat4x3h((double, double, double, double, double, double, double, double, double, double, double, double) _) {
  static const Mat4x3h identity = Mat4x3h((1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0));

  F16 get m00 => F16(_.$1);
  F16 get m01 => F16(_.$2);
  F16 get m02 => F16(_.$3);
  F16 get m10 => F16(_.$4);
  F16 get m11 => F16(_.$5);
  F16 get m12 => F16(_.$6);
  F16 get m20 => F16(_.$7);
  F16 get m21 => F16(_.$8);
  F16 get m22 => F16(_.$9);
  F16 get m30 => F16(_.$10);
  F16 get m31 => F16(_.$11);
  F16 get m32 => F16(_.$12);

  @pragma('vm:prefer-inline')
  F16 operator [](int index) => switch (index) {
    0 => F16(_.$1),
    1 => F16(_.$2),
    2 => F16(_.$3),
    3 => F16(_.$4),
    4 => F16(_.$5),
    5 => F16(_.$6),
    6 => F16(_.$7),
    7 => F16(_.$8),
    8 => F16(_.$9),
    9 => F16(_.$10),
    10 => F16(_.$11),
    11 => F16(_.$12),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat4x3h.read(ByteData data, int offset): this((
    data.getFloat16(offset + 0, .little),
    data.getFloat16(offset + 4, .little),
    data.getFloat16(offset + 8, .little),
    data.getFloat16(offset + 12, .little),
    data.getFloat16(offset + 16, .little),
    data.getFloat16(offset + 20, .little),
    data.getFloat16(offset + 24, .little),
    data.getFloat16(offset + 28, .little),
    data.getFloat16(offset + 32, .little),
    data.getFloat16(offset + 36, .little),
    data.getFloat16(offset + 40, .little),
    data.getFloat16(offset + 44, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat16(offset + 0, _.$1, .little);
    data.setFloat16(offset + 4, _.$2, .little);
    data.setFloat16(offset + 8, _.$3, .little);
    data.setFloat16(offset + 12, _.$4, .little);
    data.setFloat16(offset + 16, _.$5, .little);
    data.setFloat16(offset + 20, _.$6, .little);
    data.setFloat16(offset + 24, _.$7, .little);
    data.setFloat16(offset + 28, _.$8, .little);
    data.setFloat16(offset + 32, _.$9, .little);
    data.setFloat16(offset + 36, _.$10, .little);
    data.setFloat16(offset + 40, _.$11, .little);
    data.setFloat16(offset + 44, _.$12, .little);
  }
}

extension type const Mat4x4h((double, double, double, double, double, double, double, double, double, double, double, double, double, double, double, double) _) {
  static const Mat4x4h identity = Mat4x4h((1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1));

  F16 get m00 => F16(_.$1);
  F16 get m01 => F16(_.$2);
  F16 get m02 => F16(_.$3);
  F16 get m03 => F16(_.$4);
  F16 get m10 => F16(_.$5);
  F16 get m11 => F16(_.$6);
  F16 get m12 => F16(_.$7);
  F16 get m13 => F16(_.$8);
  F16 get m20 => F16(_.$9);
  F16 get m21 => F16(_.$10);
  F16 get m22 => F16(_.$11);
  F16 get m23 => F16(_.$12);
  F16 get m30 => F16(_.$13);
  F16 get m31 => F16(_.$14);
  F16 get m32 => F16(_.$15);
  F16 get m33 => F16(_.$16);

  @pragma('vm:prefer-inline')
  F16 operator [](int index) => switch (index) {
    0 => F16(_.$1),
    1 => F16(_.$2),
    2 => F16(_.$3),
    3 => F16(_.$4),
    4 => F16(_.$5),
    5 => F16(_.$6),
    6 => F16(_.$7),
    7 => F16(_.$8),
    8 => F16(_.$9),
    9 => F16(_.$10),
    10 => F16(_.$11),
    11 => F16(_.$12),
    12 => F16(_.$13),
    13 => F16(_.$14),
    14 => F16(_.$15),
    15 => F16(_.$16),
    _ => throw RangeError.index(index, this, 'index'),
  };

  @pragma('vm:prefer-inline')
  Mat4x4h.fromMatrix32(vm32.Matrix4 v): this((
    v[0],
    v[1],
    v[2],
    v[3],
    v[4],
    v[5],
    v[6],
    v[7],
    v[8],
    v[9],
    v[10],
    v[11],
    v[12],
    v[13],
    v[14],
    v[15],
  ));

  @pragma('vm:prefer-inline')
  Mat4x4h.fromMatrix64(vm64.Matrix4 v): this((
    v[0],
    v[1],
    v[2],
    v[3],
    v[4],
    v[5],
    v[6],
    v[7],
    v[8],
    v[9],
    v[10],
    v[11],
    v[12],
    v[13],
    v[14],
    v[15],
  ));

  @pragma('vm:prefer-inline')
  vm32.Matrix4 toMatrix32() => vm32.Matrix4(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
    _.$5,
    _.$6,
    _.$7,
    _.$8,
    _.$9,
    _.$10,
    _.$11,
    _.$12,
    _.$13,
    _.$14,
    _.$15,
    _.$16,
  );

  @pragma('vm:prefer-inline')
  vm64.Matrix4 toMatrix64() => vm64.Matrix4(
    _.$1,
    _.$2,
    _.$3,
    _.$4,
    _.$5,
    _.$6,
    _.$7,
    _.$8,
    _.$9,
    _.$10,
    _.$11,
    _.$12,
    _.$13,
    _.$14,
    _.$15,
    _.$16,
  );

  @pragma('vm:prefer-inline')
  Mat4x4h.read(ByteData data, int offset): this((
    data.getFloat16(offset + 0, .little),
    data.getFloat16(offset + 4, .little),
    data.getFloat16(offset + 8, .little),
    data.getFloat16(offset + 12, .little),
    data.getFloat16(offset + 16, .little),
    data.getFloat16(offset + 20, .little),
    data.getFloat16(offset + 24, .little),
    data.getFloat16(offset + 28, .little),
    data.getFloat16(offset + 32, .little),
    data.getFloat16(offset + 36, .little),
    data.getFloat16(offset + 40, .little),
    data.getFloat16(offset + 44, .little),
    data.getFloat16(offset + 48, .little),
    data.getFloat16(offset + 52, .little),
    data.getFloat16(offset + 56, .little),
    data.getFloat16(offset + 60, .little),
  ));

  @pragma('vm:prefer-inline')
  void write(ByteData data, int offset) {
    data.setFloat16(offset + 0, _.$1, .little);
    data.setFloat16(offset + 4, _.$2, .little);
    data.setFloat16(offset + 8, _.$3, .little);
    data.setFloat16(offset + 12, _.$4, .little);
    data.setFloat16(offset + 16, _.$5, .little);
    data.setFloat16(offset + 20, _.$6, .little);
    data.setFloat16(offset + 24, _.$7, .little);
    data.setFloat16(offset + 28, _.$8, .little);
    data.setFloat16(offset + 32, _.$9, .little);
    data.setFloat16(offset + 36, _.$10, .little);
    data.setFloat16(offset + 40, _.$11, .little);
    data.setFloat16(offset + 44, _.$12, .little);
    data.setFloat16(offset + 48, _.$13, .little);
    data.setFloat16(offset + 52, _.$14, .little);
    data.setFloat16(offset + 56, _.$15, .little);
    data.setFloat16(offset + 60, _.$16, .little);
  }
}
