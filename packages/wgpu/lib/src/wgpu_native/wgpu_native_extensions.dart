part of './wgpu_native.g.dart';

class WGPUNative {
  static set logLevel(LogLevel level) => _setLogLevel(level);

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
    Instance.asyncCallbackDriverOverride = _asyncCallbackDriver;
    Instance.syncCallbackDriverOverride = _syncCallbackDriver;
  }
}

extension InstanceNativeExtension on Instance {
  GlobalReport generateReport() => _generateReport(this);
  List<Adapter> enumerateAdapters([InstanceEnumerateAdapterOptions? options]) =>
      _instanceEnumerateAdapters(this, options);
}

extension QueueNativeExtension on Queue {
  int submitForIndex(List<CommandBuffer> commands) => _queueSubmitForIndex(this, commands);
  double get timestampPeriod => _queueGetTimestampPeriod(this);

  ffi.Pointer<ffi.Void> get nativeMetalCommandQueue => _queueGetNativeMetalCommandQueue(this);
}

extension DeviceNativeExtension on Device {
  ffi.Pointer<ffi.Void> get nativeMetalDevice => _deviceGetNativeMetalDevice(this);

  bool startGraphicsDebuggerCapture() => _deviceStartGraphicsDebuggerCapture(this);
  void stopGraphicsDebuggerCapture() => _deviceStopGraphicsDebuggerCapture(this);

  void poll({bool wait = false}) => _devicePoll(this, wait, null);
}

extension TextureNativeExtension on Texture {
  ffi.Pointer<ffi.Void> get nativeMetalTexture => _textureGetNativeMetalTexture(this);
}

extension RenderPassEncoderNativeExtension on RenderPassEncoder {
  void setImmediates(int offset, int sizeBytes, ffi.Pointer<ffi.Void> data) =>
      _renderPassEncoderSetImmediates(this, offset, sizeBytes, data);

  void multiDrawIndirect(Buffer buffer, int offset, int count) =>
      _renderPassEncoderMultiDrawIndirect(this, buffer, offset, count);
  void multiDrawIndexedIndirect(Buffer buffer, int offset, int count) =>
      _renderPassEncoderMultiDrawIndexedIndirect(this, buffer, offset, count);
  void multiDrawIndirectCount(Buffer buffer, int offset, Buffer countBuffer, int countBufferOffset, int maxCount) =>
      _renderPassEncoderMultiDrawIndirectCount(this, buffer, offset, countBuffer, countBufferOffset, maxCount);
  void multiDrawIndexedIndirectCount(
    Buffer buffer,
    int offset,
    Buffer countBuffer,
    int countBufferOffset,
    int maxCount,
  ) => _renderPassEncoderMultiDrawIndexedIndirectCount(this, buffer, offset, countBuffer, countBufferOffset, maxCount);

  void beginPipelineStatisticsQuery(QuerySet querySet, int queryIndex) =>
      _renderPassEncoderBeginPipelineStatisticsQuery(this, querySet, queryIndex);
  void endPipelineStatisticsQuery() => _renderPassEncoderEndPipelineStatisticsQuery(this);
  void writeTimestamp(QuerySet querySet, int queryIndex) =>
      _renderPassEncoderWriteTimestamp(this, querySet, queryIndex);
}

extension ComputePassEncoderNativeExtension on ComputePassEncoder {
  void setImmediates(int offset, int sizeBytes, ffi.Pointer<ffi.Void> data) =>
      _computePassEncoderSetImmediates(this, offset, sizeBytes, data);

  void beginPipelineStatisticsQuery(QuerySet querySet, int queryIndex) =>
      _computePassEncoderBeginPipelineStatisticsQuery(this, querySet, queryIndex);
  void endPipelineStatisticsQuery() => _computePassEncoderEndPipelineStatisticsQuery(this);
  void writeTimestamp(QuerySet querySet, int queryIndex) =>
      _computePassEncoderWriteTimestamp(this, querySet, queryIndex);
}

extension RenderBundleEncoderNativeExtension on RenderBundleEncoder {
  void setImmediates(int offset, int sizeBytes, ffi.Pointer<ffi.Void> data) =>
      _renderBundleEncoderSetImmediates(this, offset, sizeBytes, data);
}
