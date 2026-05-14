part of '../generator.dart';

List<String> generateComputePipeline(String name, FunctionInfo funcInfo, Map<int, Map<int, VariableInfo>> groups) {
  final lines = <String>[];

  final funcName = funcInfo.dartName;
  final capFuncName = funcName[0].toUpperCase() + funcName.substring(1);

  final _groups = <int, Map<int, VariableInfo>>{};
  for (final resource in funcInfo.resources) {
    _groups[resource.group] ??= {};
    _groups[resource.group]![resource.binding] = groups[resource.group]![resource.binding]!;
  }

  lines.addAll(generatePipelineLayout(name, [capFuncName], _groups));
  lines.add('');

  final createPipelineLayoutFn = 'create${capFuncName}PipelineLayout';

  lines.add('@wgsl.ComputePipeline(\'${funcInfo.name}\')');
  lines.add('wgpu.ComputePipeline create${capFuncName}Pipeline(');
  lines.add('  wgpu.Device device,');
  lines.add('  wgpu.ShaderModule module, {');
  lines.add('  wgpu.PipelineLayout? layout,');
  lines.add('  Overrides? overrides,');
  lines.add('}) => device.createComputePipeline(.new(');
  lines.add('  label: \'($name) ${funcInfo.name} compute pipeline\',');
  lines.add('  layout: layout ?? $createPipelineLayoutFn(device),');
  lines.add('  compute: create${capFuncName}ComputeState(module, overrides: overrides),');
  lines.add('));');

  return lines;
}
