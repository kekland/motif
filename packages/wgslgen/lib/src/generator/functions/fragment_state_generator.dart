part of '../../generator.dart';

List<String> generateFragmentState(FunctionInfo funcInfo) {
  final lines = <String>[];

  lines.add(_metaFragmentState(funcInfo.name));
  lines.add('wgpu.FragmentState ${funcInfo.createStateFn}(');
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
