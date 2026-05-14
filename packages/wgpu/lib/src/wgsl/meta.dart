part of 'wgsl.dart';

class Overrides {
  const Overrides();
}

class Struct {
  const Struct(this.name);
  final String name;
}

class UniformBufferView {
  const UniformBufferView(this.name);
  final String name;
}

class UniformBuffer {
  const UniformBuffer(this.name);
  final String name;
}

class StorageBufferView {
  const StorageBufferView(this.names);
  final List<String> names;
}

class StorageBuffer {
  const StorageBuffer(this.names);
  final List<String> names;
}

class BindGroupLayoutDescriptor {
  const BindGroupLayoutDescriptor(this.id);
  final int id;
}

class BindGroupLayout {
  const BindGroupLayout(this.id);
  final int id;
}

class BindGroup {
  const BindGroup(this.id);
  final int id;
}

class PipelineLayout {
  const PipelineLayout(this.name);
  final String name;
}

class VertexBufferLayout {
  const VertexBufferLayout(this.fnName);
  final String fnName;
}

class VertexBufferView {
  const VertexBufferView(this.fnName);
  final String fnName;
}

class VertexBuffer {
  const VertexBuffer(this.fnName);
  final String fnName;
}

class ComputeState {
  const ComputeState(this.fnName);
  final String fnName;
}

class VertexState {
  const VertexState(this.fnName);
  final String fnName;
}

class FragmentState {
  const FragmentState(this.fnName);
  final String fnName;
}

class ComputePipeline {
  const ComputePipeline(this.fnName);
  final String fnName;
}

class RenderPipeline {
  const RenderPipeline(this.vertexFnName, this.fragmentFnName);
  final String vertexFnName;
  final String fragmentFnName;
}

class ShaderSource {
  const ShaderSource(this.name);
  final String name;
}

class ShaderModule {
  const ShaderModule(this.name);
  final String name;
}