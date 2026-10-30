part of 'storage.dart';

typedef DataSpan = ({int offset, int count});
const _emptySpan = (offset: 0, count: 0);

abstract class SpanStorage<T> extends UnitStorage<T> {
  final _free = <int, List<int>>{};
  var _top = 0;

  DataSpan put(List<T> items, {DataSpan? span}) {
    if (span != null && span != _emptySpan) {
      if (_capacityFor(items.length) == _capacityFor(span.count)) {
        _write(items, span.offset);
        return (offset: span.offset, count: items.length);
      } else {
        release(span);
      }
    }

    if (items.isEmpty) return _emptySpan;
    final capacity = _capacityFor(items.length);
    final offset = _allocate(capacity);
    _write(items, offset);
    return (offset: offset, count: items.length);
  }

  void release(DataSpan span) {
    final capacity = _capacityFor(span.count);
    _free[capacity] ??= [];
    _free[capacity]!.add(span.offset);
  }

  void _write(List<T> items, int offset) {
    for (var i = 0; i < items.length; i++) this[offset + i] = items[i];
  }

  int _capacityFor(int n) => n <= 1 ? 1 : (1 << (n - 1)).bitLength;
  int _allocate(int capacity) {
    final freeList = _free[capacity];
    if (freeList != null && freeList.isNotEmpty) return freeList.removeLast();

    final offset = _top;
    _top += capacity;
    grow(_top);
    return offset;
  }
}
