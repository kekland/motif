part of 'types.dart';

abstract class Device {
  set label(String value);

  BindGroup createBindGroup(BindGroupDescriptor descriptor);
  BindGroupLayout createBindGroupLayout(BindGroupLayoutDescriptor descriptor);
  Buffer createBuffer(BufferDescriptor descriptor);

  CommandEncoder createCommandEncoder([CommandEncoderDescriptor? descriptor]);
  ComputePipeline createComputePipeline(ComputePipelineDescriptor descriptor);
  Future<ComputePipeline> createComputePipelineAsync(ComputePipelineDescriptor descriptor);
  RenderPipeline createRenderPipeline(RenderPipelineDescriptor descriptor);
  Future<RenderPipeline> createRenderPipelineAsync(RenderPipelineDescriptor descriptor);

  PipelineLayout createPipelineLayout(PipelineLayoutDescriptor descriptor);
  RenderBundleEncoder createRenderBundleEncoder(RenderBundleEncoderDescriptor descriptor);
  Sampler createSampler(SamplerDescriptor descriptor);
  ShaderModule createShaderModule(ShaderModuleDescriptor descriptor);
  QuerySet createQuerySet(QuerySetDescriptor descriptor);
  Texture createTexture(TextureDescriptor descriptor);

  Limits get limits;
  SupportedFeatures get features;
  AdapterInfo get adapterInfo;
  Queue get queue;

  void pushErrorScope(ErrorFilter filter);
  Future<ErrorType> popErrorScope();

  void dispose();
}
