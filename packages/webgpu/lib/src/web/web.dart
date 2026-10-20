import 'dart:typed_data';

import 'package:webgpu/webgpu.dart' as webgpu;
import 'package:web/web.dart' as web;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'webgpu.g.dart' as web;
import 'converter.dart';

void initializeWebGpu({
  webgpu.LogLevel logLevel = .off,
  webgpu.LogCallback? logCallback,
}) {}

final _instance = Instance._(web.window.navigator.getProperty('gpu'.toJS));
webgpu.Instance createDefaultInstance() => _instance;

abstract class _JsFinalizable<T extends JSObject> {
  _JsFinalizable() {
    _finalizer.attach(this, obj);
  }

  _JsFinalizable.borrowed();

  T get obj;
  Finalizer<T> get _finalizer;
  var _disposed = false;

  void _disposer() {}

  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _disposer();
    _disposed = true;
  }
}

final class Instance._(final web.GPU obj) implements webgpu.Instance {
  static Instance get instance => _instance;

  @override
  Future<Adapter> requestAdapter([webgpu.RequestAdapterOptions? options]) async {
    final adapter = await obj.requestAdapter(options?.toJS ?? .new()).toDart;
    if (adapter == null) throw Exception('Failed to request adapter');
    return Adapter._(adapter);
  }
}

final class Adapter._(final web.GPUAdapter obj) implements webgpu.Adapter {
  @override
  Future<webgpu.Device> requestDevice([webgpu.DeviceDescriptor? descriptor]) async {
    final result = await obj.requestDevice(descriptor?.toJS ?? .new()).toDart;
    return Device._(result);
  }
}

final class BindGroupLayout._(final web.GPUBindGroupLayout obj) implements webgpu.BindGroupLayout {
  @override
  set label(String label) => obj.label = label;
}

final class BindGroup._(final web.GPUBindGroup obj) implements webgpu.BindGroup {
  @override
  set label(String label) => obj.label = label;
}

final class Buffer extends _JsFinalizable<web.GPUBuffer> implements webgpu.Buffer {
  Buffer._(this.obj) : super();
  Buffer.from(this.obj) : super.borrowed();

  @override
  final web.GPUBuffer obj;

  late final _impl = webgpu.BufferImpl(this);

  @override
  set label(String label) => obj.label = label;

  @override
  webgpu.BufferUsage get usage => .new(obj.usage);

  @override
  webgpu.BufferMapState get mapState => .fromName(obj.mapState) ?? .zero;

  @override
  int get size => obj.size;

  @override
  Future<void> mapAsync({int offset = 0, int? size, webgpu.MapMode mode = .read}) {
    return _impl.mapAsync(offset: offset, size: size ?? this.size, mode: mode);
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
  Future<void> internalMapAsync(webgpu.MapMode mode, int offset, int size) {
    return obj.mapAsync(mode.value, offset, size).toDart;
  }

  @override
  void internalMapSync(webgpu.MapMode mode, int offset, int size) {
    throw UnimplementedError('web can only do async mapping');
  }

  @override
  TypedData internalGetMappedRange(int offset, int size, {bool readOnly = false}) {
    final buffer = obj.getMappedRange(offset, size);
    return buffer.toDart.asUint8List();
  }

  @override
  void internalWriteMappedRange(TypedData data, {int offset = 0}) {
    final buffer = obj.getMappedRange(offset, data.lengthInBytes);
    buffer.toDart.asUint8List().setAll(0, data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  @override
  void internalUnmap() {
    obj.unmap();
  }

  @override
  void _disposer() => obj.destroy();

  @override
  Finalizer<web.GPUBuffer> get _finalizer => __finalizer;
  static final __finalizer = Finalizer<web.GPUBuffer>((v) => v.destroy());
}

final class CommandBuffer._(final web.GPUCommandBuffer obj) implements webgpu.CommandBuffer {
  @override
  set label(String label) => obj.label = label;
}

final class CommandEncoder._(final web.GPUCommandEncoder obj) implements webgpu.CommandEncoder {
  @override
  set label(String label) => obj.label = label;

  @override
  RenderPassEncoder beginRenderPass(webgpu.RenderPassDescriptor descriptor) {
    return ._(obj.beginRenderPass(descriptor.toJS));
  }

  @override
  void copyTextureToBuffer(
    webgpu.TexelCopyTextureInfo source,
    webgpu.TexelCopyBufferInfo destination,
    webgpu.Extent3D copySize,
  ) {
    obj.copyTextureToBuffer(
      source.toJS,
      destination.toJS,
      copySize.toJS,
    );
  }

  @override
  CommandBuffer finish([webgpu.CommandBufferDescriptor? descriptor]) {
    return ._(obj.finish(.new()));
  }

  @override
  ComputePassEncoder beginComputePass([webgpu.ComputePassDescriptor? descriptor]) {
    return ._(obj.beginComputePass(descriptor?.toJS ?? .new()));
  }

  @override
  void clearBuffer(Buffer buffer, {int offset = 0, int? size}) {
    obj.clearBuffer(buffer.toJS, offset, size ?? (buffer.size - offset));
  }

  @override
  void copyBufferToBuffer(
    Buffer source,
    Buffer destination, {
    int sourceOffset = 0,
    int destinationOffset = 0,
    required int size,
  }) {
    obj.copyBufferToBuffer(
      source.toJS,
      sourceOffset.toJS,
      destination.toJS,
      destinationOffset,
      size,
    );
  }

  @override
  void copyBufferToTexture(
    webgpu.TexelCopyBufferInfo source,
    webgpu.TexelCopyTextureInfo destination,
    webgpu.Extent3D copySize,
  ) {
    obj.copyBufferToTexture(
      source.toJS,
      destination.toJS,
      copySize.toJS,
    );
  }

  @override
  void insertDebugMarker(String markerLabel) {
    obj.insertDebugMarker(markerLabel);
  }

  @override
  void popDebugGroup() {
    obj.popDebugGroup();
  }

  @override
  void pushDebugGroup(String groupLabel) {
    obj.pushDebugGroup(groupLabel);
  }

  @override
  void resolveQuerySet(
    QuerySet querySet,
    Buffer destination, {
    required int firstQuery,
    required int queryCount,
    required int destinationOffset,
  }) {
    obj.resolveQuerySet(
      querySet.toJS,
      firstQuery,
      queryCount,
      destination.toJS,
      destinationOffset,
    );
  }
}

final class ComputePassEncoder._(final web.GPUComputePassEncoder obj) implements webgpu.ComputePassEncoder {
  @override
  void dispatchWorkgroups(int x, [int? y, int? z]) {
    obj.dispatchWorkgroups(x, y ?? 1, z ?? 1);
  }

  @override
  void dispatchWorkgroupsIndirect(Buffer indirectBuffer, {int indirectOffset = 0}) {
    obj.dispatchWorkgroupsIndirect(indirectBuffer.toJS, indirectOffset);
  }

  @override
  void end() {
    obj.end();
  }

  @override
  void insertDebugMarker(String markerLabel) {
    obj.insertDebugMarker(markerLabel);
  }

  @override
  set label(String value) {
    obj.label = value;
  }

  @override
  void popDebugGroup() {
    obj.popDebugGroup();
  }

  @override
  void pushDebugGroup(String groupLabel) {
    obj.pushDebugGroup(groupLabel);
  }

  @override
  void setBindGroup(int index, webgpu.BindGroup? bindGroup, {List<int>? dynamicOffsets}) {
    if (dynamicOffsets == null) return obj.setBindGroup(index, bindGroup?.toJS);
    obj.setBindGroup(index, bindGroup?.toJS, _bindGroupDynamicOffsets(dynamicOffsets));
  }

  @override
  void setImmediates(int offset, TypedData data) {
    obj.setImmediates(offset, data.buffer.asUint8List().toJS, data.offsetInBytes, data.lengthInBytes);
  }

  @override
  void setPipeline(ComputePipeline pipeline) {
    obj.setPipeline(pipeline.toJS);
  }
}

final class ComputePipeline._(final web.GPUComputePipeline obj) implements webgpu.ComputePipeline {
  @override
  BindGroupLayout getBindGroupLayout(int index) {
    return BindGroupLayout._(obj.getBindGroupLayout(index));
  }

  @override
  set label(String value) {
    obj.label = value;
  }
}

final class Device extends _JsFinalizable<web.GPUDevice> implements webgpu.Device {
  Device._(this.obj) : super();
  Device.from(this.obj) : super.borrowed();

  @override
  final web.GPUDevice obj;

  @override
  late final Queue queue = Queue._(obj.queue);

  @override
  Buffer createBuffer(webgpu.BufferDescriptor descriptor) {
    return Buffer._(obj.createBuffer(descriptor.toJS));
  }

  @override
  Texture createTexture(webgpu.TextureDescriptor descriptor) {
    return Texture._(obj.createTexture(descriptor.toJS));
  }

  @override
  CommandEncoder createCommandEncoder([webgpu.CommandEncoderDescriptor? descriptor]) {
    return CommandEncoder._(obj.createCommandEncoder(descriptor?.toJS ?? .new()));
  }

  @override
  RenderPipeline createRenderPipeline(webgpu.RenderPipelineDescriptor descriptor) {
    return RenderPipeline._(obj.createRenderPipeline(descriptor.toJS));
  }

  @override
  ShaderModule createShaderModule(webgpu.ShaderModuleDescriptor descriptor) {
    return ShaderModule._(obj.createShaderModule(descriptor.toJS));
  }

  @override
  BindGroupLayout createBindGroupLayout(webgpu.BindGroupLayoutDescriptor descriptor) {
    return BindGroupLayout._(obj.createBindGroupLayout(descriptor.toJS));
  }

  @override
  BindGroup createBindGroup(webgpu.BindGroupDescriptor descriptor) {
    return BindGroup._(obj.createBindGroup(descriptor.toJS));
  }

  @override
  webgpu.AdapterInfo get adapterInfo => obj.adapterInfo.toDart;

  @override
  ComputePipeline createComputePipeline(webgpu.ComputePipelineDescriptor descriptor) {
    return ComputePipeline._(obj.createComputePipeline(descriptor.toJS));
  }

  @override
  Future<ComputePipeline> createComputePipelineAsync(webgpu.ComputePipelineDescriptor descriptor) async {
    final pipeline = await obj.createComputePipelineAsync(descriptor.toJS).toDart;
    return ComputePipeline._(pipeline);
  }

  @override
  PipelineLayout createPipelineLayout(webgpu.PipelineLayoutDescriptor descriptor) {
    return PipelineLayout._(obj.createPipelineLayout(descriptor.toJS));
  }

  @override
  QuerySet createQuerySet(webgpu.QuerySetDescriptor descriptor) {
    return QuerySet._(obj.createQuerySet(descriptor.toJS));
  }

  @override
  RenderBundleEncoder createRenderBundleEncoder(webgpu.RenderBundleEncoderDescriptor descriptor) {
    return RenderBundleEncoder._(obj.createRenderBundleEncoder(descriptor.toJS));
  }

  @override
  Future<RenderPipeline> createRenderPipelineAsync(webgpu.RenderPipelineDescriptor descriptor) async {
    final pipeline = await obj.createRenderPipelineAsync(descriptor.toJS).toDart;
    return RenderPipeline._(pipeline);
  }

  @override
  Sampler createSampler(webgpu.SamplerDescriptor descriptor) {
    return Sampler._(obj.createSampler(descriptor.toJS));
  }

  @override
  webgpu.SupportedFeatures get features => obj.features.toDart;

  @override
  set label(String value) {
    obj.label = value;
  }

  @override
  webgpu.Limits get limits => obj.limits.toDart;

  @override
  Future<webgpu.ErrorType> popErrorScope() async {
    final result = await obj.popErrorScope().toDart;
    return result != null ? .fromName(result.message)! : .zero;
  }

  @override
  void pushErrorScope(webgpu.ErrorFilter filter) {
    obj.pushErrorScope(filter.toJS);
  }

  @override
  void _disposer() => obj.destroy();

  @override
  Finalizer<web.GPUDevice> get _finalizer => __finalizer;
  static final __finalizer = Finalizer<web.GPUDevice>((v) => v.destroy());
}

final class ExternalTexture._(final web.GPUExternalTexture obj) implements webgpu.ExternalTexture {
  @override
  set label(String value) {
    obj.label = value;
  }
}

final class PipelineLayout._(final web.GPUPipelineLayout obj) implements webgpu.PipelineLayout {
  @override
  set label(String value) {
    obj.label = value;
  }
}

final class QuerySet extends _JsFinalizable<web.GPUQuerySet> implements webgpu.QuerySet {
  QuerySet._(this.obj) : super();
  QuerySet.from(this.obj) : super.borrowed();

  @override
  final web.GPUQuerySet obj;

  @override
  int get count => obj.count;

  @override
  webgpu.QueryType get type => .fromName(obj.type)!;

  @override
  set label(String value) {
    obj.label = value;
  }

  @override
  void _disposer() => obj.destroy();

  @override
  Finalizer<web.GPUQuerySet> get _finalizer => __finalizer;
  static final __finalizer = Finalizer<web.GPUQuerySet>((v) => v.destroy());
}

final class Queue._(final web.GPUQueue obj) implements webgpu.Queue {
  @override
  set label(String label) => obj.label = label;

  @override
  Future<void> onSubmittedWorkDone() => obj.onSubmittedWorkDone().toDart;

  @override
  void submit(List<webgpu.CommandBuffer> commandBuffers) {
    obj.submit(commandBuffers.map((e) => (e as CommandBuffer).obj).toList().toJS);
  }

  @override
  void writeBuffer(Buffer buffer, int bufferOffset, TypedData data) {
    obj.writeBuffer(buffer.obj, bufferOffset, data.buffer.toJS, data.offsetInBytes, data.lengthInBytes);
  }

  @override
  void writeTexture(
    webgpu.TexelCopyTextureInfo destination,
    TypedData data,
    webgpu.TexelCopyBufferLayout layout,
    webgpu.Extent3D writeSize,
  ) {
    obj.writeTexture(
      destination.toJS,
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes).toJS,
      layout.toJS,
      writeSize.toJS,
    );
  }
}

final class RenderBundleEncoder._(final web.GPURenderBundleEncoder obj) implements webgpu.RenderBundleEncoder {
  @override
  void draw(int vertexCount, {int instanceCount = 1, int firstVertex = 0, int firstInstance = 0}) {
    obj.draw(vertexCount, instanceCount, firstVertex, firstInstance);
  }

  @override
  void drawIndexed(
    int indexCount, {
    int instanceCount = 1,
    int firstIndex = 0,
    int baseVertex = 0,
    int firstInstance = 0,
  }) {
    obj.drawIndexed(indexCount, instanceCount, firstIndex, baseVertex, firstInstance);
  }

  @override
  void drawIndexedIndirect(Buffer indirectBuffer, {int offset = 0}) {
    obj.drawIndexedIndirect(indirectBuffer.obj, offset);
  }

  @override
  void drawIndirect(Buffer indirectBuffer, {int offset = 0}) {
    obj.drawIndirect(indirectBuffer.obj, offset);
  }

  @override
  RenderBundle finish([webgpu.RenderBundleDescriptor? descriptor]) {
    return RenderBundle._(obj.finish(descriptor?.toJS ?? .new()));
  }

  @override
  void insertDebugMarker(String markerLabel) {
    obj.insertDebugMarker(markerLabel);
  }

  @override
  set label(String value) {
    obj.label = value;
  }

  @override
  void popDebugGroup() {
    obj.popDebugGroup();
  }

  @override
  void pushDebugGroup(String groupLabel) {
    obj.pushDebugGroup(groupLabel);
  }

  @override
  void setBindGroup(int index, webgpu.BindGroup? bindGroup, {List<int>? dynamicOffsets}) {
    if (dynamicOffsets == null) return obj.setBindGroup(index, bindGroup?.toJS);
    obj.setBindGroup(index, bindGroup?.toJS, _bindGroupDynamicOffsets(dynamicOffsets));
  }

  @override
  void setImmediates(int offset, TypedData data) {
    obj.setImmediates(offset, data.buffer.asUint8List().toJS, data.offsetInBytes, data.lengthInBytes);
  }

  @override
  void setIndexBuffer(Buffer buffer, webgpu.IndexFormat format, {int offset = 0, int? size}) {
    obj.setIndexBuffer(buffer.obj, format.name!, offset, size ?? (buffer.size - offset));
  }

  @override
  void setPipeline(RenderPipeline pipeline) {
    obj.setPipeline(pipeline.obj);
  }

  @override
  void setVertexBuffer(int slot, Buffer? buffer, {int offset = 0, int? size}) {
    if (buffer == null) return obj.setVertexBuffer(slot, null, offset, 0);
    obj.setVertexBuffer(slot, buffer.obj, offset, size ?? (buffer.size - offset));
  }
}

final class RenderBundle._(final web.GPURenderBundle obj) implements webgpu.RenderBundle {
  @override
  set label(String value) {
    obj.label = value;
  }
}

final class RenderPassEncoder._(final web.GPURenderPassEncoder obj) implements webgpu.RenderPassEncoder {
  @override
  void end() => obj.end();

  @override
  void setPipeline(RenderPipeline pipeline) => obj.setPipeline(pipeline.obj);

  @override
  void setBindGroup(int index, BindGroup? bindGroup, {List<int>? dynamicOffsets}) {
    if (dynamicOffsets == null) return obj.setBindGroup(index, bindGroup?.obj);
    obj.setBindGroup(index, bindGroup?.obj, _bindGroupDynamicOffsets(dynamicOffsets));
  }

  @override
  void beginOcclusionQuery(int queryIndex) {
    obj.beginOcclusionQuery(queryIndex);
  }

  @override
  void draw(int vertexCount, {int instanceCount = 1, int firstVertex = 0, int firstInstance = 0}) {
    obj.draw(vertexCount, instanceCount, firstVertex, firstInstance);
  }

  @override
  void drawIndexed(
    int indexCount, {
    int instanceCount = 1,
    int firstIndex = 0,
    int baseVertex = 0,
    int firstInstance = 0,
  }) {
    obj.drawIndexed(indexCount, instanceCount, firstIndex, baseVertex, firstInstance);
  }

  @override
  void drawIndexedIndirect(Buffer indirectBuffer, {int offset = 0}) {
    obj.drawIndexedIndirect(indirectBuffer.obj, offset);
  }

  @override
  void drawIndirect(Buffer indirectBuffer, {int offset = 0}) {
    obj.drawIndirect(indirectBuffer.obj, offset);
  }

  @override
  void endOcclusionQuery() {
    obj.endOcclusionQuery();
  }

  @override
  void executeBundles(List<webgpu.RenderBundle> bundles) {
    obj.executeBundles(bundles.map((e) => (e as RenderBundle).obj).toList().toJS);
  }

  @override
  void insertDebugMarker(String markerLabel) {
    obj.insertDebugMarker(markerLabel);
  }

  @override
  set label(String value) {
    obj.label = value;
  }

  @override
  void popDebugGroup() {
    obj.popDebugGroup();
  }

  @override
  void pushDebugGroup(String groupLabel) {
    obj.pushDebugGroup(groupLabel);
  }

  @override
  void setBlendConstant(webgpu.Color color) {
    obj.setBlendConstant(color.toJS);
  }

  @override
  void setImmediates(int offset, TypedData data) {
    obj.setImmediates(offset, data.buffer.asUint8List().toJS, data.offsetInBytes, data.lengthInBytes);
  }

  @override
  void setIndexBuffer(Buffer buffer, webgpu.IndexFormat format, {int offset = 0, int? size}) {
    obj.setIndexBuffer(buffer.obj, format.name!, offset, size ?? (buffer.size - offset));
  }

  @override
  void setScissorRect({int x = 0, int y = 0, int width = 0, int height = 0}) {
    obj.setScissorRect(x, y, width, height);
  }

  @override
  void setStencilReference(int reference) {
    obj.setStencilReference(reference);
  }

  @override
  void setVertexBuffer(int slot, Buffer? buffer, {int offset = 0, int? size}) {
    if (buffer == null) return obj.setVertexBuffer(slot, null, offset, 0);
    obj.setVertexBuffer(slot, buffer.obj, offset, size ?? (buffer.size - offset));
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
    obj.setViewport(x, y, width, height, minDepth, maxDepth);
  }
}

final class RenderPipeline._(final web.GPURenderPipeline obj) implements webgpu.RenderPipeline {
  @override
  set label(String value) => obj.label = value;

  @override
  BindGroupLayout getBindGroupLayout(int index) => ._(obj.getBindGroupLayout(index));
}

final class Sampler._(final web.GPUSampler obj) implements webgpu.Sampler {
  @override
  set label(String value) {
    obj.label = value;
  }
}

final class ShaderModule._(final web.GPUShaderModule obj) implements webgpu.ShaderModule {
  @override
  Future<webgpu.CompilationInfo> get compilationInfo async {
    final result = await obj.getCompilationInfo().toDart;
    return result.toDart;
  }

  @override
  set label(String value) {
    obj.label = value;
  }
}

final class TextureView._(final web.GPUTextureView obj) implements webgpu.TextureView {
  @override
  set label(String value) {
    obj.label = value;
  }
}

final class Texture extends _JsFinalizable<web.GPUTexture> implements webgpu.Texture {
  Texture._(this.obj) : super();
  Texture.from(this.obj) : super.borrowed();

  @override
  final web.GPUTexture obj;

  @override
  TextureView createView([webgpu.TextureViewDescriptor? descriptor]) =>
      TextureView._(obj.createView(descriptor?.toJS ?? .new()));

  @override
  int get height => obj.height;

  @override
  int get depthOrArrayLayers => obj.depthOrArrayLayers;

  @override
  webgpu.TextureDimension get dimension => .fromName(obj.dimension)!;

  @override
  webgpu.TextureFormat get format => .fromName(obj.format)!;

  @override
  int get mipLevelCount => obj.mipLevelCount;

  @override
  int get sampleCount => obj.sampleCount;

  @override
  webgpu.TextureViewDimension get textureBindingViewDimension {
    final value = obj.textureBindingViewDimension;
    if (value == null) return .undefined;
    return .fromName(value)!;
  }

  @override
  webgpu.TextureUsage get usage => .new(obj.usage)!;

  @override
  int get width => obj.width;

  @override
  set label(String value) {
    obj.label = value;
  }

  @override
  void _disposer() => obj.destroy();

  @override
  Finalizer<web.GPUTexture> get _finalizer => __finalizer;
  static final __finalizer = Finalizer<web.GPUTexture>((v) => v.destroy());
}

JSUint32Array _bindGroupDynamicOffsets(List<int> dynamicOffsets) {
  final data = Uint32List.fromList(dynamicOffsets);
  return data.toJS;
}
