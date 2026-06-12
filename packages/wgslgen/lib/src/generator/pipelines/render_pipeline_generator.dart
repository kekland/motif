part of '../../generator.dart';

List<String> generateRenderPipeline(
  FunctionInfo vertexFunc,
  FunctionInfo fragmentFunc,
  Map<int, Map<int, VariableInfo>> groups,
  bool isOnlyPipeline,
) {
  final lines = <String>[];

  final capVertexFuncName = vertexFunc.capDartName;
  final capFragmentFuncName = fragmentFunc.capDartName;

  final _groups = <int, Map<int, VariableInfo>>{};
  for (final resource in vertexFunc.resources) {
    _groups[resource.group] ??= {};
    _groups[resource.group]![resource.binding] = groups[resource.group]![resource.binding]!;
  }
  for (final resource in fragmentFunc.resources) {
    _groups[resource.group] ??= {};
    _groups[resource.group]![resource.binding] = groups[resource.group]![resource.binding]!;
  }

  lines.addAll(generatePipelineLayout([capVertexFuncName, capFragmentFuncName], _groups));
  lines.add('');

  final createPipelineLayoutFn = 'create$capVertexFuncName${capFragmentFuncName}PipelineLayout';

  final fnName = isOnlyPipeline
      ? 'createRenderPipeline'
      : 'create$capVertexFuncName${capFragmentFuncName}RenderPipeline';

  lines.add(_metaRenderPipeline(vertexFunc.name, fragmentFunc.name));
  lines.add('wgpu.RenderPipeline $fnName(');
  lines.add('  wgpu.Device device,');
  lines.add('  List<wgpu.ColorTargetState> targets, {');
  lines.add('  wgpu.ShaderModule? module,');
  lines.add('  wgpu.PipelineLayout? layout,');
  lines.add('  Overrides? overrides,');
  lines.add('  wgpu.PrimitiveState primitive = const wgpu.PrimitiveState(),');
  lines.add('  wgpu.MultisampleState multisample = const wgpu.MultisampleState(),');
  lines.add('  wgpu.DepthStencilState? depthStencil,');
  lines.add('  List<wgpu.VertexBufferLayout>? vertexBuffers,');
  lines.add('}) {');
  lines.add('  final _module = module ?? createShaderModule(device);');
  lines.add('  return device.createRenderPipeline(.new(');
  lines.add('   label: ${_wgpuLabel('${vertexFunc.name}-${fragmentFunc.name} render pipeline')},');
  lines.add('   layout: layout ?? $createPipelineLayoutFn(device),');
  lines.add('   vertex: ${vertexFunc.createStateFn}(_module, overrides: overrides, vertexBuffers: vertexBuffers),');
  lines.add('   fragment: ${fragmentFunc.createStateFn}(_module, targets, overrides: overrides),');
  lines.add('   primitive: primitive,');
  lines.add('   multisample: multisample,');
  lines.add('   depthStencil: depthStencil,');
  lines.add(' ));');
  lines.add('}');

  return lines;
}
