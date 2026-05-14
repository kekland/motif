import 'dart:typed_data';
import 'package:vector_math/vector_math.dart' as vm32;
import 'package:vector_math/vector_math_64.dart' as vm64;

part 'types.g.dart';

// TODO: Implement this at some point?
extension HalfPrecisionByteDataExt on ByteData {
  double getFloat16(int offset, [Endian endian = .big]) => throw UnimplementedError();
  void setFloat16(int offset, double value, [Endian endian = .big]) => throw UnimplementedError();
}

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
  const StorageBufferView(this.name);
  final String name;
}

class StorageBuffer {
  const StorageBuffer(this.name);
  final String name;
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