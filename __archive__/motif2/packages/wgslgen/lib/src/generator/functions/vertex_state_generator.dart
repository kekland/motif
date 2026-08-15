part of '../../generator.dart';

List<String> generateVertexState(FunctionInfo funcInfo) {
  final lines = <String>[];
  final vertexBufferLayoutFn = funcInfo.vertexBuffer != null ? funcInfo.vertexBufferLayoutFn : null;

  lines.add(_metaVertexState(funcInfo.name));
  lines.add('wgpu.VertexState ${funcInfo.createStateFn}(');
  lines.add('  wgpu.ShaderModule module, {');
  lines.add('  Overrides? overrides,');
  lines.add('  List<wgpu.VertexBufferLayout>? vertexBuffers,');
  lines.add('}) => wgpu.VertexState(');
  lines.add('  module: module,');
  lines.add('  entryPoint: \'${funcInfo.name}\',');
  lines.add('  constants: overrides?.entries ?? const [],');
  if (vertexBufferLayoutFn != null) {
    lines.add('  buffers: vertexBuffers ?? [$vertexBufferLayoutFn()],');
  } else {
    lines.add('  buffers: vertexBuffers ?? const [],');
  }
  lines.add(');');

  return lines;
}
