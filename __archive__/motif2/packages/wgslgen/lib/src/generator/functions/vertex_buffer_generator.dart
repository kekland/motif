part of '../../generator.dart';

List<String>? generateVertexBuffer(FunctionInfo info) {
  final lines = <String>[];
  final vertexBuffer = info.vertexBuffer;
  if (vertexBuffer == null) return null;

  final struct = info.vertexStruct!;
  final array = vertexBuffer.type.asArray;

  lines.addAll(generateArray(array));
  lines.add('');
  lines.addAll(generateStruct(struct));
  lines.add('');

  final viewName = info.vertexBufferViewName;
  final bufferName = info.vertexBufferName;
  final bufferBase = info.vertexBufferBase;

  lines.add(_metaVertexBufferView(info.name));
  lines.addAll(_generateDynamicBufferView(vertexBuffer, viewName: viewName, usage: '.copyDst', length: 'vertexCount'));
  lines.add('');
  lines.add(_metaVertexBuffer(info.name));
  lines.addAll(
    _generateDynamicBuffer(
      vertexBuffer,
      viewName: viewName,
      bufferName: bufferName,
      bufferBase: bufferBase,
      length: 'vertexCount',
    ),
  );

  return lines;
}
