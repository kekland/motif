import 'package:webgpu/webgpu.dart' as webgpu;

import 'storage.dart';

final class GpuStorageBuffer<T extends Storage> {
  GpuStorageBuffer(this.device, this.storage, {this.label}) {
    storage.onReallocate = _onReallocate;
    _allocate();
  }

  final webgpu.Device device;
  final T storage;
  final String? label;
  late webgpu.Buffer buffer;
  late webgpu.BufferView bufferView;

  var _shouldReallocate = false;
  void _onReallocate() => _shouldReallocate = true;

  void _allocate() {
    buffer = device.createBuffer(
      .new(
        label: label ?? 'gpu-storage',
        size: storage.lengthInBytes,
        usage: .of([.storage, .copyDst]),
      ),
    );

    bufferView = .new(buffer);
  }

  bool upload(webgpu.Queue queue) {
    if (_shouldReallocate) {
      buffer.destroy();
      buffer.dispose();
      _allocate();

      for (final (offset, data) in storage.buffers) {
        queue.writeBuffer(buffer, offset, data);
      }

      _shouldReallocate = false;
      storage.clearDirtyData();
      return true;
    }

    for (final (offset, data) in storage.computeDirtyData()) {
      queue.writeBuffer(buffer, offset, data);
    }

    return false;
  }

  void destroy() {
    buffer.destroy();
  }
}
