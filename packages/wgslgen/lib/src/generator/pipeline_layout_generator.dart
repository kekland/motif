part of '../generator.dart';

List<String> generatePipelineLayout(String name, Map<int, Map<int, VariableInfo>> groups) {
  final lines = <String>[];

  
  lines.add('@wgsl.PipelineLayout(\'$name\')');
  lines.add('wgpu.PipelineLayout createPipelineLayout(');
  lines.add(' wgpu.Device device, {');
  for (final group in groups.keys.toList()..sort()) {
    lines.add('  wgpu.BindGroupLayout? group$group,');
  }
  lines.add('}) => device.createPipelineLayout(.new(');
  lines.add('  label: \'($name) pipeline layout\',');
  lines.add('  bindGroupLayouts: [');
  for (final group in groups.keys.toList()..sort()) {
    lines.add('    group$group ?? device.createBindGroupLayout(bindGroup${group}Layout),');
  }
  lines.add('  ],');
  lines.add('));');

  return lines;
}