part of '../generator.dart';

List<String>? generateVertexBufferLayout(String name, FunctionInfo vertexFunction) {
  final lines = <String>[];

  final locationInputs = vertexFunction.inputs.where((i) => i.locationType == 'location').toList();
  if (locationInputs.isEmpty) return null;

  locationInputs.sort((a, b) => int.parse(a.location).compareTo(int.parse(b.location)));

  final funcName = vertexFunction.dartName;
  final capFuncName = funcName[0].toUpperCase() + funcName.substring(1);

  final args = '{wgpu.VertexStepMode stepMode = .vertex}';

  lines.add('@wgsl.VertexBufferLayout(\'${vertexFunction.name}\')');
  lines.add('wgpu.VertexBufferLayout create${capFuncName}VertexBufferLayout($args) => .new(');

  int currentOffset = 0;
  final attributesLines = <String>[];
  final _inputOffsets = <InputInfo, int>{};

  for (final input in locationInputs) {
    final format = _typeToVertexFormat(input.type!);
    _inputOffsets[input] = currentOffset;

    attributesLines.add('.new(');
    attributesLines.add('  format: wgpu.VertexFormat.$format,');
    attributesLines.add('  offset: $currentOffset,');
    attributesLines.add('  shaderLocation: ${input.location},');
    attributesLines.add('),');

    currentOffset += input.type!.size;
  }

  lines.add('  arrayStride: $currentOffset,');
  lines.add('  stepMode: stepMode,');
  lines.add('  attributes: [');
  lines.addAll(attributesLines.indent(2));
  lines.add('  ],');
  lines.add(');');
  lines.add('');

  lines.add('@wgsl.VertexBufferView(\'${vertexFunction.name}\')');
  lines.add('extension type ${capFuncName}VertexView(ByteData data) {');
  lines.add('  static const stride = $currentOffset;');
  lines.add('  int get vertexCount => data.lengthInBytes ~/ stride;');
  lines.add('');
  lines.add('  ${capFuncName}VertexView.create(int vertexCount): this(ByteData(vertexCount * stride));');
  lines.add('');
  lines.add('  void writeToQueue(wgpu.Queue queue, wgpu.Buffer buffer, {int offset = 0}) {');
  lines.add('    queue.writeBuffer(buffer, offset, data);');
  lines.add('  }');
  lines.add('');
  lines.addAll(
    _dynamicSizeBufferHelpers(
      name,
      vertexFunction.name,
      length: 'vertexCount',
      usage: '.copyDst',
    ).indent(),
  );
  lines.add('');

  var setSignature = 'void set(int index, {';
  var setCall = 'view.set(index, ';
  for (final input in locationInputs) {
    setSignature += 'required ${input.type!.dartType} ${input.dartName}, ';
    setCall += '${input.dartName}: ${input.dartName}, ';
  }
  setSignature = setSignature.substring(0, setSignature.length - 2);
  setSignature += '})';
  setCall = setCall.substring(0, setCall.length - 2);
  setCall += ')';

  lines.add('  $setSignature {');
  for (final input in locationInputs) {
    final offset = _inputOffsets[input]!;
    lines.addAll(input.type!.write(input.dartName, offset: 'index * stride + $offset').indent(2));
  }
  lines.add('  }');
  lines.add('}');
  lines.add('');

  lines.add('@wgsl.VertexBuffer(\'${vertexFunction.name}\')');
  lines.addAll(
    _dynamicSizeBufferClass(
      '${capFuncName}VertexView',
      '${capFuncName}Vertex',
      [(setSignature, setCall)],
      length: 'vertexCount',
    ),
  );

  return lines;
}

String _typeToVertexFormat(TypeInfo type) {
  final name = type.typeName;

  return switch (name) {
    'f32' => 'float32',
    'vec2f' => 'float32x2',
    'vec3f' => 'float32x3',
    'vec4f' => 'float32x4',
    'u32' => 'uint32',
    'vec2u' => 'uint32x2',
    'vec3u' => 'uint32x3',
    'vec4u' => 'uint32x4',
    'i32' => 'sint32',
    'vec2i' => 'sint32x2',
    'vec3i' => 'sint32x3',
    'vec4i' => 'sint32x4',
    'f16' => 'float16',
    'vec2h' => 'float16x2',
    'vec4h' => 'float16x4',
    _ => throw Exception('Unsupported vertex input type: $name'),
  };
}
