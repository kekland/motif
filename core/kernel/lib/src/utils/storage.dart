part of '../kernel.dart';

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
  void operator []=(I index, CellIndex value) => storage[index.i] = value.v;

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
