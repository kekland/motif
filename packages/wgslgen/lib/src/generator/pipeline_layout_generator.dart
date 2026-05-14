part of '../generator.dart';

bool _generatedEmptyPipelineLayout = false;

List<String> generatePipelineLayout(String name, List<String> funcNames, Map<int, Map<int, VariableInfo>> groups) {
  final lines = <String>[];

  int maxGroup = 0;

  final _debugFuncName = funcNames.join(' - ');
  final funcName = funcNames.join('');

  lines.add('@wgsl.PipelineLayout(\'$name ($_debugFuncName)\')');
  lines.add('wgpu.PipelineLayout create${funcName}PipelineLayout(');
  lines.add(' wgpu.Device device, {');
  for (final group in groups.keys.toList()..sort()) {
    lines.add('  wgpu.BindGroupLayout? group$group,');
    if (group > maxGroup) maxGroup = group;
  }
  lines.add('}) => device.createPipelineLayout(.new(');
  lines.add('  label: \'($_debugFuncName) $funcName pipeline layout\',');
  lines.add('  bindGroupLayouts: [');

  var needsEmptyPipelineLayout = false;
  for (var i = 0; i <= maxGroup; i++) {
    final hasGroup = groups[i] != null;
    if (hasGroup) {
      lines.add('    group$i ?? device.createBindGroupLayout(bindGroup${i}LayoutDescriptor),');
    } else {
      needsEmptyPipelineLayout = true;
      lines.add('    _emptyLayout ??= device.createBindGroupLayout(.new(label: \'empty\')),');
    }
  }
  lines.add('  ],');
  lines.add('));');

  if (needsEmptyPipelineLayout && !_generatedEmptyPipelineLayout) {
    _generatedEmptyPipelineLayout = true;
    lines.add('');
    lines.add('wgpu.BindGroupLayout? _emptyLayouts;');
  }

  return lines;
}
