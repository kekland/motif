part of '../generator.dart';

List<String> generateRenderPipeline(String name, FunctionInfo vertexFunc, FunctionInfo fragmentFunc) {
  final lines = <String>[];

  final vertexFuncName = vertexFunc.dartName;
  final capVertexFuncName = vertexFuncName[0].toUpperCase() + vertexFuncName.substring(1);

  final fragmentFuncName = fragmentFunc.dartName;
  final capFragmentFuncName = fragmentFuncName[0].toUpperCase() + fragmentFuncName.substring(1);

  final createVertexStateFunc = 'create${capVertexFuncName}VertexState';
  final createFragmentStateFunc = 'create${capFragmentFuncName}FragmentState';

  lines.add('@wgsl.RenderPipeline(\'${vertexFunc.name}\', \'${fragmentFunc.name}\')');
  lines.add('wgpu.RenderPipeline create$capVertexFuncName${capFragmentFuncName}RenderPipeline(');
  lines.add('  wgpu.Device device,');
  lines.add('  wgpu.ShaderModule module,');
  lines.add('  wgpu.PipelineLayout layout,');
  lines.add('  List<wgpu.ColorTargetState> targets, {');
  lines.add('  Overrides? overrides,');
  lines.add('  wgpu.PrimitiveState primitive = const wgpu.PrimitiveState(),');
  lines.add('  wgpu.MultisampleState multisample = const wgpu.MultisampleState(),');
  lines.add('  wgpu.DepthStencilState? depthStencil,');
  lines.add('  List<wgpu.VertexBufferLayout>? vertexBuffers,');
  lines.add('}) => device.createRenderPipeline(.new(');
  lines.add('  label: \'($name) ${vertexFunc.name}-${fragmentFunc.name} render pipeline\',');
  lines.add('  layout: layout,');
  lines.add('  vertex: $createVertexStateFunc(module, overrides: overrides, vertexBuffers: vertexBuffers),');
  lines.add('  fragment: $createFragmentStateFunc(module, targets, overrides: overrides),');
  lines.add('  primitive: primitive,');
  lines.add('  multisample: multisample,');
  lines.add('  depthStencil: depthStencil,');
  lines.add('));');

  return lines;
}
