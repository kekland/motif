part of '../generator.dart';

const _staticViewWriteToQueueFn = [
  'void writeToQueue(wgpu.Queue queue, wgpu.Buffer buffer, {int offset = 0}) => queue.writeBuffer(buffer, offset, data);',
];

const _dynamicViewWriteToQueueFn = [
  'void writeToQueue(wgpu.Queue queue, wgpu.Buffer buffer, {int? count}) {',
  '  final length = count != null ? count * strideInBytes : data.lengthInBytes;',
  '  queue.writeBuffer(buffer, 0, ByteData.sublistView(data, 0, length));',
  '}',
];

const _viewClearFn =
    'void clear() => data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes).fillRange(0, data.lengthInBytes, 0);';

List<String> _readbackHelper() => [
  'TypedDataList<int> _readbackSync(wgpu.Device device, wgpu.Buffer buffer, int sizeInBytes) {',
  '  final staging = device.createBuffer(.new(size: sizeInBytes, usage: .of([.copyDst, .mapRead])));',
  '',
  '  final encoder = device.createCommandEncoder();',
  '  encoder.copyBufferToBuffer(buffer, 0, staging, 0, sizeInBytes);',
  '  final commands = encoder.finish();',
  '  device.queue.submit([commands]);',
  '',
  '  staging.mapSync(offset: 0, size: sizeInBytes, mode: .read);',
  '  final result = staging.getMappedRange(0, sizeInBytes, readOnly: true);',
  '  staging.unmap();',
  '  staging.destroy();',
  '  return result;',
  '}',
];

List<String> _descriptorFn({String? length, required String usage, required String name, String? customSize}) => [
  'static wgpu.BufferDescriptor descriptor({',
  if (length != null) '  required int $length,',
  '  String? label,',
  '  wgpu.BufferUsage? usage,',
  '  bool mappedAtCreation = false,',
  '}) => .new(',
  '  label: label ?? ${_wgpuLabel('$name buffer')},',
  if (customSize != null)
    '  size: $customSize,'
  else if (length != null)
    '  size: $length * strideInBytes,'
  else
    '  size: sizeInBytes,',
  '  usage: usage ?? $usage,',
  '  mappedAtCreation: mappedAtCreation,',
  ');',
];

List<String> _createBufferFn({String? length}) => [
  'static wgpu.Buffer createBuffer(',
  '  wgpu.Device device, {',
  if (length != null) '  required int $length,',
  '  String? label,',
  '  wgpu.BufferUsage? usage,',
  '  bool mappedAtCreation = false,',
  '}) {',
  '  return device.createBuffer(descriptor(',
  if (length != null) '    $length: $length,',
  '    label: label,',
  '    usage: usage,',
  '    mappedAtCreation: mappedAtCreation,',
  '  ));',
  '}',
];

List<String> _bufferReadbackFn(String returnType) => [
  '$returnType readSync(wgpu.Device device) {',
  '  final mapped = _readbackSync(device, buffer, sizeInBytes);',
  '  _view.data.buffer.asUint8List(_view.data.offsetInBytes, _view.data.lengthInBytes).setAll(0, mapped);',
  '  return _view.read();',
  '}',
];

// Static-sized buffers

List<String> _generateStaticBufferView(
  VariableInfo info, {
  required String viewName,
  required String usage,
}) {
  final lines = <String>[];

  lines.add('extension type $viewName(ByteData data) {');
  lines.add('  $viewName.create(): this(.new(sizeInBytes));');
  lines.add('');
  lines.addAll(_staticViewWriteToQueueFn.indent());
  lines.add(_viewClearFn.indent());
  lines.add('');
  lines.add('  static const int sizeInBytes = ${info.size};');

  if (info.isArray) {
    final array = info.type.asArray;
    lines.add('  static const int strideInBytes = ${array.stride};');
    lines.add('  static const int length = ${array.count};');
  }

  lines.add('');
  lines.addAll(_descriptorFn(name: info.type.typeName, usage: usage).indent());
  lines.add('');
  lines.addAll(_createBufferFn().indent());
  lines.add('');
  lines.add('  $_preferInline');
  lines.add('  void write(${info.type.dartName} value) {');
  lines.addAll(info.type.writeFn('value', offset: '0').indent(2));
  lines.add('  }');
  lines.add('');
  lines.add('  $_preferInline');
  lines.add('  ${info.type.dartName} read() {');
  lines.addAll(info.type.readFn(offset: '0', returns: true).indent(2));
  lines.add('  }');
  lines.add('');

  if (info.isStruct) {
    final struct = info.type.asStruct;
    for (final m in struct.visibleMembers) {
      lines.add('  $_preferInline');
      lines.add('  ${m.type.dartType} get ${m.dartName} {');
      lines.addAll(m.type.readFn(offset: '${m.offset}', returns: true).indent(2));
      lines.add('  }');
      lines.add('');
      lines.add('  $_preferInline');
      lines.add('  set ${m.dartName}(${m.type.dartType} value) {');
      lines.addAll(m.type.writeFn('value', offset: '${m.offset}').indent(2));
      lines.add('  }');
      lines.add('');
    }
    lines.add('  $_preferInline');
    lines.add('  void set({${struct.visibleMembers.dartNamedCtorArgs}}) {');
    for (final m in struct.visibleMembers) {
      lines.add('    this.${m.dartName} = ${m.dartName};');
    }
    lines.add('  }');
    lines.add('');
  } else if (info.isArray) {
    final array = info.type.asArray;
    lines.add('  $_preferInline');
    lines.add('  ${array.format.dartName} operator [](int index) {');
    lines.addAll(array.format.readFn(offset: 'index * strideInBytes', returns: true).indent(2));
    lines.add('  }');
    lines.add('');
    lines.add('  $_preferInline');
    lines.add('  void operator []=(int index, ${array.format.dartName} value) {');
    lines.addAll(array.format.writeFn('value', offset: 'index * strideInBytes').indent(2));
    lines.add('  }');
    lines.add('');
  }

  lines.add('}');
  return lines;
}

List<String> _generateStaticBuffer(
  VariableInfo info, {
  required String viewName,
  required String bufferName,
  required String bufferBase,
}) {
  final lines = <String>[];

  lines.add('class $bufferName extends $bufferBase {');
  lines.add('  $bufferName(wgpu.Device device, {String? label, wgpu.BufferUsage? usage}):');
  lines.add('    _view = $viewName.create(),');
  lines.add('    super($viewName.createBuffer(device, label: label, usage: usage));');
  lines.add('');
  lines.add('  static const int sizeInBytes = ${info.size};');
  if (info.isArray) {
    final array = info.type.asArray;
    lines.add('  static const int strideInBytes = ${array.stride};');
    lines.add('  static const int length = ${array.count};');
  }
  lines.add('');
  lines.add('  final $viewName _view;');
  lines.add('  $viewName get view => _view;');
  lines.add('');
  lines.add('  @override');
  lines.add('  void writeToQueue(wgpu.Queue queue) => _view.writeToQueue(queue, buffer);');
  lines.add('');
  lines.addAll(_bufferReadbackFn(info.type.dartName).indent());
  lines.add('');
  lines.add('  $_preferInline');
  lines.add('  void write(${info.type.dartName} value) => _view.write(value);');
  lines.add('');
  lines.add('  $_preferInline');
  lines.add('  void clear([wgpu.Queue? queue]) {');
  lines.add('    _view.clear();');
  lines.add('    if (queue != null) writeToQueue(queue);');
  lines.add('  }');
  lines.add('');

  if (info.isStruct) {
    final struct = info.type.asStruct;
    for (final m in struct.visibleMembers) {
      lines.add('  $_preferInline');
      lines.add('  set ${m.dartName}(${m.type.dartType} value) => _view.${m.dartName} = value;');
      lines.add('');
      lines.add('  $_preferInline');
      lines.add('  wgpu.BufferView get ${m.dartName}BufferView => wgpu.BufferView(buffer, offset: ${m.offset}, size: ${m.type.size});');
      lines.add('');
    }

    final visibleMembers = struct.visibleMembers;
    lines.add('  $_preferInline');
    lines.add('  void set({${visibleMembers.dartNamedCtorArgs}}) => _view.set(${visibleMembers.namePassthroughArgs});');
    lines.add('');
  } else if (info.isArray) {
    final array = info.type.asArray;
    lines.add('  $_preferInline');
    lines.add('  void operator []=(int index, ${array.format.dartName} value) => _view[index] = value;');
    lines.add('');
  }

  lines.add('}');
  return lines;
}

// Dynamic-sized buffers (storage buffer with array format or vertex I/O struct)
List<String> _generateDynamicBufferView(
  VariableInfo info, {
  required String viewName,
  required String usage,
  String length = 'length',
}) {
  final lines = <String>[];

  late final String createLength;
  late final String strideInBytes;
  late final String arrayLength;

  if (info.isArray) {
    createLength = '$length * strideInBytes';
    strideInBytes = 'strideInBytes = ${info.stride}';
    arrayLength = 'sizeInBytes ~/ strideInBytes';
  } else if (info.isStruct) {
    final array = info.type.asStruct.members.last;
    createLength = '${array.offset} + $length * ${array.type.asArray.stride}';

    final _length = length.split('Length')[0];
    final _array = array.type.asArray;
    strideInBytes = '${_length}StrideInBytes = ${_array.stride}';
    arrayLength = '(sizeInBytes - ${array.offset}) ~/ ${_array.stride}';
  }

  lines.add('extension type $viewName(ByteData data) {');
  lines.add('  $viewName.create(int $length): this(.new($createLength));');
  lines.add('');
  lines.addAll(_dynamicViewWriteToQueueFn.indent());
  lines.add(_viewClearFn.indent());
  lines.add('');
  lines.add('  static const int $strideInBytes;');
  lines.add('  int get sizeInBytes => data.lengthInBytes;');
  lines.add('  int get $length => $arrayLength;');
  lines.add('');
  lines.addAll(
    _descriptorFn(name: info.type.typeName, usage: usage, length: length, customSize: createLength).indent(),
  );
  lines.add('');
  lines.addAll(_createBufferFn(length: length).indent());
  lines.add('');
  lines.add('  $_preferInline');
  lines.add('  void write(${info.type.dartName} value) {');
  lines.addAll(info.type.writeFn('value', offset: '0').indent(2));
  lines.add('  }');
  lines.add('');
  lines.add('  $_preferInline');
  lines.add('  ${info.type.dartName} read() {');
  lines.addAll(info.type.readFn(offset: '0', length: length, returns: true).indent(2));
  lines.add('  }');
  lines.add('');

  // Array-specific accessors
  if (info.isArray) {
    final array = info.type.asArray;
    lines.add('  $_preferInline');
    lines.add('  void operator []=(int index, ${array.format.dartName} value) {');
    lines.addAll(array.format.writeFn('value', offset: 'index * strideInBytes').indent(2));
    lines.add('  }');
    lines.add('');
    lines.add('  $_preferInline');
    lines.add('  ${array.format.dartName} operator [](int index) {');
    lines.addAll(array.format.readFn(offset: 'index * strideInBytes', length: length, returns: true).indent(2));
    lines.add('  }');
    lines.add('');

    if (array.format.isStruct) {
      final struct = array.format.asStruct;
      final callArgs = struct.visibleMembers.dartNamedCtorArgs;

      lines.add('  $_preferInline');
      lines.add('  void set(int index, {$callArgs}) {');

      for (final m in struct.visibleMembers) {
        final offset = 'index * strideInBytes + ${m.offset}';
        lines.addAll(m.type.writeFn(m.dartName, offset: offset).indent(2));
      }

      lines.add('  }');
    }
  }

  // Struct-specific accessors
  // Here, this means that the last element of the struct is an array.
  if (info.isStruct) {
    final struct = info.type.asStruct;
    for (final m in struct.visibleMembers) {
      if (m.isArray) continue;

      lines.add('  $_preferInline');
      lines.add('  ${m.type.dartType} get ${m.dartName} {');
      lines.addAll(m.type.readFn(offset: '${m.offset}', returns: true).indent(2));
      lines.add('  }');
      lines.add('');
      lines.add('  $_preferInline');
      lines.add('  set ${m.dartName}(${m.type.dartType} value) {');
      lines.addAll(m.type.writeFn('value', offset: '${m.offset}').indent(2));
      lines.add('  }');
      lines.add('');
    }

    final arrayMember = struct.members.last;
    final array = arrayMember.type.asArray;
    lines.add('  $_preferInline');
    lines.add('  void operator []=(int index, ${array.format.dartName} value) {');
    lines.addAll(array.format.writeFn('value', offset: '${arrayMember.offset} + index * ${array.stride}').indent(2));
    lines.add('  }');
    lines.add('');

    if (array.format.isStruct) {
      final struct = array.format.asStruct;
      final callArgs = struct.members.dartNamedCtorArgs;

      lines.add('');
      lines.add('  $_preferInline');
      lines.add('  void set(int index, {$callArgs}) {');
      for (final m in struct.members) {
        final offset = '${arrayMember.offset} + index * ${array.stride} + ${m.offset}';
        lines.addAll(m.type.writeFn(m.dartName, offset: offset).indent(2));
      }
      lines.add('  }');
    }
  }

  lines.add('}');
  return lines;
}

List<String> _generateDynamicBuffer(
  VariableInfo info, {
  required String viewName,
  required String bufferName,
  required String bufferBase,
  String length = 'length',
}) {
  final lines = <String>[];

  late final String strideInBytes;

  if (info.isArray) {
    strideInBytes = 'strideInBytes = ${info.stride}';
  } else if (info.isStruct) {
    final array = info.type.asStruct.members.last;
    final _length = length.split('Length')[0];
    final _array = array.type.asArray;
    strideInBytes = '${_length}StrideInBytes = ${_array.stride}';
  }

  lines.add('class $bufferName extends $bufferBase {');
  lines.add('  $bufferName(wgpu.Device device, {required int $length, String? label, wgpu.BufferUsage? usage}):');
  lines.add('    _view = $viewName.create($length),');
  lines.add('    super($length, $viewName.createBuffer(device, $length: $length, label: label, usage: usage));');
  lines.add('');
  if (info.isStruct) {
    lines.add('  int get $length => length;');
  }
  lines.add('');
  lines.add('  static const int $strideInBytes;');
  lines.add('  int get sizeInBytes => _view.sizeInBytes;');
  lines.add('');
  lines.add('  final $viewName _view;');
  lines.add('  $viewName get view => _view;');
  lines.add('');
  lines.add('  @override');
  lines.add('  void writeToQueue(wgpu.Queue queue, {int? count}) => _view.writeToQueue(queue, buffer, count: count);');
  lines.add('');
  lines.addAll(_bufferReadbackFn(info.type.dartName).indent());
  lines.add('');
  lines.add('  $_preferInline');
  lines.add('  void write(${info.type.dartName} value) => _view.write(value);');
  lines.add('');
  lines.add('  $_preferInline');
  lines.add('  void clear([wgpu.Queue? queue]) {');
  lines.add('    _view.clear();');
  lines.add('    if (queue != null) writeToQueue(queue);');
  lines.add('  }');
  lines.add('');

  // Array-specific accessors
  if (info.isArray) {
    final array = info.type.asArray;
    lines.add('  $_preferInline');
    lines.add('  void operator []=(int index, ${array.format.dartName} value) => _view[index] = value;');

    if (array.format.isStruct) {
      final struct = array.format.asStruct;
      final callArgs = struct.members.dartNamedCtorArgs;
      final tuple = struct.members.namePassthroughArgs;

      lines.add('');
      lines.add('  $_preferInline');
      lines.add('  void set(int index, {$callArgs}) => _view.set(index, $tuple);');
    }
  }

  // Struct-specific accessors
  if (info.isStruct) {
    final struct = info.type.asStruct;
    for (final m in struct.visibleMembers) {
      if (m.isArray) continue;

      lines.add('  $_preferInline');
      lines.add('  set ${m.dartName}(${m.type.dartType} value) => _view.${m.dartName} = value;');
    }

    final arrayMember = struct.members.last;
    final array = arrayMember.type.asArray;
    lines.add('');
    lines.add('  $_preferInline');
    lines.add('  void operator []=(int index, ${array.format.dartName} value) => _view[index] = value;');

    if (array.format.isStruct) {
      final struct = array.format.asStruct;
      final callArgs = struct.members.dartNamedCtorArgs;
      final tuple = struct.members.namePassthroughArgs;

      lines.add('');
      lines.add('  $_preferInline');
      lines.add('  void set(int index, {$callArgs}) => _view.set(index, $tuple);');
    }
  }

  lines.add('}');

  return lines;
}
