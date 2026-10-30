import 'package:webgpu/webgpu.dart' as webgpu;

import 'storage.dart';

final class GpuStorage<T extends Storage> {
  GpuStorage(this.device, this.storage, {this.label}) {
    storage.onReallocate = _onReallocate;
    _allocate();
  }

  final webgpu.Device device;
  final T storage;
  final String? label;
  late webgpu.Buffer buffer;

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

// flutter: % offset: 0, data: (0, 0, 128, 63, 0, 0, 0, 0, 0, 0)
// flutter: % offset: 1024, data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
// flutter: % offset: 1152, data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
// flutter: % offset: 1408, data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
// flutter: % offset: 0, data: (7, 0, 0, 0, 1, 0, 0, 0, 2, 0)
// flutter: % offset: 128, data: (0, 0, 0, 0, 1, 0, 0, 0, 1, 0)
// flutter: % offset: 320, data: (0, 0, 0, 0, 4, 0, 0, 0, 1, 0)
// flutter: % offset: 512, data: (0, 0, 0, 0, 1, 0, 0, 0, 255, 255)
// flutter: % offset: 896, data: (0, 0, 0, 0, 1, 0, 0, 0, 1, 0)
// flutter: % offset: 1024, data: (1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
// flutter: offset: 0, data: (0, 0, 128, 63, 0, 0, 0, 0, 0, 0)
// flutter: offset: 1024, data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
// flutter: offset: 1152, data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
// flutter: offset: 1408, data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
// flutter: offset: 0, data: (7, 0, 0, 0, 1, 0, 0, 0, 2, 0)
// flutter: offset: 128, data: (0, 0, 0, 0, 1, 0, 0, 0, 1, 0)
// flutter: offset: 320, data: (0, 0, 0, 0, 4, 0, 0, 0, 1, 0)
// flutter: offset: 512, data: (0, 0, 0, 0, 1, 0, 0, 0, 255, 255)
// flutter: offset: 896, data: (0, 0, 0, 0, 1, 0, 0, 0, 1, 0)
// flutter: offset: 1024, data: (1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
