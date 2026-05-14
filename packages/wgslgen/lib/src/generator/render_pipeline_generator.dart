part of '../generator.dart';

List<String> generateRenderPipeline(
  String name,
  FunctionInfo vertexFunc,
  FunctionInfo fragmentFunc,
  Map<int, Map<int, VariableInfo>> groups,
) {
  final lines = <String>[];

  final vertexFuncName = vertexFunc.dartName;
  final capVertexFuncName = vertexFuncName[0].toUpperCase() + vertexFuncName.substring(1);

  final fragmentFuncName = fragmentFunc.dartName;
  final capFragmentFuncName = fragmentFuncName[0].toUpperCase() + fragmentFuncName.substring(1);

  final createVertexStateFunc = 'create${capVertexFuncName}VertexState';
  final createFragmentStateFunc = 'create${capFragmentFuncName}FragmentState';

  final _groups = <int, Map<int, VariableInfo>>{};
  for (final resource in vertexFunc.resources) {
    _groups[resource.group] ??= {};
    _groups[resource.group]![resource.binding] = groups[resource.group]![resource.binding]!;
  }
  for (final resource in fragmentFunc.resources) {
    _groups[resource.group] ??= {};
    _groups[resource.group]![resource.binding] = groups[resource.group]![resource.binding]!;
  }

  lines.addAll(generatePipelineLayout(name, [capVertexFuncName, capFragmentFuncName], _groups));
  lines.add('');

  final createPipelineLayoutFn = 'create$capVertexFuncName${capFragmentFuncName}PipelineLayout';

  lines.add('@wgsl.RenderPipeline(\'${vertexFunc.name}\', \'${fragmentFunc.name}\')');
  lines.add('wgpu.RenderPipeline create$capVertexFuncName${capFragmentFuncName}RenderPipeline(');
  lines.add('  wgpu.Device device,');
  lines.add('  wgpu.ShaderModule module,');
  lines.add('  List<wgpu.ColorTargetState> targets, {');
  lines.add('  wgpu.PipelineLayout? layout,');
  lines.add('  Overrides? overrides,');
  lines.add('  wgpu.PrimitiveState primitive = const wgpu.PrimitiveState(),');
  lines.add('  wgpu.MultisampleState multisample = const wgpu.MultisampleState(),');
  lines.add('  wgpu.DepthStencilState? depthStencil,');
  lines.add('  List<wgpu.VertexBufferLayout>? vertexBuffers,');
  lines.add('}) => device.createRenderPipeline(.new(');
  lines.add('  label: \'($name) ${vertexFunc.name}-${fragmentFunc.name} render pipeline\',');
  lines.add('  layout: layout ?? $createPipelineLayoutFn(device),');
  lines.add('  vertex: $createVertexStateFunc(module, overrides: overrides, vertexBuffers: vertexBuffers),');
  lines.add('  fragment: $createFragmentStateFunc(module, targets, overrides: overrides),');
  lines.add('  primitive: primitive,');
  lines.add('  multisample: multisample,');
  lines.add('  depthStencil: depthStencil,');
  lines.add('));');

  return lines;
}
