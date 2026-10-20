part of 'wgpu.g.dart';

final class Instance extends _InstanceBase implements webgpu.Instance {
  Instance._(super.ptr) : super._() {
    webgpu.Instance.ensureInitialized();
    registerInstance(this);
  }

  Instance._borrowed(super.ptr) : super._borrowed();
  factory Instance.create([InstanceDescriptor? descriptor]) => createInstance(descriptor);

  void processEvents() => _processEvents();

  @override
  Future<webgpu.Adapter> requestAdapter([RequestAdapterOptions? options]) => _requestAdapter(options);

  Surface createSurface(SurfaceDescriptor descriptor) => _createSurface(descriptor);
}

final class Adapter extends _AdapterBase implements webgpu.Adapter {
  Adapter._(super.ptr) : super._() {
    registerAdapter(this);
  }

  Adapter._borrowed(super.ptr) : super._borrowed();

  @override
  Future<webgpu.Device> requestDevice(DeviceDescriptor? descriptor) => _requestDevice(descriptor);
}

final class BindGroupLayout extends _BindGroupLayoutBase implements webgpu.BindGroupLayout {
  BindGroupLayout._(super.ptr) : super._();
  BindGroupLayout._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);
}

final class BindGroup extends _BindGroupBase implements webgpu.BindGroup {
  BindGroup._(super.ptr) : super._();
  BindGroup._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);
}

final class Buffer extends _BufferBase implements webgpu.Buffer {
  Buffer._(super.ptr) : super._();
  Buffer._borrowed(super.ptr) : super._borrowed();

  late final _impl = webgpu.BufferImpl(this);

  @override
  BufferMapState get mapState => _getMapState();

  @override
  int get size => _getSize();

  @override
  BufferUsage get usage => _getUsage();

  @override
  set label(String label) => _setLabel(label);

  // ----
  // Mapping
  // ----

  @override
  Future<void> mapAsync({int offset = 0, int? size, MapMode mode = .read}) {
    return _impl.mapAsync(offset: offset, size: size, mode: mode);
  }

  void mapSync({int offset = 0, int? size, MapMode mode = .read}) {
    return _impl.mapSync(offset: offset, size: size, mode: mode);
  }

  @override
  TypedData getMappedRange(int offset, int size, {bool readOnly = false}) {
    return _impl.getMappedRange(offset, size, readOnly: readOnly);
  }

  @override
  void writeMappedRange(TypedData data, {int offset = 0}) {
    return _impl.writeMappedRange(data, offset: offset);
  }

  @override
  void unmap() {
    return _impl.unmap();
  }

  @override
  Future<void> internalMapAsync(MapMode mode, int offset, int size) {
    return _mapAsync(mode, offset, size);
  }

  @override
  void internalMapSync(MapMode mode, int offset, int size) {
    return _mapSync(mode, offset, size);
  }

  @override
  TypedData internalGetMappedRange(int offset, int size, {bool readOnly = false}) {
    final ptr = readOnly
        ? bindings.wgpuBufferGetConstMappedRange(_ptr, offset, size)
        : bindings.wgpuBufferGetMappedRange(_ptr, offset, size);

    if (ptr == ffi.nullptr) {
      throw StateError('wgpuBufferGetMappedRange validation failed for range ($offset, ${offset + size}).');
    }

    final view = ptr.cast<ffi.Uint8>().asTypedList(size);
    return view;
  }

  @override
  void internalWriteMappedRange(TypedData data, {int offset = 0}) => _withNativeMemory(data, (ptr) {
    final status = bindings.wgpuBufferWriteMappedRange(_ptr, offset, ptr, data.lengthInBytes);
    if (status != .WGPUStatus_Success) throw StateError('wgpuBufferWriteMappedRange failed: $status');
  });

  @override
  void internalUnmap() {
    bindings.wgpuBufferUnmap(_ptr);
  }
}

final class CommandBuffer extends _CommandBufferBase implements webgpu.CommandBuffer {
  CommandBuffer._(super.ptr) : super._();
  CommandBuffer._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);
}

final class CommandEncoder extends _CommandEncoderBase implements webgpu.CommandEncoder {
  CommandEncoder._(super.ptr) : super._();
  CommandEncoder._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);

  @override
  ComputePassEncoder beginComputePass([ComputePassDescriptor? descriptor]) {
    return _beginComputePass(descriptor);
  }

  @override
  RenderPassEncoder beginRenderPass(RenderPassDescriptor descriptor) {
    return _beginRenderPass(descriptor);
  }

  @override
  void copyTextureToBuffer(
    webgpu.TexelCopyTextureInfo source,
    webgpu.TexelCopyBufferInfo destination,
    webgpu.Extent3D copySize,
  ) {
    _copyTextureToBuffer(source, destination, copySize);
  }

  @override
  CommandBuffer finish([CommandBufferDescriptor? descriptor]) {
    return _finish(descriptor);
  }

  @override
  void clearBuffer(Buffer buffer, {int offset = 0, int? size}) {
    _clearBuffer(buffer, offset, size ?? (buffer.size - offset));
  }

  @override
  void copyBufferToBuffer(
    Buffer source,
    Buffer destination, {
    int sourceOffset = 0,
    int destinationOffset = 0,
    required int size,
  }) {
    _copyBufferToBuffer(source, sourceOffset, destination, destinationOffset, size);
  }

  @override
  void copyBufferToTexture(
    webgpu.TexelCopyBufferInfo source,
    webgpu.TexelCopyTextureInfo destination,
    webgpu.Extent3D copySize,
  ) {
    _copyBufferToTexture(source, destination, copySize);
  }

  @override
  void insertDebugMarker(String markerLabel) {
    _insertDebugMarker(markerLabel);
  }

  @override
  void pushDebugGroup(String groupLabel) {
    _pushDebugGroup(groupLabel);
  }

  @override
  void popDebugGroup() {
    _popDebugGroup();
  }

  @override
  void resolveQuerySet(
    QuerySet querySet,
    Buffer destination, {
    required int firstQuery,
    required int queryCount,
    required int destinationOffset,
  }) {
    _resolveQuerySet(querySet, firstQuery, queryCount, destination, destinationOffset);
  }

  void writeTimestamp(QuerySet querySet, int queryIndex) {
    _writeTimestamp(querySet, queryIndex);
  }
}

final class ComputePassEncoder extends _ComputePassEncoderBase implements webgpu.ComputePassEncoder {
  ComputePassEncoder._(super.ptr) : super._();
  ComputePassEncoder._borrowed(super.ptr) : super._borrowed();

  @override
  void dispatchWorkgroups(int x, [int? y, int? z]) {
    _dispatchWorkgroups(x, y ?? 1, z ?? 1);
  }

  @override
  void dispatchWorkgroupsIndirect(Buffer indirectBuffer, {int indirectOffset = 0}) {
    _dispatchWorkgroupsIndirect(indirectBuffer, indirectOffset);
  }

  @override
  void end() {
    _end();
  }

  @override
  void insertDebugMarker(String markerLabel) {
    _insertDebugMarker(markerLabel);
  }

  @override
  set label(String value) {
    _setLabel(value);
  }

  @override
  void popDebugGroup() {
    _popDebugGroup();
  }

  @override
  void pushDebugGroup(String groupLabel) {
    _pushDebugGroup(groupLabel);
  }

  @override
  void setBindGroup(int index, BindGroup? bindGroup, {List<int>? dynamicOffsets}) {
    _setBindGroup(index, bindGroup, dynamicOffsets ?? const []);
  }

  @override
  void setImmediates(int offset, TypedData data) => _withNativeMemory(data, (ptr) {
    _setImmediates(offset, ptr, data.lengthInBytes);
  });

  @override
  void setPipeline(ComputePipeline pipeline) {
    _setPipeline(pipeline);
  }
}

final class ComputePipeline extends _ComputePipelineBase implements webgpu.ComputePipeline {
  ComputePipeline._(super.ptr) : super._();
  ComputePipeline._borrowed(super.ptr) : super._borrowed();

  @override
  BindGroupLayout getBindGroupLayout(int index) => _getBindGroupLayout(index);

  @override
  set label(String value) => _setLabel(value);
}

final class Device extends _DeviceBase implements webgpu.Device {
  Device._(super.ptr) : super._() {
    registerDevice(this);
  }

  Device._borrowed(super.ptr) : super._borrowed();

  @override
  Buffer createBuffer(webgpu.BufferDescriptor descriptor) => _createBuffer(descriptor);

  @override
  Texture createTexture(webgpu.TextureDescriptor descriptor) => _createTexture(descriptor);

  @override
  late final Queue queue = _getQueue();

  @override
  CommandEncoder createCommandEncoder([webgpu.CommandEncoderDescriptor? descriptor]) =>
      _createCommandEncoder(descriptor);

  @override
  RenderPipeline createRenderPipeline(webgpu.RenderPipelineDescriptor descriptor) => _createRenderPipeline(descriptor);

  @override
  ShaderModule createShaderModule(webgpu.ShaderModuleDescriptor descriptor) => _createShaderModule(descriptor);

  @override
  BindGroupLayout createBindGroupLayout(webgpu.BindGroupLayoutDescriptor descriptor) =>
      _createBindGroupLayout(descriptor);

  @override
  BindGroup createBindGroup(webgpu.BindGroupDescriptor descriptor) => _createBindGroup(descriptor);

  @override
  AdapterInfo get adapterInfo => _getAdapterInfo();

  @override
  ComputePipeline createComputePipeline(webgpu.ComputePipelineDescriptor descriptor) {
    return _createComputePipeline(descriptor);
  }

  @override
  Future<ComputePipeline> createComputePipelineAsync(webgpu.ComputePipelineDescriptor descriptor) {
    return _createComputePipelineAsync(descriptor);
  }

  @override
  PipelineLayout createPipelineLayout(webgpu.PipelineLayoutDescriptor descriptor) {
    return _createPipelineLayout(descriptor);
  }

  @override
  QuerySet createQuerySet(webgpu.QuerySetDescriptor descriptor) {
    return _createQuerySet(descriptor);
  }

  @override
  RenderBundleEncoder createRenderBundleEncoder(webgpu.RenderBundleEncoderDescriptor descriptor) {
    return _createRenderBundleEncoder(descriptor);
  }

  @override
  Future<RenderPipeline> createRenderPipelineAsync(webgpu.RenderPipelineDescriptor descriptor) {
    return _createRenderPipelineAsync(descriptor);
  }

  @override
  Sampler createSampler(webgpu.SamplerDescriptor descriptor) {
    return _createSampler(descriptor);
  }

  @override
  webgpu.SupportedFeatures get features => _getFeatures();

  bool hasFeature(webgpu.FeatureName feature) {
    return _hasFeature(feature);
  }

  @override
  set label(String value) => _setLabel(value);

  @override
  webgpu.Limits get limits => _getLimits();

  @override
  Future<webgpu.ErrorType> popErrorScope() {
    return _popErrorScope();
  }

  @override
  void pushErrorScope(webgpu.ErrorFilter filter) {
    _pushErrorScope(filter);
  }
}

final class ExternalTexture extends _ExternalTextureBase implements webgpu.ExternalTexture {
  ExternalTexture._(super.ptr) : super._();
  ExternalTexture._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);
}

final class PipelineLayout extends _PipelineLayoutBase implements webgpu.PipelineLayout {
  PipelineLayout._(super.ptr) : super._();
  PipelineLayout._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);
}

final class QuerySet extends _QuerySetBase implements webgpu.QuerySet {
  QuerySet._(super.ptr) : super._();
  QuerySet._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);

  @override
  int get count => _getCount();

  @override
  webgpu.QueryType get type => _getType();
}

final class Queue extends _QueueBase implements webgpu.Queue {
  Queue._(super.ptr) : super._();
  Queue._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String label) => _setLabel(label);

  @override
  Future<void> onSubmittedWorkDone() => _onSubmittedWorkDone();

  @override
  void submit(List<webgpu.CommandBuffer> commandBuffers) => _submit(commandBuffers.cast());

  @override
  void writeBuffer(covariant Buffer buffer, int bufferOffset, TypedData data) => _withNativeMemory(data, (ptr) {
    _writeBuffer(buffer, bufferOffset, ptr, data.lengthInBytes);
  });

  @override
  void writeTexture(
    webgpu.TexelCopyTextureInfo destination,
    TypedData data,
    webgpu.TexelCopyBufferLayout layout,
    webgpu.Extent3D writeSize,
  ) => _withNativeMemory(data, (ptr) {
    _writeTexture(destination, ptr, data.lengthInBytes, layout, writeSize);
  });
}

final class RenderBundleEncoder extends _RenderBundleEncoderBase implements webgpu.RenderBundleEncoder {
  RenderBundleEncoder._(super.ptr) : super._();
  RenderBundleEncoder._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);

  @override
  void draw(int vertexCount, {int instanceCount = 1, int firstVertex = 0, int firstInstance = 0}) {
    _draw(vertexCount, instanceCount, firstVertex, firstInstance);
  }

  @override
  void drawIndexed(
    int indexCount, {
    int instanceCount = 1,
    int firstIndex = 0,
    int baseVertex = 0,
    int firstInstance = 0,
  }) {
    _drawIndexed(indexCount, instanceCount, firstIndex, baseVertex, firstInstance);
  }

  @override
  void drawIndexedIndirect(Buffer indirectBuffer, {int offset = 0}) {
    _drawIndexedIndirect(indirectBuffer, offset);
  }

  @override
  void drawIndirect(Buffer indirectBuffer, {int offset = 0}) {
    _drawIndirect(indirectBuffer, offset);
  }

  @override
  RenderBundle finish([RenderBundleDescriptor? descriptor]) {
    return _finish(descriptor);
  }

  @override
  void insertDebugMarker(String markerLabel) {
    _insertDebugMarker(markerLabel);
  }

  @override
  void popDebugGroup() {
    _popDebugGroup();
  }

  @override
  void pushDebugGroup(String groupLabel) {
    _pushDebugGroup(groupLabel);
  }

  @override
  void setBindGroup(int index, BindGroup? bindGroup, {List<int>? dynamicOffsets}) {
    _setBindGroup(index, bindGroup, dynamicOffsets ?? const []);
  }

  @override
  void setImmediates(int offset, TypedData data) => _withNativeMemory(data, (ptr) {
    _setImmediates(offset, ptr, data.lengthInBytes);
  });

  @override
  void setIndexBuffer(Buffer buffer, webgpu.IndexFormat format, {int offset = 0, int? size}) {
    return _setIndexBuffer(buffer, format, offset, size ?? (buffer.size - offset));
  }

  @override
  void setPipeline(RenderPipeline pipeline) {
    return _setPipeline(pipeline);
  }

  @override
  void setVertexBuffer(int slot, Buffer? buffer, {int offset = 0, int? size}) {
    if (buffer == null) return _setVertexBuffer(slot, buffer, offset, 0);
    return _setVertexBuffer(slot, buffer, offset, size ?? (buffer.size - offset));
  }
}

final class RenderBundle extends _RenderBundleBase implements webgpu.RenderBundle {
  RenderBundle._(super.ptr) : super._();
  RenderBundle._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);
}

final class RenderPassEncoder extends _RenderPassEncoderBase implements webgpu.RenderPassEncoder {
  RenderPassEncoder._(super.ptr) : super._();
  RenderPassEncoder._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);

  @override
  void end() => _end();

  @override
  void setPipeline(RenderPipeline pipeline) => _setPipeline(pipeline);

  @override
  void setBindGroup(int index, BindGroup? bindGroup, {List<int>? dynamicOffsets}) =>
      _setBindGroup(index, bindGroup, dynamicOffsets ?? const []);

  @override
  void beginOcclusionQuery(int queryIndex) {
    _beginOcclusionQuery(queryIndex);
  }

  @override
  void draw(int vertexCount, {int instanceCount = 1, int firstVertex = 0, int firstInstance = 0}) {
    _draw(vertexCount, instanceCount, firstVertex, firstInstance);
  }

  @override
  void drawIndexed(
    int indexCount, {
    int instanceCount = 1,
    int firstIndex = 0,
    int baseVertex = 0,
    int firstInstance = 0,
  }) {
    _drawIndexed(indexCount, instanceCount, firstIndex, baseVertex, firstInstance);
  }

  @override
  void drawIndexedIndirect(Buffer indirectBuffer, {int offset = 0}) {
    _drawIndexedIndirect(indirectBuffer, offset);
  }

  @override
  void drawIndirect(Buffer indirectBuffer, {int offset = 0}) {
    _drawIndirect(indirectBuffer, offset);
  }

  @override
  void endOcclusionQuery() {
    _endOcclusionQuery();
  }

  @override
  void executeBundles(List<webgpu.RenderBundle> bundles) {
    _executeBundles(bundles.cast());
  }

  @override
  void insertDebugMarker(String markerLabel) {
    _insertDebugMarker(markerLabel);
  }

  @override
  void popDebugGroup() {
    _popDebugGroup();
  }

  @override
  void pushDebugGroup(String groupLabel) {
    _pushDebugGroup(groupLabel);
  }

  @override
  void setBlendConstant(webgpu.Color color) {
    _setBlendConstant(color);
  }

  @override
  void setImmediates(int offset, TypedData data) => _withNativeMemory(
    data,
    (ptr) => _setImmediates(offset, ptr, data.lengthInBytes),
  );

  @override
  void setIndexBuffer(Buffer buffer, webgpu.IndexFormat format, {int offset = 0, int? size}) {
    _setIndexBuffer(buffer, format, offset, size ?? (buffer.size - offset));
  }

  @override
  void setScissorRect({int x = 0, int y = 0, int width = 0, int height = 0}) {
    _setScissorRect(x, y, width, height);
  }

  @override
  void setStencilReference(int reference) {
    _setStencilReference(reference);
  }

  @override
  void setVertexBuffer(int slot, Buffer? buffer, {int offset = 0, int? size}) {
    if (buffer == null) return _setVertexBuffer(slot, buffer, offset, 0);
    _setVertexBuffer(slot, buffer, offset, size ?? (buffer.size - offset));
  }

  @override
  void setViewport({
    double x = 0,
    double y = 0,
    double width = 0,
    double height = 0,
    double minDepth = 0,
    double maxDepth = 1,
  }) {
    _setViewport(x, y, width, height, minDepth, maxDepth);
  }
}

final class RenderPipeline extends _RenderPipelineBase implements webgpu.RenderPipeline {
  RenderPipeline._(super.ptr) : super._();
  RenderPipeline._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);

  @override
  BindGroupLayout getBindGroupLayout(int index) => _getBindGroupLayout(index);
}

final class Sampler extends _SamplerBase implements webgpu.Sampler {
  Sampler._(super.ptr) : super._();
  Sampler._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);
}

final class ShaderModule extends _ShaderModuleBase implements webgpu.ShaderModule {
  ShaderModule._(super.ptr) : super._();
  ShaderModule._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);

  @override
  Future<webgpu.CompilationInfo> get compilationInfo => _getCompilationInfo();
}

final class Surface extends _SurfaceBase implements webgpu.Surface {
  Surface._(super.ptr) : super._();
  Surface._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);

  @override
  webgpu.SurfaceTexture get currentTexture => _getCurrentTexture();

  @override
  webgpu.SurfaceCapabilities getCapabilities(Adapter adapter) => _getCapabilities(adapter);

  @override
  void configure(webgpu.SurfaceConfiguration configuration) {
    _configure(configuration);
  }

  @override
  webgpu.Status present() {
    return _present();
  }

  @override
  void unconfigure() {
    _unconfigure();
  }
}

final class TextureView extends _TextureViewBase implements webgpu.TextureView {
  TextureView._(super.ptr) : super._();
  TextureView._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);
}

final class Texture extends _TextureBase implements webgpu.Texture {
  Texture._(super.ptr) : super._();
  Texture._borrowed(super.ptr) : super._borrowed();

  @override
  set label(String value) => _setLabel(value);

  @override
  TextureView createView([TextureViewDescriptor? descriptor]) => _createView(descriptor);

  @override
  int get depthOrArrayLayers => _getDepthOrArrayLayers();

  @override
  webgpu.TextureDimension get dimension => _getDimension();

  @override
  webgpu.TextureFormat get format => _getFormat();

  @override
  int get height => _getHeight();

  @override
  int get mipLevelCount => _getMipLevelCount();

  @override
  int get sampleCount => _getSampleCount();

  @override
  webgpu.TextureViewDimension get textureBindingViewDimension => _getTextureBindingViewDimension();

  @override
  webgpu.TextureUsage get usage => _getUsage();

  @override
  int get width => _getWidth();
}

void _withNativeMemory(TypedData data, void Function(ffi.Pointer<ffi.Void> ptr) callback) => using((allocator) {
  final tmpPtr = allocator.allocate<ffi.Uint8>(data.lengthInBytes);
  final dataList = data.buffer.asUint8List();
  tmpPtr
      .asTypedList(data.lengthInBytes)
      .setAll(0, dataList.getRange(data.offsetInBytes, data.offsetInBytes + data.lengthInBytes));

  callback(tmpPtr.cast());
});
