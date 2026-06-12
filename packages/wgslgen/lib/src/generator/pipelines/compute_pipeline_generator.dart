part of '../../generator.dart';

List<String> generateComputePipeline(
  FunctionInfo funcInfo,
  Map<int, Map<int, VariableInfo>> groups,
  bool isOnlyPipeline,
) {
  final lines = <String>[];

  final _groups = <int, Map<int, VariableInfo>>{};
  for (final resource in funcInfo.resources) {
    _groups[resource.group] ??= {};
    _groups[resource.group]![resource.binding] = groups[resource.group]![resource.binding]!;
  }

  lines.addAll(generatePipelineLayout([funcInfo.capDartName], _groups));
  lines.add('');
  lines.addAll(generatePipelineBindings([funcInfo.capDartName], _groups, isOnlyPipeline, passType: 'ComputePass'));
  lines.add('');

  final createPipelineLayoutFn = 'create${funcInfo.capDartName}PipelineLayout';
  final createComputePipelineFn = isOnlyPipeline ? 'createComputePipeline' : 'create${funcInfo.capDartName}Pipeline';

  lines.add(_metaComputePipeline(funcInfo.name));
  lines.add('wgpu.ComputePipeline $createComputePipelineFn(');
  lines.add('  wgpu.Device device, {');
  lines.add('  wgpu.ShaderModule? module,');
  lines.add('  wgpu.PipelineLayout? layout,');
  lines.add('  Overrides? overrides,');
  lines.add('}) => device.createComputePipeline(.new(');
  lines.add('  label: ${_wgpuLabel('${funcInfo.name} compute pipeline')},');
  lines.add('  layout: layout ?? $createPipelineLayoutFn(device),');
  lines.add('  compute: ${funcInfo.createStateFn}(module ?? createShaderModule(device), overrides: overrides),');
  lines.add('));');

  return lines;
}
