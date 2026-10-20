import 'dart:ffi' as ffi;

import 'driver.dart';
import 'wgpu.g.dart';
import 'wgpu_native.g.dart';
import 'wgpu_native_bindings.g.dart' as bindings;

class WGPUNative {
  static set logLevel(LogLevel level) => setLogLevel(level);

  static LogListener? _listener;
  static void setLogCallback(LogCallback? callback) {
    if (callback == null) {
      _listener?.cancel();
      bindings.wgpuSetLogCallback(ffi.nullptr, ffi.nullptr);
    } else {
      _listener?.cancel();
      final listener = LogListener(callback);
      bindings.wgpuSetLogCallback(listener.nativeFunction, listener.userdata);
      _listener = listener;
    }
  }

  static void _asyncCallbackDriver(
    List<WeakReference<Instance>> instances,
    List<WeakReference<Adapter>> adapters,
    List<WeakReference<Device>> devices,
  ) {
    for (final ref in instances) ref.target?.processEvents();
    for (final device in devices) device.target?.poll(wait: false);
  }

  static void _syncCallbackDriver(
    List<WeakReference<Instance>> instances,
    List<WeakReference<Adapter>> adapters,
    List<WeakReference<Device>> devices,
  ) {
    for (final ref in instances) ref.target?.processEvents();
    for (final device in devices) device.target?.poll(wait: true);
  }

  static void init() {
    asyncCallbackDriverOverride = _asyncCallbackDriver;
    syncCallbackDriverOverride = _syncCallbackDriver;
  }
}

extension TextureNativeExtension on Texture {
  ffi.Pointer<ffi.Void> get nativeMetalTexture => textureGetNativeMetalTexture(this);
}

extension InstanceNativeExtension on Instance {
  GlobalReport generateReport() {
    return generateReport();
  }

  List<Adapter> enumerateAdapters([InstanceEnumerateAdapterOptions? options]) {
    return instanceEnumerateAdapters(this, options);
  }
}

extension QueueNativeExtension on Queue {
  int submitForIndex(List<CommandBuffer> commands) {
    return queueSubmitForIndex(this, commands);
  }

  double get timestampPeriod {
    return queueGetTimestampPeriod(this);
  }

  ffi.Pointer<ffi.Void> get nativeMetalCommandQueue {
    return queueGetNativeMetalCommandQueue(this);
  }
}

extension DeviceNativeExtension on Device {
  ffi.Pointer<ffi.Void> get nativeMetalDevice {
    return deviceGetNativeMetalDevice(this);
  }

  bool startGraphicsDebuggerCapture() {
    return deviceStartGraphicsDebuggerCapture(this);
  }

  void stopGraphicsDebuggerCapture() {
    return deviceStopGraphicsDebuggerCapture(this);
  }

  void poll({bool wait = false}) {
    return devicePoll(this, wait, null);
  }
}

extension RenderPassEncoderNativeExtension on RenderPassEncoder {
  void multiDrawIndirect(Buffer buffer, int offset, int count) {
    renderPassEncoderMultiDrawIndirect(this, buffer, offset, count);
  }

  void multiDrawIndexedIndirect(Buffer buffer, int offset, int count) {
    renderPassEncoderMultiDrawIndexedIndirect(this, buffer, offset, count);
  }

  void multiDrawIndirectCount(Buffer buffer, int offset, Buffer countBuffer, int countBufferOffset, int maxCount) {
    renderPassEncoderMultiDrawIndirectCount(this, buffer, offset, countBuffer, countBufferOffset, maxCount);
  }

  void multiDrawIndexedIndirectCount(
    Buffer buffer,
    int offset,
    Buffer countBuffer,
    int countBufferOffset,
    int maxCount,
  ) {
    renderPassEncoderMultiDrawIndexedIndirectCount(this, buffer, offset, countBuffer, countBufferOffset, maxCount);
  }

  void beginPipelineStatisticsQuery(QuerySet querySet, int queryIndex) {
    renderPassEncoderBeginPipelineStatisticsQuery(this, querySet, queryIndex);
  }

  void endPipelineStatisticsQuery() {
    renderPassEncoderEndPipelineStatisticsQuery(this);
  }

  void writeTimestamp(QuerySet querySet, int queryIndex) {
    renderPassEncoderWriteTimestamp(this, querySet, queryIndex);
  }
}

extension ComputePassEncoderNativeExtension on ComputePassEncoder {
  void beginPipelineStatisticsQuery(QuerySet querySet, int queryIndex) {
    computePassEncoderBeginPipelineStatisticsQuery(this, querySet, queryIndex);
  }

  void endPipelineStatisticsQuery() {
    computePassEncoderEndPipelineStatisticsQuery(this);
  }

  void writeTimestamp(QuerySet querySet, int queryIndex) {
    computePassEncoderWriteTimestamp(this, querySet, queryIndex);
  }
}
