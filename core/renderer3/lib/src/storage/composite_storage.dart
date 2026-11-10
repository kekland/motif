part of 'storage.dart';

class CompositeStorage implements Storage {
  CompositeStorage(this.storages) {
    _recompute();
    for (final s in storages) s.onReallocate = _onReallocate;
  }

  final List<UnitStorage> storages;

  @override
  void Function()? onReallocate;

  @override
  int get lengthInBytes => _lengthInBytes;
  int get length => _length;

  late int _lengthInBytes;
  late int _length;

  int offsetFor(int storageIndex) => _offsets[storageIndex];
  late List<int> _offsets;

  void _recompute() {
    _lengthInBytes = 0;
    _length = 0;
    _buffers = [];
    _offsets = [];

    for (var i = 0; i < storages.length; i++) {
      final storage = storages[i];
      _offsets.add(_lengthInBytes);
      _buffers.add((_lengthInBytes, storage.data));
      _lengthInBytes += storage.lengthInBytes;
      _length += storage.length;
    }
  }

  void _onReallocate() {
    _recompute();
    onReallocate?.call();
  }

  @override
  Iterable<OffsetData> get buffers => _buffers;
  late List<OffsetData> _buffers;

  @override
  Iterable<OffsetData> computeDirtyData() {
    final dirtyData = <OffsetData>[];
    for (var i = 0; i < storages.length; i++) {
      final storage = storages[i];
      final offset = _offsets[i];
      dirtyData.addAll(storage.computeDirtyData(offset: offset));
    }
    return dirtyData;
  }

  @override
  void clearDirtyData() {
    for (final s in storages) s.clearDirtyData();
  }
}
