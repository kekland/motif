part of '../../generator.dart';

bool _generatedEmptyBindGroupLayout = false;

List<String> generatePipelineLayout(List<String> funcNames, Map<int, Map<int, VariableInfo>> groups) {
  final lines = <String>[];

  int maxGroup = 0;

  final _debugFuncName = funcNames.join(' - ');
  final funcName = funcNames.join('');

  if (groups.isEmpty) {
    lines.add(_metaPipelineLayout(_debugFuncName));
    lines.add('wgpu.PipelineLayout create${funcName}PipelineLayout(wgpu.Device device) => device.createPipelineLayout(.new(');
    lines.add('  label: ${_wgpuLabel('$_debugFuncName pipeline layout')},');
    lines.add('));');
    return lines;
  }

  lines.add(_metaPipelineLayout(_debugFuncName));
  lines.add('wgpu.PipelineLayout create${funcName}PipelineLayout(');
  lines.add(' wgpu.Device device, {');
  for (final group in groups.keys.toList()..sort()) {
    lines.add('  wgpu.BindGroupLayout? group$group,');
    if (group > maxGroup) maxGroup = group;
  }
  lines.add('}) => device.createPipelineLayout(.new(');
  lines.add('  label: ${_wgpuLabel('$_debugFuncName pipeline layout')},');
  lines.add('  bindGroupLayouts: [');

  var needsEmptyBindGroupLayout = false;
  for (var i = 0; i <= maxGroup; i++) {
    final hasGroup = groups[i] != null;
    if (hasGroup) {
      lines.add('    group$i ?? device.createBindGroupLayout(bindGroup${i}LayoutDescriptor),');
    } else {
      needsEmptyBindGroupLayout = true;
      lines.add('    _emptyLayout ??= device.createBindGroupLayout(.new(label: \'empty\')),');
    }
  }

  lines.add('  ],');
  lines.add('));');

  if (needsEmptyBindGroupLayout && !_generatedEmptyBindGroupLayout) {
    _generatedEmptyBindGroupLayout = true;
    lines.add('');
    lines.add('wgpu.BindGroupLayout? _emptyLayout;');
  }

  return lines;
}
