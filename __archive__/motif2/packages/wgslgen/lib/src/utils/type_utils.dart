// ignore_for_file: avoid_print

part of '../generator.dart';

extension TypeInfoExt on TypeInfo {
  String get dartName => _typeDartName(this);
  String get internalName => _typeInternalName(this);
  String get unprefixedDartName => dartName.split('.').last;
  String get unprefixedInternalName => internalName.split('.').last;

  String get dartType => _typeDartType(this);
  String get internalType => _typeInternalType(this);

  String get extensionName => _typeExtensionName(this);

  String get dartDefaultValue => _typeDartDefaultValue(this);
  String get internalDefaultValue => _typeInternalDefaultValue(this);

  String dartToInternal(String expr) => _typeDartToInternal(this, expr);
  String internalToDart(String expr) => _typeInternalToDart(this, expr);

  List<String> readFn({String offset = 'offset', String length = 'length', bool returns = false}) =>
      _typeReadFn(this, offset: offset, length: length, returns: returns);
  List<String> writeFn(String expr, {String offset = 'offset'}) => _typeWriteFn(this, expr, offset: offset);
}

enum _BuiltinType {
  f32('f', 'wgsl.F32', 'double'),
  i32('i', 'wgsl.I32', 'int'),
  u32('u', 'wgsl.U32', 'int'),
  f16('h', 'wgsl.F32', 'double'),
  bool_('b', 'int', 'bool');

  const _BuiltinType(this.short, this.internalType, this.dartType);
  final String short;
  final String internalType;
  final String dartType;
}

typedef _VecInfo = ({_BuiltinType format, int count});
typedef _MatInfo = ({_BuiltinType format, int columns, int rows});

_BuiltinType? _isBuiltinType(String name) => switch (name) {
  'f32' => .f32,
  'i32' => .i32,
  'u32' => .u32,
  'f16' => .f16,
  'bool' => .bool_,
  _ => null,
};

_VecInfo? _isVecType(String name) {
  const maxLen = 4;
  const types = <String, _BuiltinType>{'f': .f32, 'i': .i32, 'u': .u32, 'h': .f16};
  for (var len = 2; len <= maxLen; len++) {
    for (final entry in types.entries) {
      if (name == 'vec$len${entry.key}') return (format: entry.value, count: len);
    }
  }
  return null;
}

_MatInfo? _isMatType(String name) {
  const maxDim = 4;
  const types = <String, _BuiltinType>{'f': .f32, 'h': .f16};
  for (var c = 2; c <= maxDim; c++) {
    for (var r = 2; r <= maxDim; r++) {
      for (final entry in types.entries) {
        if (name == 'mat${c}x$r${entry.key}') return (format: entry.value, columns: c, rows: r);
      }
    }
  }
  return null;
}

String _vecInternalName(_VecInfo info) => 'wgsl.Vec${info.count}${info.format.short}';
String _matInternalName(_MatInfo info) => 'wgsl.Mat${info.columns}x${info.rows}${info.format.short}';

String _vecInternalType(_VecInfo info) => _vecInternalName(info);
String _matInternalType(_MatInfo info) => _matInternalName(info);

String _vecDartType(_VecInfo info) => _vecInternalType(info);
String _matDartType(_MatInfo info) => _matInternalType(info);

sealed class _TypeCategory {
  const _TypeCategory();
}

final class _SizedArrayType extends _TypeCategory {
  const _SizedArrayType(this.array, this.format, this.count);
  final ArrayInfo array;
  final TypeInfo format;
  final int count;
}

final class _UnsizedArrayType extends _TypeCategory {
  const _UnsizedArrayType(this.array, this.format);
  final ArrayInfo array;
  final TypeInfo format;
}

final class _StructType extends _TypeCategory {
  const _StructType(this.struct);
  final StructInfo struct;
}

final class _TemplateType extends _TypeCategory {
  const _TemplateType(this.template, this.format);
  final TemplateInfo template;
  final TypeInfo? format;
}

final class _AtomicType extends _TypeCategory {
  const _AtomicType(this.format);
  final TypeInfo format;
}

final class _BuiltinTypeCategory extends _TypeCategory {
  const _BuiltinTypeCategory(this.builtin);
  final _BuiltinType builtin;
}

final class _VecType extends _TypeCategory {
  const _VecType(this.info);
  final _VecInfo info;
}

final class _MatType extends _TypeCategory {
  const _MatType(this.info);
  final _MatInfo info;
}

final class _UnknownType extends _TypeCategory {
  const _UnknownType(this.name);
  final String name;
}

_TypeCategory _classifyType(TypeInfo type) {
  if (type.isArray) {
    final array = type.asArray;
    if (array.count > 0) return _SizedArrayType(array, array.format, array.count);
    return _UnsizedArrayType(array, array.format);
  } else if (type.isStruct) {
    return _StructType(type.asStruct);
  } else if (type.isTemplate) {
    final template = type.asTemplate;
    if (template.name == 'atomic') return _AtomicType(template.format!);
    return _TemplateType(template, template.format);
  }

  final builtin = _isBuiltinType(type.name);
  if (builtin != null) return _BuiltinTypeCategory(builtin);

  final vec = _isVecType(type.name);
  if (vec != null) return _VecType(vec);

  final mat = _isMatType(type.name);
  if (mat != null) return _MatType(mat);

  print('warning (_classifyType): unknown type ${type.name}, defaulting to _UnknownType');
  return _UnknownType(type.name);
}

String _typeDartName(TypeInfo type) {
  return switch (_classifyType(type)) {
    _SizedArrayType(:final array) => array.dartTypedefName,
    _UnsizedArrayType(:final array) => array.dartTypedefName,
    _StructType(:final struct) => struct.dartTypedefName,
    _AtomicType(:final format) => _typeDartName(format),
    _TemplateType(:final template, :final format) => [template.name, ?format?.name].map(toDartTopLevelName).join(),
    _BuiltinTypeCategory(:final builtin) => builtin.dartType,
    _VecType(:final info) => _vecDartType(info),
    _MatType(:final info) => _matDartType(info),
    _UnknownType(:final name) => toDartTopLevelName(name),
  };
}

String _typeInternalName(TypeInfo type) {
  return switch (_classifyType(type)) {
    _SizedArrayType(:final array) => array.internalTypedefName,
    _UnsizedArrayType(:final array) => array.internalTypedefName,
    _StructType(:final struct) => struct.internalTypedefName,
    _AtomicType(:final format) => _typeInternalName(format),
    _TemplateType(:final template, :final format) => [template.name, ?format?.name].map(toDartTopLevelName).join(),
    _BuiltinTypeCategory(:final builtin) => builtin.internalType,
    _VecType(:final info) => _vecInternalName(info),
    _MatType(:final info) => _matInternalName(info),
    _UnknownType(:final name) => toDartTopLevelName(name),
  };
}

String _typeExtensionName(TypeInfo type) {
  return switch (_classifyType(type)) {
    _SizedArrayType(:final array) => array.dartTypedefName,
    _UnsizedArrayType(:final array) => array.dartTypedefName,
    _StructType(:final struct) => struct.dartTypedefName,
    _AtomicType(:final format) => _typeExtensionName(format),
    _TemplateType(:final template, :final format) => [template.name, ?format?.name].map(toDartTopLevelName).join(),
    _BuiltinTypeCategory(:final builtin) => builtin.internalType.split('.').last,
    _VecType(:final info) => _vecInternalName(info).split('.').last,
    _MatType(:final info) => _matInternalName(info).split('.').last,
    _UnknownType(:final name) => toDartTopLevelName(name),
  };
}

String _record(String t) {
  final count = ','.allMatches(t).length;
  if (count == 0) return '($t,)';
  return '($t)';
}

String _typeDartType(TypeInfo type) {
  return switch (_classifyType(type)) {
    _SizedArrayType(:final format, :final count) => _record(List.filled(count, _typeDartType(format)).join(', ')),
    _UnsizedArrayType(:final format) => 'List<${_typeDartType(format)}>',
    _StructType(:final struct) => _record(struct.visibleMembers.dartTuple),
    _AtomicType(:final format) => _typeDartType(format),
    _TemplateType(:final template) => _typeDartType(.new(name: template.typeName)),
    _BuiltinTypeCategory(:final builtin) => builtin.dartType,
    _VecType(:final info) => _vecDartType(info),
    _MatType(:final info) => _matDartType(info),
    _UnknownType() => 'dynamic',
  };
}

String _typeInternalType(TypeInfo type) {
  return switch (_classifyType(type)) {
    _SizedArrayType(:final format, :final count) => _record(List.filled(count, _typeInternalType(format)).join(', ')),
    _UnsizedArrayType(:final format) => 'List<${_typeInternalType(format)}>',
    _StructType(:final struct) => _record(struct.visibleMembers.internalTuple),
    _AtomicType(:final format) => _typeInternalType(format),
    _TemplateType(:final template) => _typeInternalType(.new(name: template.typeName)),
    _BuiltinTypeCategory(:final builtin) => builtin.internalType,
    _VecType(:final info) => _vecInternalType(info),
    _MatType(:final info) => _matInternalType(info),
    _UnknownType() => 'dynamic',
  };
}

// String _typeDartTypeName(TypeInfo type) {
//   if (type.isArray) return type.asArray.dartTypedefName;
//   if (type.isStruct) return type.asStruct.dartTypedefName;
//   return type.dartName;
// }

// String _typeInternalTypeName(TypeInfo type) {
//   if (type.isArray) return type.asArray.internalTypedefName;
//   if (type.isStruct) return type.asStruct.internalTypedefName;
//   return type.internalName;
// }

String _typeDartDefaultValue(TypeInfo type) {
  return switch (_classifyType(type)) {
    _SizedArrayType(:final format, :final count) => '(${List.filled(count, _typeDartDefaultValue(format)).join(', ')})',
    _UnsizedArrayType() => 'const []',
    _StructType(:final struct) => '(${struct.visibleMembers.dartZeroValuesTuple})',
    _AtomicType(:final format) => _typeDartDefaultValue(format),
    _TemplateType(:final template) => _typeDartDefaultValue(.new(name: template.typeName)),
    _BuiltinTypeCategory() => '0',
    _VecType() => '.zero',
    _MatType() => '.identity',
    _UnknownType() => 'null',
  };
}

String _typeInternalDefaultValue(TypeInfo type) {
  return switch (_classifyType(type)) {
    _SizedArrayType(:final format, :final count) =>
      '(${List.filled(count, _typeInternalDefaultValue(format)).join(', ')})',
    _UnsizedArrayType() => 'const []',
    _StructType(:final struct) => '(${struct.visibleMembers.internalZeroValuesTuple})',
    _AtomicType(:final format) => _typeInternalDefaultValue(format),
    _TemplateType(:final template) => _typeInternalDefaultValue(.new(name: template.typeName)),
    _BuiltinTypeCategory() => '.zero',
    _VecType() => '.zero',
    _MatType() => '.identity',
    _UnknownType() => 'null',
  };
}

String _typeDartToInternal(TypeInfo type, String expr) {
  final dartType = _typeDartType(type);
  final internalType = _typeInternalType(type);
  if (dartType == internalType) return expr;

  if (type.isArray) {
    final array = type.asArray;
    if (array.count == 0) {
      return '($expr.map((e) => ${_typeDartToInternal(array.format, 'e')}).toList())';
    }

    final inner = List.generate(array.count, (i) => _typeDartToInternal(array.format, '$expr.\$${i + 1}'));
    return '(${inner.join(', ')})';
  } else {
    if (type.isStruct) return '$expr.asInternal';
    return '.new($expr)';
  }
}

String _typeInternalToDart(TypeInfo type, String expr) {
  final dartType = _typeDartType(type);
  final internalType = _typeInternalType(type);
  if (dartType == internalType) return expr;

  if (type.isArray) {
    final array = type.asArray;
    if (array.count == 0) return '($expr.map((e) => ${_typeInternalToDart(array.format, 'e')}).toList())';

    final inner = List.generate(array.count, (i) => _typeInternalToDart(array.format, '$expr.\$${i + 1}'));
    return '(${inner.join(', ')})';
  } else {
    if (type.isStruct) return '$expr.asDart';
    return expr;
  }
}

List<String> _typeReadFn(TypeInfo type, {String offset = 'offset', String length = 'length', bool returns = false}) {
  if (type.isArray) {
    final array = type.asArray;
    final count = array.count;
    final stride = array.stride;

    if (count > 0) {
      final inner = List.generate(
        count,
        (i) => _typeReadFn(array.format, offset: '$offset + $i * $stride', returns: false),
      );

      return [
        returns ? 'return (' : '(',
        for (final i in inner) ...i.map((i) => '$i,').indent(),
        returns ? ');' : ')',
      ];
    } else {
      final prefix = returns ? 'return ' : '';
      final suffix = returns ? ';' : '';
      return [
        '${prefix}List.generate($length, (i) {',
        ..._typeReadFn(array.format, offset: '$offset + i * $stride', returns: true).indent(),
        '})$suffix',
      ];
    }
  } else {
    final internalType = _typeInternalType(type);
    var _expr = '$internalType.read(data, $offset)';

    if (type.isStruct) {
      final struct = type.asStruct;
      _expr = '${struct.dartStructName}.read(data, $offset)';
    }

    return [
      [
        returns ? 'return ' : '',
        _expr,
        returns ? ';' : '',
      ].join(),
    ];
  }
}

List<String> _typeWriteFn(TypeInfo type, String expr, {String offset = 'offset'}) {
  if (type.isArray) {
    final array = type.asArray;
    final count = array.count;
    final stride = array.stride;

    final lines = <String>[];

    if (count > 0) {
      for (var i = 0; i < count; i++) {
        final write = _typeWriteFn(array.format, '$expr.\$${i + 1}', offset: '$offset + $i * $stride');
        lines.addAll(write);
      }
    } else {
      lines.add('for (var i = 0; i < $expr.length; i++) {');
      final write = _typeWriteFn(array.format, '$expr[i]', offset: '$offset + i * $stride');
      lines.addAll(write.indent());
      lines.add('}');
    }

    return lines;
  } else {
    var _expr = expr;

    final internalType = _typeInternalType(type);
    final dartType = _typeDartType(type);

    if (type.isStruct) {
      // final struct = type.asStruct;
      _expr = '$_expr.asInternal';
    } else if (internalType != dartType) {
      _expr = '$internalType($_expr)';
    }

    final write = 'write(data, $offset);';
    return ['$_expr.$write'];
  }
}
