part of '../generator.dart';

List<String> generateFragmentState(FunctionInfo funcInfo) {
  final lines = <String>[];

  final funcName = funcInfo.dartName;
  final capFuncName = funcName[0].toUpperCase() + funcName.substring(1);

  lines.add('@wgsl.FragmentState(\'${funcInfo.name}\')');
  lines.add('wgpu.FragmentState create${capFuncName}FragmentState(');
  lines.add('  wgpu.ShaderModule module,');
  lines.add('  List<wgpu.ColorTargetState> targets, {');
  lines.add('  Overrides? overrides,');
  lines.add('}) => wgpu.FragmentState(');
  lines.add('  module: module,');
  lines.add('  entryPoint: \'${funcInfo.name}\',');
  lines.add('  constants: overrides?.entries ?? const [],');
  lines.add('  targets: targets,');
  lines.add(');');

  return lines;
}
