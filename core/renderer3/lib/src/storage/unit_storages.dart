part of 'storage.dart';

class Vec2UnitStorage extends UnitStorage<Vec2> {
  @override
  final int elementSizeInBytes = 2 * 4;

  @override
  Vec2 get(int offset) => .new(
    data.getF32(offset),
    data.getF32(offset + 4),
  );

  @override
  void set(int offset, Vec2 value) {
    data.setF32(offset, value.x);
    data.setF32(offset + 4, value.y);
  }
}

class Mat4UnitStorage extends UnitStorage<Mat4> {
  @override
  final int elementSizeInBytes = 4 * 4 * 4;

  @override
  Mat4 get(int offset) => .from(
    data.getF32(offset),
    data.getF32(offset + 4),
    data.getF32(offset + 8),
    data.getF32(offset + 12),
    data.getF32(offset + 16),
    data.getF32(offset + 20),
    data.getF32(offset + 24),
    data.getF32(offset + 28),
    data.getF32(offset + 32),
    data.getF32(offset + 36),
    data.getF32(offset + 40),
    data.getF32(offset + 44),
    data.getF32(offset + 48),
    data.getF32(offset + 52),
    data.getF32(offset + 56),
    data.getF32(offset + 60),
  );

  @override
  void set(int offset, Mat4 value) {
    data.setF32(offset, value[0]);
    data.setF32(offset + 4, value[1]);
    data.setF32(offset + 8, value[2]);
    data.setF32(offset + 12, value[3]);
    data.setF32(offset + 16, value[4]);
    data.setF32(offset + 20, value[5]);
    data.setF32(offset + 24, value[6]);
    data.setF32(offset + 28, value[7]);
    data.setF32(offset + 32, value[8]);
    data.setF32(offset + 36, value[9]);
    data.setF32(offset + 40, value[10]);
    data.setF32(offset + 44, value[11]);
    data.setF32(offset + 48, value[12]);
    data.setF32(offset + 52, value[13]);
    data.setF32(offset + 56, value[14]);
    data.setF32(offset + 60, value[15]);
  }
}

class Cubic2UnitStorage extends UnitStorage<Cubic2> {
  @override
  final int elementSizeInBytes = 4 * 2 * 4;

  @override
  Cubic2 get(int offset) => .new(
    .new(data.getF32(offset), data.getF32(offset + 4)),
    .new(data.getF32(offset + 24), data.getF32(offset + 28)),
    p1: .new(data.getF32(offset + 8), data.getF32(offset + 12)),
    p2: .new(data.getF32(offset + 16), data.getF32(offset + 20)),
  );

  @override
  void set(int offset, Cubic2 value) {
    data.setF32(offset, value.p0.x);
    data.setF32(offset + 4, value.p0.y);
    data.setF32(offset + 8, value.p1.x);
    data.setF32(offset + 12, value.p1.y);
    data.setF32(offset + 16, value.p2.x);
    data.setF32(offset + 20, value.p2.y);
    data.setF32(offset + 24, value.p3.x);
    data.setF32(offset + 28, value.p3.y);
  }
}

class Quadratic2UnitStorage extends UnitStorage<Quadratic2> {
  @override
  final int elementSizeInBytes = 4 * 2 * 3;

  @override
  Quadratic2 get(int offset) => .new(
    .new(data.getF32(offset), data.getF32(offset + 4)),
    .new(data.getF32(offset + 8), data.getF32(offset + 12)),
    p1: .new(data.getF32(offset + 16), data.getF32(offset + 20)),
  );

  @override
  void set(int offset, Quadratic2 value) {
    data.setF32(offset, value.p0.x);
    data.setF32(offset + 4, value.p0.y);
    data.setF32(offset + 8, value.p1.x);
    data.setF32(offset + 12, value.p1.y);
    data.setF32(offset + 16, value.p2.x);
    data.setF32(offset + 20, value.p2.y);
  }
}

class Float32UnitStorage extends UnitStorage<double> {
  @override
  final int elementSizeInBytes = 4;

  @override
  double get(int offset) => data.getF32(offset);

  @override
  void set(int offset, double value) {
    data.setF32(offset, value);
  }
}

class Int32UnitStorage extends UnitStorage<int> {
  @override
  final int elementSizeInBytes = 4;

  @override
  int get(int offset) => data.getI32(offset);

  @override
  void set(int offset, int value) {
    data.setI32(offset, value);
  }
}

class Uint32UnitStorage extends UnitStorage<int> {
  @override
  final int elementSizeInBytes = 4;

  @override
  int get(int offset) => data.getU32(offset);

  @override
  void set(int offset, int value) {
    data.setU32(offset, value);
  }
}
