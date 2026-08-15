part of '../generator.dart';

const _preferInline = '@pragma(\'vm:prefer-inline\')';

String _labelStr(String label) => '\'$label\'';
// String _labelsStr(List<String> labels) => labels.isEmpty ? '\'\'' : '\'${labels.join(', ')}\'';
String _labelsArr(List<String> labels) => '[${labels.map((l) => '\'$l\'').join(', ')}]';

String _wgpuLabel(String label) => '\'($_module) $label\'';

const _metaOverrides = '@meta.Overrides()';

// String _metaStructView(List<String> labels) => '@meta.StructView(${_labelsStr(labels)})';

String _metaUniformBufferView(List<String> labels) => '@meta.UniformBufferView(${_labelsArr(labels)})';
String _metaUniformBuffer(List<String> labels) => '@meta.UniformBuffer(${_labelsArr(labels)})';

String _metaStorageBufferView(List<String> labels) => '@meta.StorageBufferView(${_labelsArr(labels)})';
String _metaStorageBuffer(List<String> labels) => '@meta.StorageBuffer(${_labelsArr(labels)})';

String _metaVertexBufferLayout(String label) => '@meta.VertexBufferLayout(${_labelStr(label)})';
String _metaVertexBufferView(String label) => '@meta.VertexBufferView(${_labelStr(label)})';
String _metaVertexBuffer(String label) => '@meta.VertexBuffer(${_labelStr(label)})';

String _metaBindGroupLayoutDescriptor(int group) => '@meta.BindGroupLayoutDescriptor($group)';
String _metaBindGroupLayout(int group) => '@meta.BindGroupLayout($group)';

String _metaBindGroup(int group) => '@meta.BindGroup($group)';

String _metaComputeState(String funcName) => '@meta.ComputeState(${_labelStr(funcName)})';
String _metaFragmentState(String funcName) => '@meta.FragmentState(${_labelStr(funcName)})';
String _metaVertexState(String funcName) => '@meta.VertexState(${_labelStr(funcName)})';

String _metaPipelineLayout(String name) => '@meta.PipelineLayout(${_labelStr(name)})';
String _metaComputePipeline(String funcName) => '@meta.ComputePipeline(${_labelStr(funcName)})';
String _metaRenderPipeline(String vertexFuncName, String fragmentFuncName) =>
    '@meta.RenderPipeline(${_labelStr(vertexFuncName)}, ${_labelStr(fragmentFuncName)})';

String _metaShaderSource(String name) => '@meta.ShaderSource(${_labelStr(name)})';
String _metaShaderModule(String name) => '@meta.ShaderModule(${_labelStr(name)})';
