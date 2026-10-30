part of 'storage.dart';

abstract class UnitStorage<T> implements Storage {
  new() {
    data = GpuByteData(_defaultLength * elementSizeInBytes);
  }

  late GpuByteData data;
  final _dirty = SplayTreeSet<int>();

  @override
  void Function()? onReallocate;

  @override
  int get lengthInBytes => data.lengthInBytes;

  int get elementSizeInBytes;
  int get length => lengthInBytes ~/ elementSizeInBytes;

  Uint8List _sublistView(int start, int end) => .sublistView(
    data,
    start * elementSizeInBytes,
    end * elementSizeInBytes,
  );

  T? operator [](int index) {
    if (index >= length) return null;
    return get(index * elementSizeInBytes);
  }

  void operator []=(int index, T value) {
    grow(index + 1);
    set(index * elementSizeInBytes, value);
    _dirty.add(index);
  }

  @pragma('vm:prefer-inline')
  void set(int offset, T value);

  @pragma('vm:prefer-inline')
  T get(int offset) => throw UnimplementedError();

  void grow(int atLeast) {
    if (atLeast > length) {
      final newLength = max(atLeast, length * 2);
      final newData = GpuByteData(newLength * elementSizeInBytes);
      newData.buffer.asUint8List().setRange(0, data.lengthInBytes, data.buffer.asUint8List());
      data = newData;
      onReallocate?.call();
    }
  }

  @override
  Iterable<OffsetData> get buffers => [(0, data)];

  @override
  Iterable<OffsetData> computeDirtyData({int offset = 0}) {
    if (_dirty.isEmpty) return const .empty();
    final ranges = <OffsetData>[];

    var start = _dirty.first;
    var end = start;
    for (var index in _dirty.skip(1)) {
      if (index == end + 1) {
        end = index;
      } else {
        ranges.add((start * elementSizeInBytes + offset, _sublistView(start, end + 1)));
        start = index;
        end = index;
      }
    }

    ranges.add((start * elementSizeInBytes + offset, _sublistView(start, end + 1)));
    _dirty.clear();
    return ranges;
  }

  @override
  void clearDirtyData() {
    _dirty.clear();
  }
}
