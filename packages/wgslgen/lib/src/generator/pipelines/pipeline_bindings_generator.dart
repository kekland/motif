part of '../../generator.dart';

List<String> generatePipelineBindings(
  List<String> funcNames,
  Map<int, Map<int, VariableInfo>> groups,
  bool isOnlyPipeline, {
  required String passType,
}) {
  final lines = <String>[];

  final funcName = funcNames.join('');
  final bindName = isOnlyPipeline ? 'bindPipeline' : 'bind${funcName}Pipeline';

  if (groups.isEmpty) {
    lines.add('void $bindName(wgpu.${passType}Encoder pass) {}');
    return lines;
  }

  lines.add('void $bindName(');
  lines.add('  wgpu.${passType}Encoder pass, {');
  for (final groupId in groups.keys) {
    lines.add('  required wgpu.BindGroup group$groupId,');
  }
  lines.add('}) {');
  for (final groupId in groups.keys) {
    lines.add('  pass.setBindGroup($groupId, group$groupId);');
  }
  lines.add('}');

  return lines;
}
