part of 'types.dart';

abstract class Buffer {
  BufferMapState get mapState;
  int get size;
  BufferUsage get usage;

  set label(String label);

  Future<void> mapAsync({int offset = 0, int? size, MapMode mode = .read});
  TypedData getMappedRange(int offset, int size, {bool readOnly = false});
  void writeMappedRange(TypedData data, {int offset = 0});
  void unmap();

  @protected
  Future<void> internalMapAsync(MapMode mode, int offset, int size);

  @protected
  void internalMapSync(MapMode mode, int offset, int size);

  @protected
  TypedData internalGetMappedRange(int offset, int size, {bool readOnly = false});

  @protected
  void internalWriteMappedRange(TypedData data, {int offset = 0});

  @protected
  void internalUnmap();

  void dispose();
}

@protected
final class BufferImpl {
  BufferImpl(this.buffer);
  final Buffer buffer;

  ({int offset, int size})? _mappedRange;
  var _mapPending = false;

  void internalVerifyMap() {
    assert(!_mapPending, 'Buffer is already pending mapping.');
    assert(
      _mappedRange == null,
      'Buffer is already mapped at (${_mappedRange!.offset}, ${_mappedRange!.size}). unmap() first',
    );
  }

  bool internalEnsureRangeMapped(int offset, int size) {
    final mapped = _mappedRange;
    assert(mapped != null, 'Buffer is not mapped.');

    final reqEnd = offset + size;
    final mapEnd = mapped!.offset + mapped.size;
    assert(
      offset >= mapped.offset && reqEnd <= mapEnd,
      'Requested range ($offset, $reqEnd) is out of mapped range (${mapped.offset}, $mapEnd).',
    );

    return true;
  }

  Future<void> mapAsync({int offset = 0, int? size, MapMode mode = .read}) async {
    internalVerifyMap();

    try {
      final _size = size ?? (buffer.size - offset);
      await buffer.internalMapAsync(mode, offset, _size);
      _mappedRange = (offset: offset, size: _size);
    } catch (e) {
      rethrow;
    } finally {
      _mapPending = false;
    }
  }

  void mapSync({int offset = 0, int? size, MapMode mode = .read}) {
    internalVerifyMap();

    try {
      final _size = size ?? (buffer.size - offset);
      buffer.internalMapSync(mode, offset, _size);
      _mappedRange = (offset: offset, size: _size);
    } catch (e) {
      rethrow;
    } finally {
      _mapPending = false;
    }
  }

  TypedData getMappedRange(int offset, int size, {bool readOnly = false}) {
    internalEnsureRangeMapped(offset, size);
    return buffer.internalGetMappedRange(offset, size, readOnly: readOnly);
  }

  void writeMappedRange(TypedData data, {int offset = 0}) {
    internalEnsureRangeMapped(offset, data.lengthInBytes);
    buffer.internalWriteMappedRange(data, offset: offset);
  }

  void unmap() {
    assert(_mappedRange != null, 'Buffer is not mapped.');
    _mappedRange = null;
    buffer.internalUnmap();
  }
}
