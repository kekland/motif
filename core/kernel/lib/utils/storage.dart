part of '../kernel.dart';

const _arenaListBaseSize = 8;

extension F64ListExt on Float64List {
  Float64List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Float64List(n)..setAll(0, this);
  }
}

extension Vec2ListExt on Vec2List {
  Vec2List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Vec2List(n)..setAll(0, this);
  }
}

extension F64x2ListExt on Float64x2List {
  Float64x2List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Float64x2List(n)..setAll(0, this);
  }
}

extension Mat4ListExt on Mat4List {
  Mat4List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Mat4List(n)..setAll(0, this);
  }
}

extension I32ListExt on Int32List {
  Int32List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Int32List(n)..setAll(0, this);
  }
}

extension U32ListExt on Uint32List {
  Uint32List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Uint32List(n)..setAll(0, this);
  }
}

extension U64ListExt on Uint64List {
  Uint64List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Uint64List(n)..setAll(0, this);
  }
}

extension U8ListExt on Uint8List {
  Uint8List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Uint8List(n)..setAll(0, this);
  }
}

extension type const Vec2Storage<I extends ElementIndex>._(Vec2List storage) {
  Vec2Storage() : this._(.new(_baseSize));
  Vec2Storage.copyFrom(Vec2Storage other) : this._(.fromList(other.storage));

  Vec2 operator [](I index) => storage[index.i];
  void operator []=(I index, Vec2 value) => storage[index.i] = value;

  int get length => storage.length;
  Vec2Storage<I> grow(int atLeast) => ._(storage.grow(atLeast));
}

extension type const Mat4Storage<I extends ElementIndex>._(Mat4List storage) {
  Mat4Storage() : this._(.new(_baseSize));
  Mat4Storage.copyFrom(Mat4Storage other) : this._(.fromList(other.storage));

  Mat4 operator [](I index) => storage[index.i];
  void operator []=(I index, Mat4 value) => storage[index.i] = value;

  int get length => storage.length;
  Mat4Storage<I> grow(int atLeast) => ._(storage.grow(atLeast));
}

extension type const CellIndexStorage<I extends ElementIndex>._(Int32List storage) {
  CellIndexStorage() : this._(Int32List(_baseSize));
  CellIndexStorage.copyFrom(CellIndexStorage other) : this._(.fromList(other.storage));

  CellIndex operator [](I index) => ._(storage[index.i]);
  void operator []=(I index, CellIndex value) => storage[index.i] = value._v;

  int get length => storage.length;
  CellIndexStorage<I> grow(int atLeast) => ._(storage.grow(atLeast));
}

extension type const FrameIndexStorage<I extends ElementIndex>._(Int32List storage) {
  FrameIndexStorage() : this._(Int32List(_baseSize));
  FrameIndexStorage.copyFrom(FrameIndexStorage other) : this._(.fromList(other.storage));

  FrameIndex operator [](I index) => .new(storage[index.i]);
  void operator []=(I index, FrameIndex value) => storage[index.i] = value.i;

  int get length => storage.length;
  FrameIndexStorage<I> grow(int atLeast) => ._(storage.grow(atLeast));
}

extension type const VertexIndexStorage<I extends ElementIndex>._(Int32List storage) {
  VertexIndexStorage() : this._(Int32List(_baseSize));
  VertexIndexStorage.copyFrom(VertexIndexStorage other) : this._(.fromList(other.storage));

  VertexIndex operator [](I index) => .new(storage[index.i]);
  void operator []=(I index, VertexIndex value) => storage[index.i] = value.i;

  int get length => storage.length;
  VertexIndexStorage<I> grow(int atLeast) => ._(storage.grow(atLeast));
}

extension type const CovertexIndexStorage<I extends ElementIndex>._(Int32List storage) {
  CovertexIndexStorage() : this._(Int32List(_baseSize));
  CovertexIndexStorage.copyFrom(CovertexIndexStorage other) : this._(.fromList(other.storage));

  CovertexIndex operator [](I index) => .new(storage[index.i]);
  void operator []=(I index, CovertexIndex value) => storage[index.i] = value.i;

  int get length => storage.length;
  CovertexIndexStorage<I> grow(int atLeast) => ._(storage.grow(atLeast));
}

extension type const EdgeIndexStorage<I extends ElementIndex>._(Int32List storage) {
  EdgeIndexStorage() : this._(Int32List(_baseSize));
  EdgeIndexStorage.copyFrom(EdgeIndexStorage other) : this._(.fromList(other.storage));

  EdgeIndex operator [](I index) => .new(storage[index.i]);
  void operator []=(I index, EdgeIndex value) => storage[index.i] = value.i;

  int get length => storage.length;
  EdgeIndexStorage<I> grow(int atLeast) => ._(storage.grow(atLeast));
}

extension type const CoedgeIndexStorage<I extends ElementIndex>._(Int32List storage) {
  CoedgeIndexStorage() : this._(Int32List(_baseSize));
  CoedgeIndexStorage.copyFrom(CoedgeIndexStorage other) : this._(.fromList(other.storage));

  CoedgeIndex operator [](I index) => .new(storage[index.i]);
  void operator []=(I index, CoedgeIndex value) => storage[index.i] = value.i;

  int get length => storage.length;
  CoedgeIndexStorage<I> grow(int atLeast) => ._(storage.grow(atLeast));
}

extension type const FaceIndexStorage<I extends ElementIndex>._(Int32List storage) {
  FaceIndexStorage() : this._(Int32List(_baseSize));
  FaceIndexStorage.copyFrom(FaceIndexStorage other) : this._(.fromList(other.storage));

  FaceIndex operator [](I index) => .new(storage[index.i]);
  void operator []=(I index, FaceIndex value) => storage[index.i] = value.i;

  int get length => storage.length;
  FaceIndexStorage<I> grow(int atLeast) => ._(storage.grow(atLeast));
}

extension type const BoolStorage<I extends ElementIndex>._(Uint8List storage) {
  BoolStorage() : this._(Uint8List(_baseSize));
  BoolStorage.copyFrom(BoolStorage other) : this._(.fromList(other.storage));

  bool operator [](I index) => storage[index.i] != 0;
  void operator []=(I index, bool value) => storage[index.i] = value ? 1 : 0;

  int get length => storage.length;
  BoolStorage<I> grow(int atLeast) => ._(storage.grow(atLeast));
}

extension type const BoundaryStorage._(List<CoedgeIndex> storage) implements Iterable<CoedgeIndex> {
  BoundaryStorage.empty() : this._([]);
  BoundaryStorage.copyFrom(BoundaryStorage other) : this._(.of(other.storage));

  CoedgeIndex operator [](int index) => storage[index];
  void operator []=(int index, CoedgeIndex value) => storage[index] = value;

  void add(CoedgeIndex value) => storage.add(value);
  void remove(CoedgeIndex value) => storage.remove(value);
}

extension type const BoundaryListStorage<I extends ElementIndex>._(List<BoundaryStorage?> storage) {
  BoundaryListStorage() : this._([]);

  BoundaryStorage operator [](I index) => storage[index.i]!;
  void operator []=(I index, BoundaryStorage? value) => storage[index.i] = value;

  void copyFrom(BoundaryListStorage<I> other) {
    storage.clear();
    for (final heads in other.storage) {
      storage.add(heads != null ? .copyFrom(heads) : null);
    }
  }

  void grow(int atLeast) {
    while (storage.length < atLeast) storage.add(null);
  }
}

extension type const Int32Storage<I extends ElementIndex>._(Int32List storage) {
  Int32Storage() : this._(Int32List(_baseSize));
  Int32Storage.copyFrom(Int32Storage other) : this._(.fromList(other.storage));

  int operator [](I index) => storage[index.i];
  void operator []=(I index, int value) => storage[index.i] = value;

  int get length => storage.length;
  Int32Storage<I> grow(int atLeast) => ._(storage.grow(atLeast));
}

extension type const Size2Storage<I extends ElementIndex>._(Vec2List storage) {
  Size2Storage() : this._(.new(_baseSize));
  Size2Storage.copyFrom(Size2Storage other) : this._(.fromList(other.storage));

  Size2 operator [](I index) => .from(storage[index.i]);
  void operator []=(I index, Size2 value) => storage[index.i] = value.vec;

  int get length => storage.length;
  Size2Storage<I> grow(int atLeast) => ._(storage.grow(atLeast));
}

extension type const Cubic2Storage<I extends ElementIndex>._(Vec2List storage) {
  Cubic2Storage() : this._(.new(_baseSize * 4));
  Cubic2Storage.copyFrom(Cubic2Storage other) : this._(.fromList(other.storage));

  Cubic2 operator [](I index) {
    return .view(.sublistView(storage, index.i * 4, index.i * 4 + 4));
  }

  void operator []=(I index, Cubic2 value) {
    storage.setRange(index.i * 4, index.i * 4 + 4, value.storage);
  }

  int get length => storage.length ~/ 4;
  Cubic2Storage<I> grow(int atLeast) => ._(storage.grow(atLeast * 4));
}

extension type const ObjectStorage<I extends ElementIndex, T extends Object>._(List<T?> storage) {
  ObjectStorage() : this._(List.filled(_baseSize, null));
  ObjectStorage.copyFrom(ObjectStorage<I, T> other) : this._(List.of(other.storage, growable: false));

  T? operator [](I index) => storage[index.i];
  void operator []=(I index, T? value) => storage[index.i] = value;

  int get length => storage.length;
  ObjectStorage<I, T> grow(int atLeast) {
    if (storage.length >= atLeast) return this;
    return ._(List.filled(math.max(atLeast, storage.length * 2), null)..setRange(0, storage.length, storage));
  }
}
