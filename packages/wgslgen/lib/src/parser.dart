import 'types.dart';

class Parser {
  Parser();

  Attribute parseAttribute(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final List<String> value;

    if (json['value'] is String) {
      value = [json['value'] as String];
    } else if (json['value'] is List) {
      value = (json['value'] as List).map((e) => e.toString()).toList();
    } else {
      value = [];
    }

    return .new(name: name, value: value);
  }

  List<Attribute> parseAttributes(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) => parseAttribute(json as Map<String, dynamic>)).toList();
  }

  (String, int, List<Attribute>) _parseTypeInfoBase(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final size = json['size'] as int;
    final attributes = parseAttributes(json['attributes'] as List<dynamic>?);
    return (name, size, attributes);
  }

  TypeInfo parseTypeInfo(Map<String, dynamic> json) {
    if (json['_isArray'] == true) return parseArrayInfo(json);
    if (json['_isStruct'] == true) return parseStructInfo(json);
    if (json['_isTemplate'] == true) return parseTemplateInfo(json);
    if (json['_isPointer'] == true) return parsePointerInfo(json);

    final (name, size, attributes) = _parseTypeInfoBase(json);
    return .new(name: name, size: size, attributes: attributes);
  }

  MemberInfo parseMemberInfo(Map<String, dynamic> json) {
    final (name, size, attributes) = _parseTypeInfoBase(json);
    final offset = json['offset'] as int;
    final type = parseTypeInfo(json['type'] as Map<String, dynamic>);

    return .new(
      name: name,
      type: type,
      offset: offset,
      size: size,
      attributes: attributes,
    );
  }

  List<MemberInfo> parseMemberInfos(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) => parseMemberInfo(json as Map<String, dynamic>)).toList();
  }

  StructInfo parseStructInfo(Map<String, dynamic> json) {
    final (name, size, attributes) = _parseTypeInfoBase(json);
    final align = json['align'] as int;
    final inUse = json['inUse'] as bool;
    final members = parseMemberInfos(json['members'] as List<dynamic>?);

    return .new(
      name: name,
      size: size,
      align: align,
      inUse: inUse,
      attributes: attributes,
      members: members,
    );
  }

  List<StructInfo> parseStructInfos(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) => parseStructInfo(json as Map<String, dynamic>)).toList();
  }

  ArrayInfo parseArrayInfo(Map<String, dynamic> json) {
    final (name, size, attributes) = _parseTypeInfoBase(json);
    final format = parseTypeInfo(json['format'] as Map<String, dynamic>);
    final count = json['count'] as int;
    final stride = json['stride'] as int;

    return .new(
      name: name,
      size: size,
      attributes: attributes,
      format: format,
      count: count,
      stride: stride,
    );
  }

  PointerInfo parsePointerInfo(Map<String, dynamic> json) {
    final (name, size, attributes) = _parseTypeInfoBase(json);
    final format = parseTypeInfo(json['format'] as Map<String, dynamic>);

    return .new(
      name: name,
      size: size,
      attributes: attributes,
      format: format,
    );
  }

  TemplateInfo parseTemplateInfo(Map<String, dynamic> json) {
    final (name, size, attributes) = _parseTypeInfoBase(json);
    final format = json['format'] != null ? parseTypeInfo(json['format'] as Map<String, dynamic>) : null;
    final access = json['access'] as String?;

    return .new(
      name: name,
      size: size,
      attributes: attributes,
      format: format,
      access: access,
    );
  }

  ResourceType parseResourceType(int v) => switch (v) {
    0 => .uniform,
    1 => .storage,
    2 => .immediate,
    3 => .texture,
    4 => .sampler,
    5 => .storageTexture,
    _ => throw ArgumentError('Unknown resource type: $v'),
  };

  final _variableInfos = <String, VariableInfo>{};

  VariableInfo parseVariableInfo(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final type = parseTypeInfo(json['type'] as Map<String, dynamic>);
    final attributes = parseAttributes(json['attributes'] as List<dynamic>?);
    final group = json['group'] as int;
    final binding = json['binding'] as int;
    final resourceType = parseResourceType(json['resourceType'] as int);
    final access = json['access'] as String;
    final relations = (json['relations'] as List<dynamic>?)?.cast<String>().toList() ?? [];

    final result = VariableInfo(
      name: name,
      type: type,
      attributes: attributes,
      group: group,
      binding: binding,
      resourceType: resourceType,
      access: access,
      relations: relations,
    );

    _variableInfos[name] = result;
    return result;
  }

  List<VariableInfo> parseVariableInfos(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) => parseVariableInfo(json as Map<String, dynamic>)).toList();
  }

  AliasInfo parseAliasInfo(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final type = parseTypeInfo(json['type'] as Map<String, dynamic>);
    return .new(name: name, type: type);
  }

  List<AliasInfo> parseAliasInfos(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) => parseAliasInfo(json as Map<String, dynamic>)).toList();
  }

  String _parseLocation(dynamic location) {
    if (location is String) return location;
    if (location is int) return location.toString();
    throw ArgumentError('Invalid location type: ${location.runtimeType}');
  }

  InputInfo parseInputInfo(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final type = json['type'] != null ? parseTypeInfo(json['type'] as Map<String, dynamic>) : null;
    final locationType = json['locationType'] as String;
    final location = _parseLocation(json['location']);
    final interpolation = json['interpolation'] as String?;

    return .new(
      name: name,
      type: type,
      locationType: locationType,
      location: location,
      interpolation: interpolation,
    );
  }

  List<InputInfo> parseInputInfos(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) => parseInputInfo(json as Map<String, dynamic>)).toList();
  }

  OutputInfo parseOutputInfo(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final type = json['type'] != null ? parseTypeInfo(json['type'] as Map<String, dynamic>) : null;
    final location = _parseLocation(json['location']);
    final locationType = json['locationType'] as String;

    return .new(
      name: name,
      type: type,
      locationType: locationType,
      location: location,
    );
  }

  List<OutputInfo> parseOutputInfos(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) => parseOutputInfo(json as Map<String, dynamic>)).toList();
  }

  OverrideInfo parseOverrideInfo(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final name = json['name'] as String;
    final type = json['type'] != null ? parseTypeInfo(json['type'] as Map<String, dynamic>) : null;
    final attributes = parseAttributes(json['attributes'] as List<dynamic>?);

    return .new(
      id: id,
      name: name,
      type: type,
      attributes: attributes,
    );
  }

  List<OverrideInfo> parseOverrideInfos(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) => parseOverrideInfo(json as Map<String, dynamic>)).toList();
  }

  ArgumentInfo parseArgumentInfo(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final type = parseTypeInfo(json['type'] as Map<String, dynamic>);
    final attributes = parseAttributes(json['attributes'] as List<dynamic>?);

    return .new(
      name: name,
      type: type,
      attributes: attributes,
    );
  }

  List<ArgumentInfo> parseArgumentInfos(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) => parseArgumentInfo(json as Map<String, dynamic>)).toList();
  }

  List<FunctionResourceInfo> parseFunctionResourceInfos(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) {
      final name = json['name'] as String;
      final group = json['group'] as int;
      final binding = json['binding'] as int;
      return (name: name, group: group, binding: binding);
    }).toList();
  }

  FunctionInfo parseFunctionInfo(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final stage = json['stage'] as String?;
    final inputs = parseInputInfos(json['inputs'] as List<dynamic>?);
    final outputs = parseOutputInfos(json['outputs'] as List<dynamic>?);
    final arguments = parseArgumentInfos(json['arguments'] as List<dynamic>?);
    final returnType = json['returnType'] != null ? parseTypeInfo(json['returnType'] as Map<String, dynamic>) : null;
    final resources = parseFunctionResourceInfos(json['resources'] as List<dynamic>?);
    final attributes = parseAttributes(json['attributes'] as List<dynamic>?);
    final inUse = json['inUse'] as bool;

    return .new(
      name: name,
      stage: stage,
      inputs: inputs,
      outputs: outputs,
      arguments: arguments,
      returnType: returnType,
      resources: resources,
      attributes: attributes,
      inUse: inUse,
    );
  }

  List<FunctionInfo> parseFunctionInfos(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) => parseFunctionInfo(json as Map<String, dynamic>)).toList();
  }

  EntryFunctions parseEntryFunctions(Map<String, dynamic> json) {
    final vertex = parseFunctionInfos(json['vertex'] as List<dynamic>?);
    final fragment = parseFunctionInfos(json['fragment'] as List<dynamic>?);
    final compute = parseFunctionInfos(json['compute'] as List<dynamic>?);

    return .new(
      vertex: vertex,
      fragment: fragment,
      compute: compute,
    );
  }

  WgslReflectionInfo parseReflectionInfo(Map<String, dynamic> json) {
    final entry = parseEntryFunctions(json['entry'] as Map<String, dynamic>);
    final uniforms = parseVariableInfos(json['uniforms'] as List<dynamic>?);
    final storages = parseVariableInfos(json['storage'] as List<dynamic>?);
    final immediates = parseVariableInfos(json['immediates'] as List<dynamic>?);
    final textures = parseVariableInfos(json['textures'] as List<dynamic>?);
    final samplers = parseVariableInfos(json['samplers'] as List<dynamic>?);
    final aliases = parseAliasInfos(json['aliases'] as List<dynamic>?);
    final overrides = parseOverrideInfos(json['overrides'] as List<dynamic>?);
    final structs = parseStructInfos(json['structs'] as List<dynamic>?);
    final functions = parseFunctionInfos(json['functions'] as List<dynamic>?);

    return .new(
      entry: entry,
      uniforms: uniforms,
      storages: storages,
      immediates: immediates,
      textures: textures,
      samplers: samplers,
      aliases: aliases,
      overrides: overrides,
      structs: structs,
      functions: functions,
    );
  }
}
