part of '../webgpu.g.dart';
// ignore_for_file: unused_element, unused_local_variable, prefer_function_declarations_over_variables

mixin _BufferImpl on _BufferBase {
  BufferMapState get mapState => _getMapStateImpl();
  int get size => _getSizeImpl();
  BufferUsage get usage => _getUsageImpl();

  set label(String label) => _setLabelImpl(label);
  void destroy() => _destroyImpl();

  // ----
  // Mapping
  // ----

  ({int offset, int size})? _mappedRange;
  var _mapPending = false;

  Future<void> mapAsync(MapMode mode, int offset, int size) async {
    assert(!_mapPending, 'Buffer is already pending mapping.');
    assert(
      _mappedRange == null,
      'Buffer is already mapped at (${_mappedRange!.offset}, ${_mappedRange!.size}). unmap() first',
    );

    try {
      await _mapAsyncImpl(mode, offset, size);
      _mappedRange = (offset: offset, size: size);
    } catch (e) {
      rethrow;
    } finally {
      _mapPending = false;
    }
  }

  void mapSync(MapMode mode, int offset, int size) {
    assert(!_mapPending, 'Buffer is already pending mapping.');
    assert(
      _mappedRange == null,
      'Buffer is already mapped at (${_mappedRange!.offset}, ${_mappedRange!.size}). unmap() first',
    );

    try {
      _mapSyncImpl(mode, offset, size);
      _mappedRange = (offset: offset, size: size);
    } catch (e) {
      rethrow;
    } finally {
      _mapPending = false;
    }
  }

  bool _ensureRangeMapped(int offset, int size) {
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

  Uint8List getMappedRange(int offset, int size, {bool readOnly = false}) {
    _ensureRangeMapped(offset, size);
    final ptr = readOnly
        ? bindings.wgpuBufferGetConstMappedRange(_ptr, offset, size)
        : bindings.wgpuBufferGetMappedRange(_ptr, offset, size);

    if (ptr == ffi.nullptr) {
      throw StateError('wgpuBufferGetMappedRange validation failed for range ($offset, ${offset + size}).');
    }

    final view = ptr.cast<ffi.Uint8>().asTypedList(size);
    return view;
  }

  // Uint8List readMappedRange(int offset, int size) {
  //   _ensureRangeMapped(offset, size);

  //   return using((allocator) {
  //     final tmp = allocator<ffi.Uint8>(size);
  //     final status = bindings.wgpuBufferReadMappedRange(_ptr, offset, tmp.cast(), size);
  //     if (status != .WGPUStatus_Success) throw StateError('wgpuBufferReadMappedRange failed: $status');
  //     return Uint8List.fromList(tmp.asTypedList(size));
  //   });
  // }

  void writeMappedRange(int offset, Uint8List data) {
    _ensureRangeMapped(offset, data.length);
    using((allocator) {
      final tmp = allocator<ffi.Uint8>(data.length);
      tmp.asTypedList(data.length).setAll(0, data);

      final status = bindings.wgpuBufferWriteMappedRange(_ptr, offset, tmp.cast(), data.length);
      if (status != .WGPUStatus_Success) throw StateError('wgpuBufferWriteMappedRange failed: $status');
    });
  }

  void unmap() {
    assert(_mappedRange != null, 'Buffer is not mapped.');
    _mappedRange = null;
    bindings.wgpuBufferUnmap(_ptr);
  }
}
