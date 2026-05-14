part of '../generator.dart';

List<String> _generateBufferReadback() => [
  'void readBack(wgpu.Device device) {',
  '  final staging = device.createBuffer(.new(size: sizeInBytes, usage: .of([.copyDst, .mapRead])));',
  '',
  '  final encoder = device.createCommandEncoder();',
  '  encoder.copyBufferToBuffer(buffer, 0, staging, 0, sizeInBytes);',
  '  final commands = encoder.finish();',
  '  device.queue.submit([commands]);',
  '',
  '  staging.mapSync(offset: 0, size: sizeInBytes, mode: .read);',
  '  final mapped = staging.getMappedRange(0, sizeInBytes, readOnly: true);',
  '  _view.data.buffer.asUint8List(_view.data.offsetInBytes, _view.data.lengthInBytes).setAll(0, mapped);',
  '  staging.unmap();',
  '  staging.destroy();',
  '}',
];

List<String> _staticSizeBufferHelpers(String name, String infoName, {required String usage}) => [
  'static wgpu.BufferDescriptor descriptor({',
  '  String? label,',
  '  wgpu.BufferUsage? usage,',
  '  bool mappedAtCreation = false,',
  '}) => .new(',
  '  label: label ?? \'($name) ${infoName.toLowerCase()} buffer\',',
  '  size: sizeInBytes,',
  '  usage: usage ?? $usage,',
  '  mappedAtCreation: mappedAtCreation,',
  ');',
  '',
  'static wgpu.Buffer createBuffer(wgpu.Device device, {',
  '  String? label,',
  '  wgpu.BufferUsage? usage,',
  '  bool mappedAtCreation = false,',
  '}) => device.createBuffer(descriptor(label: label, usage: usage, mappedAtCreation: mappedAtCreation));',
];

List<String> _staticSizeBufferClass(String name, String infoName, List<(String, String)> fns) => [
  'class ${infoName}Buffer {',
  '  ${infoName}Buffer(wgpu.Device device, {String? label, wgpu.BufferUsage? usage}):',
  '    buffer = $name.createBuffer(device, label: label, usage: usage),',
  '    _view = $name(ByteData($name.sizeInBytes));',
  '',
  '  final wgpu.Buffer buffer;',
  '  final $name _view;',
  '',
  '  static const int sizeInBytes = $name.sizeInBytes;',
  '',
  '  wgpu.BufferView get bufferView => .new(buffer);',
  '  void writeToQueue(wgpu.Queue queue) => _view.writeToQueue(queue, buffer);',
  '',
  ..._generateBufferReadback().indent(),
  '',
  for (final (signature, body) in fns) '  $signature => _$body;',
  '}',
];

List<String> generateUniform(String _name, VariableInfo info) {
  final lines = <String>[];

  final name = '${info.type.dartName}BufferView';

  lines.add('@wgsl.UniformBufferView(\'${info.name}\')');
  lines.add('extension type $name(ByteData data) {');
  lines.add('  static const int sizeInBytes = ${info.size};');

  if (info.isArray) {
    final array = info.type.asArray;
    lines.add('  static const int strideInBytes = ${array.stride};');
    lines.add('  static const int length = ${array.count};');
  }

  lines.add('');
  lines.add('  $name.create(): this(ByteData(sizeInBytes));');
  lines.add('');
  lines.add('  void writeToQueue(wgpu.Queue queue, wgpu.Buffer buffer, {int offset = 0}) {');
  lines.add('    queue.writeBuffer(buffer, offset, data);');
  lines.add('  }');
  lines.add('');
  lines.addAll(_staticSizeBufferHelpers(_name, info.type.dartName, usage: '.of([.uniform, .copyDst])').indent());
  lines.add('');

  lines.add('  void write(${info.type.dartType} value) {');
  lines.addAll(info.type.write('value', offset: '0').indent(2));
  lines.add('  }');
  lines.add('');
  lines.add('  ${info.type.dartType} read() {');
  lines.addAll(info.type.read(offset: '0', ret: true).indent(2));
  lines.add('  }');
  lines.add('');

  final List<(String, String)> bufferFns = [];

  if (info.isStruct) {
    final struct = info.type.asStruct;
    final visibleMembers = struct.visibleMembers;

    for (final member in visibleMembers) {
      final type = member.type;

      // Getter
      bufferFns.add(('${type.dartType} get ${member.dartName}', 'view.${member.dartName}'));

      lines.add('  ${type.dartType} get ${member.dartName} {');
      lines.addAll(type.read(offset: '${member.offset}', ret: true).indent(2));
      lines.add('  }');
      lines.add('');

      // Setter
      bufferFns.add(('set ${member.dartName}(${type.dartType} value)', 'view.${member.dartName} = value'));

      lines.add('  set ${member.dartName}(${type.dartType} value) {');
      lines.addAll(type.write('value', offset: '${member.offset}').indent(2));
      lines.add('  }');
      lines.add('');
    }
  } else if (info.isArray) {
    final array = info.type.asArray;

    bufferFns.add(('void operator []=(int index, ${array.format.dartType} value)', 'view[index] = value'));
    lines.add('  void operator []=(int index, ${array.format.dartType} value) {');
    lines.addAll(array.format.write('value', offset: 'index * ${array.stride}').indent(2));
    lines.add('  }');
    lines.add('');

    bufferFns.add(('${array.format.dartType} operator [](int index)', 'view[index]'));
    lines.add('  ${array.format.dartType} operator [](int index) {');
    lines.addAll(array.format.read(offset: 'index * ${array.stride}', ret: true).indent(2));
    lines.add('  }');
  }

  lines.add('');
  bufferFns.add(('void clear()', 'view.clear()'));
  lines.add('  void clear() {');
  lines.add('    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes).fillRange(0, data.lengthInBytes, 0);');
  lines.add('  }');
  lines.add('}');
  lines.add('');
  lines.add('@wgsl.UniformBuffer(\'${info.name}\')');
  lines.addAll(_staticSizeBufferClass(name, info.type.dartName, bufferFns));

  return lines;
}
