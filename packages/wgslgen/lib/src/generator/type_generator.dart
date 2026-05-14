// ignore_for_file: avoid_print

part of '../generator.dart';

extension StringListUtils on Iterable<String> {
  List<String> indent([int level = 1]) => map((l) => '  ' * level + l).toList();
}

extension TypeExt on TypeInfo {
  String get dartType => wgslTypeToDart(this);
  String get internalType => wgslTypeToInternal(this);
  String? get defaultValue => typeDefaultValue(this);
  String? get internalDefaultValue => typeInternalDefaultValue(this);

  String get dartName => wgslTypeDartName(this);

  String dartToInternal(String expr) => typeDartToInternal(this, expr);

  List<String> read({String offset = 'offset', bool ret = false}) => wgslTypeRead(this, offset: offset, ret: ret);
  List<String> write(String expr, {String offset = 'offset'}) => wgslTypeWrite(this, expr, offset: offset);
}

extension MemberExt on MemberInfo {
  String get dartName => wgslMemberDartName(name);
}

String? typeDefaultValue(TypeInfo type) {
  if (type.isArray) {
    final array = type.asArray;
    final format = array.format;
    final count = array.count;

    final defaultValue = typeDefaultValue(format) ?? '<unknown>';
    final inner = List.filled(count, defaultValue).join(', ');
    return '($inner)';
  } else if (type.isStruct) {
    return '.zero';
  } else if (type.isTemplate) {
    final template = type.asTemplate;
    if (template.name == 'atomic') return typeDefaultValue(template.format!);
    return typeDefaultValue(TypeInfo(name: type.typeName));
  }

  if (_wgslBuiltinVecMat(type) != null) {
    if (type.name.startsWith('mat')) return '.identity';
    return '.zero';
  }

  final result = switch (type.name) {
    'f16' || 'f32' || 'f64' => '0.0',
    'i32' || 'u32' => '0',
    'bool' => 'false',
    _ => null,
  };

  return result;
}

String? typeInternalDefaultValue(TypeInfo type) {
  if (type.isArray) {
    final array = type.asArray;
    final format = array.format;
    final count = array.count;

    final defaultValue = typeInternalDefaultValue(format) ?? '<unknown>';
    final inner = List.filled(count, defaultValue).join(', ');
    return '($inner)';
  } else if (type.isStruct) {
    return '.zero';
  } else if (type.isTemplate) {
    final template = type.asTemplate;
    if (template.name == 'atomic') return typeInternalDefaultValue(template.format!);
    return typeInternalDefaultValue(TypeInfo(name: type.typeName));
  }

  if (_wgslBuiltinVecMat(type) != null) {
    if (type.name.startsWith('mat')) return '.identity';
    return '.zero';
  }

  final result = switch (type.name) {
    'f16' || 'f32' || 'f64' => '.zero',
    'i32' || 'u32' => '.zero',
    _ => null,
  };

  return result;
}

String? _wgslBuiltinVecMat(TypeInfo type) {
  final vecMaxLen = 4;
  final vecTypes = ['f', 'i', 'u', 'h'];
  final matMaxDim = 4;
  final matTypes = ['f', 'h'];

  for (var vecLen = 2; vecLen <= vecMaxLen; vecLen++) {
    for (final vecType in vecTypes) {
      if (type.name == 'vec$vecLen$vecType') return 'wgsl.Vec$vecLen$vecType';
    }
  }

  for (var col = 2; col <= matMaxDim; col++) {
    for (var row = 2; row <= matMaxDim; row++) {
      for (final matType in matTypes) {
        if (type.name == 'mat${col}x$row$matType') return 'wgsl.Mat${col}x$row$matType';
      }
    }
  }

  return null;
}

String wgslTypeToInternal(TypeInfo type) {
  if (type.isArray) {
    final array = type.asArray;
    final format = array.format;
    final count = array.count;

    final dartFormatType = wgslTypeToInternal(format);
    final inner = List.filled(count, dartFormatType).join(', ');
    return '($inner)';
  } else if (type.isStruct) {
    final struct = type.asStruct;
    return struct.name;
  } else if (type.isTemplate) {
    final template = type.asTemplate;
    if (template.name == 'atomic') return wgslTypeToInternal(template.format!);
    return wgslTypeToInternal(TypeInfo(name: template.typeName));
  }

  if (_wgslBuiltinVecMat(type) != null) return _wgslBuiltinVecMat(type)!;
  final result = switch (type.name) {
    'f16' => 'wgsl.F16',
    'f32' => 'wgsl.F32',
    'f64' => 'wgsl.F64',
    'i32' => 'wgsl.I32',
    'u32' => 'wgsl.U32',
    _ => null,
  };

  if (result != null) return result;

  print('unknown type (wgslTypeToInternalDart): ${type.name}, defaulting to ${type.name}');
  return type.name;
}

String wgslTypeToDart(TypeInfo type) {
  if (type.isArray) {
    final array = type.asArray;
    final format = array.format;
    final count = array.count;

    final dartFormatType = wgslTypeToDart(format);
    final inner = List.filled(count, dartFormatType).join(', ');
    return '($inner)';
  } else if (type.isStruct) {
    final struct = type.asStruct;
    return struct.name;
  } else if (type.isTemplate) {
    final template = type.asTemplate;
    if (template.name == 'atomic') return wgslTypeToDart(template.format!);
    return wgslTypeToDart(TypeInfo(name: template.typeName));
  }

  if (_wgslBuiltinVecMat(type) != null) return _wgslBuiltinVecMat(type)!;
  final result = switch (type.name) {
    'f32' => 'double',
    'f64' => 'double',
    'i32' => 'int',
    'u32' => 'int',
    'bool' => 'bool',
    _ => null,
  };

  if (result != null) return result;

  print('unknown type (wgslTypeToDart): ${type.name}, defaulting to ${type.name}');
  return type.name;
}

List<String> wgslTypeRead(TypeInfo type, {String offset = 'offset', bool ret = false}) {
  if (type.isArray) {
    final array = type.asArray;
    final count = array.count;
    final stride = array.stride;

    final inner = List.generate(
      count,
      (i) => wgslTypeRead(array.format, offset: '$offset + $i * $stride', ret: false),
    ).toList();

    return [
      ret ? 'return (' : '(',
      for (final i in inner) ...i.map((i) => '$i,').indent(),
      ret ? ');' : ')',
    ];
  } else {
    final internalType = type.internalType;
    final prefix = ret ? 'return ' : '';
    final suffix = ret ? ';' : '';
    return ['$prefix$internalType.read(data, $offset)$suffix'];
  }
}

List<String> wgslTypeWrite(TypeInfo type, String expr, {String offset = 'offset'}) {
  if (type.isArray) {
    final array = type.asArray;
    final count = array.count;
    final stride = array.stride;

    final lines = <String>[];

    for (var j = 0; j < count; j++) {
      final write = wgslTypeWrite(array.format, '$expr.\$${j + 1}', offset: '$offset + $j * $stride').join('');
      lines.add(write);
    }

    return lines;
  } else {
    final internalType = type.internalType;
    final dartType = type.dartType;

    final write = 'write(data, $offset);';
    if (internalType != dartType) return ['$internalType($expr).$write'];
    return ['$expr.$write'];
  }
}

String typeDartToInternal(TypeInfo type, String expr) {
  final dartType = wgslTypeToDart(type);
  final internalType = wgslTypeToInternal(type);

  if (dartType == internalType) return expr;

  if (type.isArray) {
    final array = type.asArray;
    final inner = List.generate(array.count, (i) => '.new($expr.\$${i + 1})');
    return '(${inner.join(', ')})';
  } else {
    return '.new($expr)';
  }
}

extension StructTypeExt on StructInfo {
  List<MemberInfo> get visibleMembers => members.where((m) => !m.name.startsWith('_')).toList();

  List<String> get dartSetterArgs => wgslStructTypeDartSetterArgs(this);
}

List<String> wgslStructTypeDartSetterArgs(StructInfo struct) {
  final args = <String>[];

  for (final member in struct.visibleMembers) {
    final dartType = member.type.dartType;
    if (member.type.defaultValue != null) {
      args.add('$dartType ${member.dartName} = ${member.type.defaultValue}');
    } else {
      args.add('required $dartType ${member.dartName}');
    }
  }

  return args;
}

String _toPascalCase(String str) => str.split('_').map((s) => s[0].toUpperCase() + s.substring(1)).join();

String _toCamelCase(String str) {
  final pascal = _toPascalCase(str);
  return pascal[0].toLowerCase() + pascal.substring(1);
}

String wgslTypeDartName(TypeInfo type) {
  if (type.isArray) {
    final array = type.asArray;
    final dartFormatName = wgslTypeDartName(array.format);
    if (array.count > 0) return '${dartFormatName}Array${array.count}';
    return '${dartFormatName}Array';
  } else if (type.isStruct) {
    final struct = type.asStruct;
    return _toPascalCase(struct.name);
  } else if (type.isTemplate) {
    final template = type.asTemplate;
    final parts = [template.name];
    if (template.format != null) parts.add(template.format!.name);
    return parts.map((p) => _toPascalCase(p)).join();
  }

  return _toPascalCase(type.name);
}

String wgslMemberDartName(String name) {
  if (name.startsWith('_')) return name.substring(1);
  return _toCamelCase(name);
}

extension VariableInfoExt on VariableInfo {
  String get dartName => wgslMemberDartName(name);
}

extension FunctionInfoExt on FunctionInfo {
  String get dartName => _toCamelCase(name);
}

extension OverrideInfoExt on OverrideInfo {
  String get dartName => _toCamelCase(name);
}

extension InputInfoExt on InputInfo {
  String get dartName => _toCamelCase(name);
}