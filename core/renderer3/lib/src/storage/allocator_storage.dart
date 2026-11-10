part of 'storage.dart';

mixin AllocatorStorage<T> on UnitStorage<T> {
  final _free = <int>[];
  var _top = 0;

  int _allocate() {
    if (_free.isNotEmpty) return _free.removeLast();
    return _top++;
  }

  void _release(int offset) => _free.add(offset);

  int put(T value, {int? index}) {
    final _index = index ?? _allocate();
    this[_index] = value;
    return _index;
  }

  void release(int index) {
    _release(index);
  }
}
