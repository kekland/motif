part of '../generator.dart';

List<String> generateComputeState(FunctionInfo funcInfo) {
  final lines = <String>[];

  final funcName = funcInfo.dartName;
  final capFuncName = funcName[0].toUpperCase() + funcName.substring(1);

  lines.add('@wgsl.ComputeState(\'${funcInfo.name}\')');
  lines.add('wgpu.ComputeState create${capFuncName}ComputeState(');
  lines.add('  wgpu.ShaderModule module, {');
  lines.add('  Overrides? overrides,');
  lines.add('}) => wgpu.ComputeState(');
  lines.add('  module: module,');
  lines.add('  entryPoint: \'${funcInfo.name}\',');
  lines.add('  constants: overrides?.entries ?? const [],');
  lines.add(');');

  return lines;
}