part of '../generator.dart';

List<String> generateVertexState(FunctionInfo funcInfo) {
  final lines = <String>[];

  final funcName = funcInfo.dartName;
  final capFuncName = funcName[0].toUpperCase() + funcName.substring(1);

  String? vertexBufferFunc = 'create${capFuncName}VertexBufferLayout';

  final locationInputs = funcInfo.inputs.where((i) => i.locationType == 'location').toList();
  if (locationInputs.isEmpty) vertexBufferFunc = null;

  lines.add('@wgsl.VertexState(\'${funcInfo.name}\')');
  lines.add('wgpu.VertexState create${capFuncName}VertexState(');
  lines.add('  wgpu.ShaderModule module, {');
  lines.add('  Overrides? overrides,');
  lines.add('  List<wgpu.VertexBufferLayout>? vertexBuffers,');
  lines.add('}) => wgpu.VertexState(');
  lines.add('  module: module,');
  lines.add('  entryPoint: \'${funcInfo.name}\',');
  lines.add('  constants: overrides?.entries ?? const [],');
  if (vertexBufferFunc != null) {
    lines.add('  buffers: vertexBuffers ?? [$vertexBufferFunc()],');
  }
  else {
    lines.add('  buffers: vertexBuffers ?? const [],');
  }
  lines.add(');');

  return lines;
}
