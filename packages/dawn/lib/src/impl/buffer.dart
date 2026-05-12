part of '../src.dart';
// ignore_for_file: unused_element

class Buffer extends _Buffer {
  Buffer._(super.ptr) : super._();
  Buffer._borrowed(super.ptr) : super._borrowed();

  TexelBufferView createTexelView(TexelBufferViewDescriptor descriptor) => _bufferCreateTexelView(this, descriptor);

  BufferMapState get mapState => _bufferGetMapState(this);
  int get size => _bufferGetSize(this);
  BufferUsage get usage => _bufferGetUsage(this);

  void setLabel(String label) => _bufferSetLabel(this, label);
  void destroy() => _bufferDestroy(this);

  // ----
  // Mapping
  // ----

  ({int offset, int size})? _mappedRange;
  var _mapPending = false;

  Future<void> mapAsync(MapMode mode, int offset, int size) {
    assert(!_mapPending, 'Buffer is already pending mapping.');
    assert(
      _mappedRange == null,
      'Buffer is already mapped at (${_mappedRange!.offset}, ${_mappedRange!.size}). unmap() first',
    );

    final completer = Completer<void>();
    _mapPending = true;

    ffi.using((allocator) {
      final callbackInfo = BufferMapCallbackInfo(
        mode: .allowSpontaneous,
        callback: (status, message) {
          _mapPending = false;
          if (status == .success) {
            _mappedRange = (offset: offset, size: size);
            completer.complete();
          } else {
            completer.completeError(StateError('wgpuBufferMapAsync failed ($status): $message'));
          }
        },
      );

      bindings.wgpuBufferMapAsync(_ptr, mode.value, offset, size, callbackInfo.toNative(allocator).ref);
    });

    return completer.future;
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

    if (ptr == nullptr) {
      throw StateError('wgpuBufferGetMappedRange validation failed for range ($offset, ${offset + size}).');
    }

    final view = ptr.cast<Uint8>().asTypedList(size);
    return view;
  }

  Uint8List readMappedRange(int offset, int size) {
    _ensureRangeMapped(offset, size);

    return ffi.using((allocator) {
      final tmp = allocator<Uint8>(size);
      final status = bindings.wgpuBufferReadMappedRange(_ptr, offset, tmp.cast(), size);
      if (status != .WGPUStatus_Success) throw StateError('wgpuBufferReadMappedRange failed: $status');
      return Uint8List.fromList(tmp.asTypedList(size));
    });
  }

  void writeMappedRange(int offset, Uint8List data) {
    _ensureRangeMapped(offset, data.length);
    ffi.using((allocator) {
      final tmp = allocator<Uint8>(data.length);
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
