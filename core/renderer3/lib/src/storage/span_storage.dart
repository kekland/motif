part of 'storage.dart';

extension type DataSpan._(wgsl.Vec2u span) implements wgsl.Vec2u {
  new(int offset, int count) : this._(.new(offset, count));

  static DataSpan from(wgsl.Vec2u span) => ._(span);
  static DataSpan? maybeFrom(wgsl.Vec2u? span) => span != null ? ._(span) : null;

  int get offset => x;
  int get count => y;

  int get start => offset;
  int get end => offset + count;

  bool get isEmpty => offset == 0 && count == 0;
  bool get isNotEmpty => !isEmpty;
}

mixin SpanStorage<T> on UnitStorage<T> {
  final _free = <int, List<int>>{};
  var _top = 0;

  DataSpan put(List<T> items, {DataSpan? span}) {
    final (resultSpan, writeOffset) = _put(items.length, span: span);
    if (writeOffset != null) _write(items, writeOffset);
    return resultSpan;
  }

  (DataSpan, int?) _put(int count, {DataSpan? span}) {
    if (span != null && span.isNotEmpty) {
      if (_capacityFor(count) == _capacityFor(span.count)) {
        return (.new(span.offset, count), span.offset);
      } else {
        release(span);
      }
    }

    if (count == 0) return (.new(0, 0), null);
    final capacity = _capacityFor(count);
    final offset = _allocate(capacity);
    return (.new(offset, count), offset);
  }

  DataSpan putRaw(TypedData storage, {DataSpan? span}) {
    assert(storage.lengthInBytes % elementSizeInBytes == 0);
    final count = storage.lengthInBytes ~/ elementSizeInBytes;
    final (resultSpan, writeOffset) = _put(count, span: span);

    if (writeOffset != null) {
      data.buffer.asUint8List().setRange(
        writeOffset * elementSizeInBytes,
        writeOffset * elementSizeInBytes + storage.lengthInBytes,
        storage.buffer.asUint8List(storage.offsetInBytes, storage.lengthInBytes),
      );

      markRangeDirty(writeOffset, writeOffset + count);
    }

    return resultSpan;
  }

  void release(DataSpan span) {
    if (span.isEmpty) return;
    final capacity = _capacityFor(span.count);
    _free[capacity] ??= [];
    _free[capacity]!.add(span.offset);
  }

  void _write(List<T> items, int offset) {
    for (var i = 0; i < items.length; i++) this[offset + i] = items[i];
  }

  int _capacityFor(int n) => n <= 1 ? 1 : 1 << (n - 1).bitLength;
  int _allocate(int capacity) {
    final freeList = _free[capacity];
    if (freeList != null && freeList.isNotEmpty) return freeList.removeLast();

    final offset = _top;
    _top += capacity;
    grow(_top);
    return offset;
  }
}

extension Vec2ListSpanStorage on SpanStorage<Vec2> {
  DataSpan putFloat32List(Float32List items, {DataSpan? span}) {
    assert(items.length % 2 == 0);
    final (resultSpan, writeOffset) = _put(items.length ~/ 2, span: span);

    if (writeOffset != null) {
      data.buffer.asFloat32List().setRange(writeOffset * 2, writeOffset * 2 + items.length, items);
      markRangeDirty(writeOffset, writeOffset + items.length ~/ 2);
    }

    return resultSpan;
  }
}

extension Quadratic2ListSpanStorage on SpanStorage<Quadratic2> {
  DataSpan putFloat32List(Float32List items, {DataSpan? span}) {
    assert(items.length % 6 == 0);
    final (resultSpan, writeOffset) = _put(items.length ~/ 6, span: span);

    if (writeOffset != null) {
      data.buffer.asFloat32List().setRange(writeOffset * 6, writeOffset * 6 + items.length, items);
      markRangeDirty(writeOffset, writeOffset + items.length ~/ 6);
    }

    return resultSpan;
  }
}
