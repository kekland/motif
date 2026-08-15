part of '../../generator.dart';

List<String>? generateVertexBufferLayout(FunctionInfo info) {
  final buffer = info.vertexBuffer;
  if (buffer == null) return null;

  final lines = <String>[];

  final attributes = buffer.type.asArray.format.asStruct.members;
  final args = 'wgpu.VertexStepMode stepMode = .vertex';

  lines.add(_metaVertexBufferLayout(info.name));
  lines.add('wgpu.VertexBufferLayout ${info.vertexBufferLayoutFn}({$args}) => .new(');
  lines.add('  arrayStride: ${buffer.stride},');
  lines.add('  stepMode: stepMode,');
  lines.add('  attributes: [');
  for (final attribute in attributes) {
    final format = info.vertexFormatFor(attribute);
    final location = info.vertexLocationFor(attribute);
    lines.add('    .new(offset: ${attribute.offset}, shaderLocation: $location, format: .$format),');
  }

  lines.add('  ],');
  lines.add(');');

  return lines;
}
