part of '../generator.dart';

final _preferInline = '@pragma(\'vm:prefer-inline\')';

List<String> generateStruct(StructInfo info) {
  final lines = <String>[];

  final visibleMembers = info.visibleMembers;

  final internalDartMembers = <String>[];
  for (final member in visibleMembers) {
    internalDartMembers.add('${member.type.internalType} ${member.dartName}');
  }

  final dartMembers = <String>[];
  for (final member in visibleMembers) {
    dartMembers.add('${member.type.dartType} ${member.dartName}');
  }

  final tuple = '(${dartMembers.join(', ')})';
  
  lines.add('@wgsl.Struct(\'${info.name}\')');
  lines.add('extension type const ${info.dartName}._($tuple _) {');

  // Zero-init default
  lines.add('  static const ${info.dartName} zero = ${info.dartName}._((');
  for (final member in visibleMembers) {
    lines.add('    ${member.type.defaultValue},');
  }
  lines.add('  ));');
  lines.add('');

  // Member accessors
  for (final (i, member) in visibleMembers.indexed) {
    lines.add('  ${member.type.dartType} get ${member.dartName} => _.\$${i + 1};');
  }
  lines.add('');

  // From Dart types
  final fromCallArgs = info.dartSetterArgs.join(', ');

  lines.add('  $_preferInline');
  lines.add('  ${info.dartName}({$fromCallArgs}): this._((');
  for (final member in visibleMembers) {
    lines.add('    ${member.dartName},');
  }
  lines.add('  ));');
  lines.add('');

  // Read
  lines.add('  $_preferInline');
  lines.add('  ${info.dartName}.read(ByteData data, int offset): this._((');
  for (final member in visibleMembers) {
    final getter = member.type.read(offset: 'offset + ${member.offset}');
    lines.addAll(getter.indent(2));
    lines.last += ',';
  }
  lines.add('  ));');
  lines.add('');

  // Write
  lines.add('  $_preferInline');
  lines.add('  void write(ByteData data, int offset) {');
  for (final (i, member) in visibleMembers.indexed) {
    final setter = member.type.write('_.\$${i + 1}', offset: 'offset + ${member.offset}');
    lines.addAll(setter.indent(2));
  }
  lines.add('  }');
  lines.add('}');
  return lines;
}
