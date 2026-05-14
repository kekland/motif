part of '../generator.dart';

List<String> _dynamicSizeBufferHelpers(
  String name,
  String infoName, {
  String length = 'length',
  String usage = '.of([.storage, .copyDst])',
}) => [
  'static wgpu.BufferDescriptor descriptor(',
  '  int $length, {',
  '  String? label,',
  '  wgpu.BufferUsage? usage,',
  '  bool mappedAtCreation = false,',
  '}) => .new(',
  '  label: label ?? \'($name) ${infoName.toLowerCase()} buffer\',',
  '  size: $length * stride,',
  '  usage: usage ?? $usage,',
  '  mappedAtCreation: mappedAtCreation,',
  ');',
  '',
  'static wgpu.Buffer createBuffer(',
  '  wgpu.Device device,',
  '  int $length, {',
  '  String? label,',
  '  wgpu.BufferUsage? usage,',
  '  bool mappedAtCreation = false,',
  '}) => device.createBuffer(descriptor($length, label: label, usage: usage, mappedAtCreation: mappedAtCreation));',
];

List<String> _dynamicSizeBufferClass(
  String name,
  String infoName,
  List<(String, String)> fns, {
  String length = 'length',
}) => [
  'class ${infoName}Buffer {',
  '  ${infoName}Buffer(wgpu.Device device, this.$length, {String? label, wgpu.BufferUsage? usage}):',
  '    buffer = $name.createBuffer(device, $length, label: label, usage: usage),',
  '    _view = $name(ByteData($length * $name.stride));',
  '',
  '  final int $length;',
  '  final wgpu.Buffer buffer;',
  '  final $name _view;',
  '',
  '  static const int stride = $name.stride;',
  '  int get sizeInBytes => $length * stride;',
  '',
  '  wgpu.BufferView get bufferView => .new(buffer);',
  '  void writeToQueue(wgpu.Queue queue) => _view.writeToQueue(queue, buffer);',
  '',
  ..._generateBufferReadback().indent(),
  '',
  for (final (signature, body) in fns) '  $signature => _$body;',
  '}',
];

List<String> generateStorage(List<String> _names, VariableInfo info) {
  final lines = <String>[];
  final type = info.type;

  final name = info.type.dartName;

  lines.add('@wgsl.StorageBufferView([\'${_names.join(', ')}\'])');
  lines.add('extension type ${name}BufferView(ByteData data) {');
  lines.add('  void writeToQueue(wgpu.Queue queue, wgpu.Buffer buffer, {int offset = 0}) {');
  lines.add('    queue.writeBuffer(buffer, offset, data);');
  lines.add('  }');
  lines.add('');

  final bufferFns = <(String, String)>[];

  if (type.isArray) {
    final type = info.type.asArray;
    final format = type.format;
    final dartType = wgslTypeToDart(format);

    lines.add('  static const int stride = ${info.stride};');
    lines.add('  int get length => data.lengthInBytes ~/ stride;');
    lines.add('');
    lines.add('  ${name}BufferView.create(int length): this(ByteData(length * stride));');
    lines.add('');
    lines.addAll(_dynamicSizeBufferHelpers(_names.join(', '), info.dartName).indent());
    lines.add('');

    bufferFns.add(('void operator []=(int index, $dartType value)', 'view[index] = value'));
    lines.add('  void operator []=(int index, $dartType value) {');
    lines.addAll(format.write('value', offset: 'index * stride').indent(2));
    lines.add('  }');
    lines.add('');

    bufferFns.add(('$dartType operator [](int index)', 'view[index]'));
    lines.add('  $dartType operator [](int index) {');
    lines.addAll(format.read(offset: 'index * stride', ret: true).indent(2));
    lines.add('  }');
  } else {
    lines.add('  static const int sizeInBytes = ${type.size};');
    lines.add('');
    lines.add('  ${name}BufferView.create(): this(ByteData(sizeInBytes));');
    lines.add('');
    lines.addAll(
      _staticSizeBufferHelpers(_names.join(', '), info.dartName, usage: '.of([.storage, .copyDst])').indent(),
    );
    lines.add('');

    bufferFns.add(('void write(${type.dartType} value)', 'view.write(value)'));
    lines.add('  void write(${type.dartType} value) {');
    lines.addAll(type.write('value', offset: '0').indent(2));
    lines.add('  }');
    lines.add('');

    bufferFns.add(('${type.dartType} read()', 'view.read()'));
    lines.add('  ${type.dartType} read() {');
    lines.addAll(type.read(offset: '0', ret: true).indent(2));
    lines.add('  }');
  }
  lines.add('');

  bufferFns.add(('void clear()', 'view.clear()'));
  lines.add('  void clear() {');
  lines.add('    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes).fillRange(0, data.lengthInBytes, 0);');
  lines.add('  }');
  lines.add('}');
  lines.add('');

  lines.add('@wgsl.StorageBuffer([\'${_names.join(', ')}\'])');
  if (type.isArray) {
    lines.addAll(_dynamicSizeBufferClass('${name}BufferView', info.type.dartName, bufferFns));
  } else {
    lines.addAll(_staticSizeBufferClass('${name}BufferView', info.type.dartName, bufferFns));
  }

  return lines;
}
