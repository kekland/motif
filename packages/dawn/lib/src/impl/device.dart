part of '../src.dart';

class Device extends _Device {
  Device._(super.ptr) : super._();
  Device._borrowed(super.ptr) : super._borrowed();
  
  BindGroup createBindGroup(BindGroupDescriptor descriptor) => _deviceCreateBindGroup(this, descriptor);
  BindGroupLayout createBindGroupLayout(BindGroupLayoutDescriptor descriptor) => _deviceCreateBindGroupLayout(this, descriptor);
  Buffer? createBuffer(BufferDescriptor descriptor) => _deviceCreateBuffer(this, descriptor);
  CommandEncoder createCommandEncoder([CommandEncoderDescriptor? descriptor]) => _deviceCreateCommandEncoder(this, descriptor);
  ComputePipeline createComputePipeline(ComputePipelineDescriptor descriptor) => _deviceCreateComputePipeline(this, descriptor);
  Future<ComputePipeline> createComputePipelineAsync(ComputePipelineDescriptor descriptor) => _deviceCreateComputePipelineAsync(this, descriptor);
  Buffer createErrorBuffer(BufferDescriptor descriptor) => _deviceCreateErrorBuffer(this, descriptor);
  ExternalTexture createErrorExternalTexture() => _deviceCreateErrorExternalTexture(this);
  ShaderModule createErrorShaderModule(ShaderModuleDescriptor descriptor, String errorMessage) => _deviceCreateErrorShaderModule(this, descriptor, errorMessage);
  Texture createErrorTexture(TextureDescriptor descriptor) => _deviceCreateErrorTexture(this, descriptor);
  ExternalTexture createExternalTexture(ExternalTextureDescriptor descriptor) => _deviceCreateExternalTexture(this, descriptor);
  PipelineLayout createPipelineLayout(PipelineLayoutDescriptor descriptor) => _deviceCreatePipelineLayout(this, descriptor);
  QuerySet createQuerySet(QuerySetDescriptor descriptor) => _deviceCreateQuerySet(this, descriptor);
  RenderBundleEncoder createRenderBundleEncoder(RenderBundleEncoderDescriptor descriptor) => _deviceCreateRenderBundleEncoder(this, descriptor);
  RenderPipeline createRenderPipeline(RenderPipelineDescriptor descriptor) => _deviceCreateRenderPipeline(this, descriptor);
  Future<RenderPipeline> createRenderPipelineAsync(RenderPipelineDescriptor descriptor) => _deviceCreateRenderPipelineAsync(this, descriptor);
  ResourceTable createResourceTable(ResourceTableDescriptor descriptor) => _deviceCreateResourceTable(this, descriptor);
  Sampler createSampler(SamplerDescriptor descriptor) => _deviceCreateSampler(this, descriptor);
  ShaderModule createShaderModule(ShaderModuleDescriptor descriptor) => _deviceCreateShaderModule(this, descriptor);
  Texture createTexture(TextureDescriptor descriptor) => _deviceCreateTexture(this, descriptor);
  void destroy() => _deviceDestroy(this);
  void forceLoss(DeviceLostReason reason, String message) => _deviceForceLoss(this, reason, message);
  Adapter get adapter => _deviceGetAdapter(this);
  AdapterInfo get adapterInfo => _deviceGetAdapterInfo(this);
  AHardwareBufferProperties getAHardwareBufferProperties(Pointer<Void> handle) => _deviceGetAHardwareBufferProperties(this, handle);
  SupportedFeatures get features => _deviceGetFeatures(this);
  WGPUFuture get lost => _deviceGetLostFuture(this);
  Queue get queue => _deviceGetQueue(this);
  bool hasFeature(FeatureName feature) => _deviceHasFeature(this, feature);
  SharedBufferMemory importSharedBufferMemory(SharedBufferMemoryDescriptor descriptor) => _deviceImportSharedBufferMemory(this, descriptor);
  SharedFence importSharedFence(SharedFenceDescriptor descriptor) => _deviceImportSharedFence(this, descriptor);
  SharedTextureMemory importSharedTextureMemory(SharedTextureMemoryDescriptor descriptor) => _deviceImportSharedTextureMemory(this, descriptor);
  void injectError(ErrorType type, String message) => _deviceInjectError(this, type, message);
  Future<ErrorType> popErrorScope() => _devicePopErrorScope(this);
  void pushErrorScope(ErrorFilter filter) => _devicePushErrorScope(this, filter);
  void setLabel(String label) => _deviceSetLabel(this, label);
  void setLoggingCallback(LoggingCallbackListener listener) => _deviceSetLoggingCallback(this, listener);
  void tick() => _deviceTick(this);
  void validateTextureDescriptor(TextureDescriptor descriptor) => _deviceValidateTextureDescriptor(this, descriptor);
}
