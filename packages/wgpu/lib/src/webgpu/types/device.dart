part of '../webgpu.g.dart';

mixin _DeviceImpl on _DeviceBase {
  Future<ComputePipeline> createComputePipelineAsync(ComputePipelineDescriptor descriptor) => _createComputePipelineAsyncImpl(descriptor);
  ComputePipeline createComputePipeline(ComputePipelineDescriptor descriptor) => _createComputePipelineImpl(descriptor);

  Future<RenderPipeline> createRenderPipelineAsync(RenderPipelineDescriptor descriptor) => _createRenderPipelineAsyncImpl(descriptor);
  RenderPipeline createRenderPipeline(RenderPipelineDescriptor descriptor) => _createRenderPipelineImpl(descriptor);

  BindGroup createBindGroup(BindGroupDescriptor descriptor) => _createBindGroupImpl(descriptor);
  BindGroupLayout createBindGroupLayout(BindGroupLayoutDescriptor descriptor) => _createBindGroupLayoutImpl(descriptor);

  Buffer createBuffer(BufferDescriptor descriptor) => _createBufferImpl(descriptor);
  CommandEncoder createCommandEncoder([CommandEncoderDescriptor? descriptor]) => _createCommandEncoderImpl(descriptor);
  PipelineLayout createPipelineLayout(PipelineLayoutDescriptor descriptor) => _createPipelineLayoutImpl(descriptor);
  QuerySet createQuerySet(QuerySetDescriptor descriptor) => _createQuerySetImpl(descriptor);
  RenderBundleEncoder createRenderBundleEncoder(RenderBundleEncoderDescriptor descriptor) => _createRenderBundleEncoderImpl(descriptor);
  Sampler createSampler(SamplerDescriptor descriptor) => _createSamplerImpl(descriptor);
  ShaderModule createShaderModule(ShaderModuleDescriptor descriptor) => _createShaderModuleImpl(descriptor);
  Texture createTexture(TextureDescriptor descriptor) => _createTextureImpl(descriptor);
  void destroy() => _destroyImpl();
  AdapterInfo get adapterInfo => _getAdapterInfoImpl();
  SupportedFeatures get features => _getFeaturesImpl();
  WGPUFuture get lost => _getLostFutureImpl();
  Queue get queue => _getQueueImpl();
  bool hasFeature(FeatureName feature) => _hasFeatureImpl(feature);
  
  void pushErrorScope(ErrorFilter filter) => _pushErrorScopeImpl(filter);
  Future<ErrorType> popErrorScope() => _popErrorScopeImpl();
  set label(String label) => _setLabelImpl(label);
}
