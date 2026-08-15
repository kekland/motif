part of '../generator.dart';

List<String> generateStorage(VariableInfo info, {required List<String> variables}) {
  final lines = <String>[];

  final viewName = info.storageBufferViewName;
  final bufferName = info.storageBufferName;
  final bufferBase = info.storageBufferBase;
  final usage = '.of([.storage, .copyDst])';

  late final bool isDynamic;
  String? lengthName;
  if (info.isArray) {
    isDynamic = true;
  } else if (info.isStruct) {
    final struct = info.type.asStruct;
    isDynamic = struct.members.isNotEmpty && struct.members.last.isArray;
    if (isDynamic) lengthName = '${_toCamelCase(struct.members.last.name)}Length';
  } else {
    isDynamic = false;
  }

  if (isDynamic) {
    lines.add(_metaStorageBufferView(variables));
    lines.addAll(
      _generateDynamicBufferView(info, viewName: viewName, usage: usage, length: lengthName ?? 'length'),
    );
    lines.add('');
    lines.add(_metaStorageBuffer(variables));
    lines.addAll(
      _generateDynamicBuffer(
        info,
        viewName: viewName,
        bufferName: bufferName,
        bufferBase: bufferBase,
        length: lengthName ?? 'length',
      ),
    );
  } else {
    lines.add(_metaStorageBufferView(variables));
    lines.addAll(_generateStaticBufferView(info, viewName: viewName, usage: usage));
    lines.add('');
    lines.add(_metaStorageBuffer(variables));
    lines.addAll(_generateStaticBuffer(info, viewName: viewName, bufferName: bufferName, bufferBase: bufferBase));
  }

  return lines;
}
