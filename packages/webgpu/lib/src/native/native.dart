import 'package:webgpu/native.dart';
import 'package:webgpu/webgpu.dart' as webgpu;

export 'wgpu.g.dart';
export 'wgpu_native.g.dart';
export 'wgpu_native_extensions.dart';

void initializeWebGpu({
  webgpu.LogLevel logLevel = .off,
  webgpu.LogCallback? logCallback,
}) {
  WGPUNative.init();
  WGPUNative.logLevel = switch (logLevel) {
    .off => .off,
    .error => .error,
    .warn => .warn,
    .info => .info,
    .debug => .debug,
    .trace => .trace,
    _ => .off,
  };

  if (logCallback != null) {
    WGPUNative.setLogCallback((level, message) {
      final webgpu.LogLevel _level = switch (level) {
        .off => .off,
        .error => .error,
        .warn => .warn,
        .info => .info,
        .debug => .debug,
        .trace => .trace,
        _ => .off,
      };

      logCallback(_level, message);
    });
  } else {
    WGPUNative.setLogCallback(null);
  }
}

webgpu.Instance createDefaultInstance() => Instance.create();
