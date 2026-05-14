// Port of https://github.com/brendan-duncan/wgsl_reflect/blob/main/src/reflect/info.ts
import 'package:equatable/equatable.dart';

import 'parser.dart';

class WgslReflectionInfo with EquatableMixin {
  const WgslReflectionInfo({
    this.entry = const EntryFunctions(),
    this.uniforms = const [],
    this.storages = const [],
    this.immediates = const [],
    this.textures = const [],
    this.samplers = const [],
    this.aliases = const [],
    this.overrides = const [],
    this.structs = const [],
    this.functions = const [],
  });

  factory WgslReflectionInfo.fromJson(Map<String, dynamic> json) {
    EquatableConfig.stringify = true;

    final parser = Parser();
    return parser.parseReflectionInfo(json);
  }

  final List<VariableInfo> uniforms;
  final List<VariableInfo> storages;
  final List<VariableInfo> immediates;
  final List<VariableInfo> textures;
  final List<VariableInfo> samplers;
  final List<AliasInfo> aliases;
  final List<OverrideInfo> overrides;
  final List<StructInfo> structs;
  final EntryFunctions entry;
  final List<FunctionInfo> functions;

  @override
  List<Object?> get props => [
    uniforms,
    storages,
    immediates,
    textures,
    samplers,
    aliases,
    overrides,
    structs,
    entry,
    functions,
  ];
}

class Attribute with EquatableMixin {
  const Attribute({required this.name, this.value = const []});

  final String name;
  final List<String> value;

  @override
  List<Object?> get props => [name, value];
}

class TypeInfo with EquatableMixin {
  const TypeInfo({required this.name, this.size = 0, this.attributes = const []});

  final String name;
  final int size;
  final List<Attribute> attributes;

  bool get isArray => false;
  bool get isStruct => false;
  bool get isTemplate => false;
  bool get isPointer => false;

  ArrayInfo get asArray => this as ArrayInfo;
  StructInfo get asStruct => this as StructInfo;
  TemplateInfo get asTemplate => this as TemplateInfo;
  PointerInfo get asPointer => this as PointerInfo;

  String get typeName => name;

  @override
  List<Object?> get props => [name, size, attributes];
}

class MemberInfo with EquatableMixin {
  const MemberInfo({
    required this.name,
    required this.type,
    required this.offset,
    required this.size,
    this.attributes = const [],
  });

  final String name;
  final TypeInfo type;
  final int offset;
  final int size;
  final List<Attribute> attributes;

  bool get isArray => type.isArray;
  bool get isStruct => type.isStruct;
  bool get isTemplate => type.isTemplate;

  int get align => type.isStruct ? type.asStruct.align : 0;
  List<MemberInfo> get members => type.isStruct ? (type as StructInfo).members : [];

  @override
  List<Object?> get props => [name, type, offset, size, attributes];
}

class StructInfo extends TypeInfo {
  const StructInfo({
    required super.name,
    super.size,
    super.attributes,
    this.members = const [],
    this.align = 0,
    this.inUse = false,
  });

  final List<MemberInfo> members;
  final int align;
  final bool inUse;

  @override
  bool get isStruct => true;

  @override
  List<Object?> get props => [...super.props, members, align, inUse];
}

class ArrayInfo extends TypeInfo {
  const ArrayInfo({
    required super.name,
    super.size,
    super.attributes,
    required this.format,
    this.count = 0,
    this.stride = 0,
  });

  final TypeInfo format;
  final int count;
  final int stride;

  @override
  bool get isArray => true;

  @override
  String get typeName => 'array<${format.typeName}, $count>';

  @override
  List<Object?> get props => [...super.props, format, count, stride];
}

class PointerInfo extends TypeInfo {
  const PointerInfo({
    required super.name,
    super.size,
    super.attributes,
    required this.format,
  });

  final TypeInfo format;

  @override
  bool get isPointer => true;

  @override
  String get typeName => '&${format.typeName}';

  @override
  List<Object?> get props => [...super.props, format];
}

class TemplateInfo extends TypeInfo {
  const TemplateInfo({
    required super.name,
    super.size,
    super.attributes,
    required this.format,
    this.access,
  });

  final TypeInfo? format;
  final String? access;

  @override
  bool get isTemplate => true;

  @override
  String get typeName {
    final format = this.format;

    if (format != null) {
      final _vectors = ['vec2', 'vec3', 'vec4'];
      final _matrices = ['mat2x2', 'mat2x3', 'mat2x4', 'mat3x2', 'mat3x3', 'mat3x4', 'mat4x2', 'mat4x3', 'mat4x4'];
      if (_vectors.contains(name) || _matrices.contains(name)) {
        if (format.name == 'f32') return '${name}f';
        if (format.name == 'i32') return '${name}i';
        if (format.name == 'u32') return '${name}u';
        if (format.name == 'bool') return '${name}b';
        if (format.name == 'f16') return '${name}h';
      }
      return '$name<${format.typeName}>';
    } else {
      if (name == 'vec2' || name == 'vec3' || name == 'vec4') return name;
    }

    return name;
  }

  @override
  List<Object?> get props => [...super.props, format, access];
}

enum ResourceType {
  uniform,
  storage,
  immediate,
  texture,
  sampler,
  storageTexture,
}

class VariableInfo with EquatableMixin {
  const VariableInfo({
    required this.name,
    required this.type,
    required this.group,
    required this.binding,
    required this.resourceType,
    required this.access,
    this.relations = const [],
    this.attributes = const [],
  });

  final String name;
  final TypeInfo type;
  final List<Attribute> attributes;
  final int group;
  final int binding;
  final ResourceType resourceType;
  final String access;
  final List<String> relations;

  bool get isArray => type.isArray;
  bool get isStruct => type.isStruct;
  bool get isTemplate => type.isTemplate;

  int get size => type.size;
  int get align => type.isStruct ? type.asStruct.align : 0;
  List<MemberInfo>? get members => type.isStruct ? type.asStruct.members : null;
  TypeInfo? get format {
    if (type.isArray) return type.asArray.format;
    if (type.isTemplate) return type.asTemplate.format;
    return null;
  }

  int get count => type.isArray ? type.asArray.count : 0;
  int get stride => type.isArray ? type.asArray.stride : 0;

  @override
  List<Object?> get props => [name, type, group, binding, resourceType, access, relations, attributes];
}

class AliasInfo with EquatableMixin {
  const AliasInfo({required this.name, required this.type});

  final String name;
  final TypeInfo type;

  @override
  List<Object?> get props => [name, type];
}

class InputInfo with EquatableMixin {
  const InputInfo({
    required this.name,
    required this.type,
    required this.locationType,
    required this.location,
    required this.interpolation,
  });

  final String name;
  final TypeInfo? type;
  final String locationType;
  final String location;
  final String? interpolation;

  @override
  List<Object?> get props => [name, type, locationType, location, interpolation];
}

class OutputInfo with EquatableMixin {
  const OutputInfo({
    required this.name,
    required this.type,
    required this.locationType,
    required this.location,
  });

  final String name;
  final TypeInfo? type;
  final String locationType;
  final String location;

  @override
  List<Object?> get props => [name, type, locationType, location];
}

class OverrideInfo with EquatableMixin {
  const OverrideInfo({required this.id, required this.name, required this.type, this.attributes = const []});

  final int id;
  final String name;
  final TypeInfo? type;
  final List<Attribute> attributes;

  @override
  List<Object?> get props => [id, name, type, attributes];
}

class ArgumentInfo with EquatableMixin {
  const ArgumentInfo({required this.name, required this.type, this.attributes = const []});

  final String name;
  final TypeInfo type;
  final List<Attribute> attributes;

  @override
  List<Object?> get props => [name, type, attributes];
}

typedef FunctionResourceInfo = ({String name, int group, int binding});

class FunctionInfo with EquatableMixin {
  const FunctionInfo({
    required this.name,
    this.stage,
    this.inputs = const [],
    this.outputs = const [],
    this.arguments = const [],
    this.returnType,
    this.resources = const [],
    this.attributes = const [],
    this.inUse = false,
  });

  final String name;
  final String? stage;
  final List<InputInfo> inputs;
  final List<OutputInfo> outputs;
  final List<ArgumentInfo> arguments;
  final TypeInfo? returnType;
  final List<FunctionResourceInfo> resources;
  final List<Attribute> attributes;
  final bool inUse;

  @override
  List<Object?> get props => [name, stage, inputs, outputs, arguments, returnType, resources, attributes, inUse];
}

class EntryFunctions with EquatableMixin {
  const EntryFunctions({this.vertex = const [], this.fragment = const [], this.compute = const []});

  final List<FunctionInfo> vertex;
  final List<FunctionInfo> fragment;
  final List<FunctionInfo> compute;

  @override
  List<Object?> get props => [vertex, fragment, compute];
}
