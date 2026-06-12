part of '../generator.dart';

extension FunctionInfoExt on FunctionInfo {
  String get dartName => toDartMemberName(name);
  String get capDartName => toDartTopLevelName(name);

  String get createStateFn {
    if (stage == null) throw Exception('function $name does not have a shader stage');
    final suffix = switch (stage!) {
      'vertex' => 'VertexState',
      'fragment' => 'FragmentState',
      'compute' => 'ComputeState',
      _ => throw Exception('Unsupported shader stage: $stage'),
    };

    return 'create$capDartName$suffix';
  }
}

extension VertexFunctionInfoExt on FunctionInfo {
  String get vertexBufferLayoutFn => 'create${capDartName}VertexBufferLayout';

  String vertexFormatFor(MemberInfo member) {
    return _typeToVertexFormat(member.type);
  }

  String vertexLocationFor(MemberInfo member) {
    final locationInput = locationInputs.firstWhere((i) => i.name == member.name);
    return locationInput.location;
  }

  List<InputInfo> get locationInputs => inputs.where((i) => i.locationType == 'location').toList();

  List<MemberInfo>? get vertexStructMembers {
    if (locationInputs.isEmpty) return null;
    final members = <MemberInfo>[];

    var currentOffset = 0;
    for (final input in locationInputs) {
      final member = MemberInfo(name: input.name, type: input.type!, size: input.type!.size, offset: currentOffset);
      members.add(member);
      currentOffset += input.type!.size;
    }

    return members;
  }

  StructInfo? get vertexStruct {
    final members = vertexStructMembers;
    if (members == null) return null;
    return StructInfo(name: '${name}_vertex', members: members, size: members.last.offset + members.last.size);
  }

  VariableInfo? get vertexBuffer {
    final struct = vertexStruct;
    if (struct == null) return null;

    final array = ArrayInfo(name: '${name}_vertex_buffer', format: struct, stride: struct.size);
    return VariableInfo(
      name: '${name}_vertex_buffer',
      type: array,
      group: -1,
      binding: -1,
      access: 'read',
      resourceType: .storage,
    );
  }

  String get vertexBufferName => '${capDartName}VertexBuffer';
  String get vertexBufferViewName => '${vertexBufferName}View';
  String get vertexBufferBase => 'wgsl.VertexBuffer<${vertexStruct!.internalName}>';
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
