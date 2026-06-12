part of '../generator.dart';

List<String> generateStruct(StructInfo struct) {
  final lines = <String>[];

  final typedefName = struct.dartTypedefName;
  final internalTypedefName = struct.internalTypedefName;

  // Typedef
  lines.add('typedef $typedefName = ${struct.dartType};');
  lines.add('typedef $internalTypedefName = ${struct.internalType};');
  lines.add('');

  // Dart extension
  lines.add('extension ${typedefName}Ext on $typedefName {');
  for (final (i, m) in struct.visibleMembers.indexed)
    lines.add('  ${m.dartType} get ${m.dartName} => this.\$${i + 1};');
  lines.add('');
  lines.add('  $_preferInline');
  lines.add('  $internalTypedefName get asInternal => (');
  for (final m in struct.visibleMembers) lines.add('    ${m.type.dartToInternal(m.dartName)},');
  lines.add('  );');
  lines.add('}');
  lines.add('');

  // Internal extension
  lines.add('extension ${internalTypedefName}Ext on $internalTypedefName {');
  for (final (i, m) in struct.visibleMembers.indexed)
    lines.add('  ${m.internalType} get ${m.dartName} => this.\$${i + 1};');
  lines.add('');
  lines.add('  $_preferInline');
  lines.add('  $typedefName get asDart => (');
  for (final (i, m) in struct.visibleMembers.indexed) lines.add('    ${m.type.internalToDart('this.\$${i + 1}')},');
  lines.add('  );');
  lines.add('');
  lines.add('  $_preferInline');
  lines.add('  void write(ByteData data, int offset) {');
  for (final (i, m) in struct.visibleMembers.indexed) {
    final write = m.type.writeFn('this.\$${i + 1}', offset: 'offset + ${m.offset}');
    lines.addAll(write.indent(2));
  }
  lines.add('  }');
  lines.add('}');
  lines.add('');

  lines.add('extension ${struct.dartStructName} on $typedefName {');
  lines.add('  $_preferInline');
  lines.add('  static $internalTypedefName read(ByteData data, int offset) => (');
  for (final m in struct.visibleMembers) {
    late final String length;
    if (m.isArray) {
      final array = m.type.asArray;
      length = '(data.lengthInBytes - offset - ${m.offset}) ~/ ${array.format.size}';
    } else {
      length = '';
    }

    final getter = m.type.readFn(offset: 'offset + ${m.offset}', length: length);
    lines.addAll(getter.indent(2));
    lines.last += ',';
  }
  lines.add('  );');
  lines.add('');
  lines.add('}');

  // Extensions

  // final structName = struct.dartStructName;
  // final fromCtorName = struct.dartStructFromCtor;
  // final members = struct.visibleMembers;

  // // Declaration
  // lines.add(_metaStructView([struct.name]));
  // lines.add('extension type const $structName._($internalTypedefName _) {');

  // // Constructor (regular)
  // lines.add('  $_preferInline');
  // lines.add('  $structName({${members.dartNamedCtorArgs}}): this._((');
  // for (final m in members) lines.add('    ${m.type.dartToInternal(m.dartName)},');
  // lines.add('  ));');
  // lines.add('');

  // // Constructor (from)
  // lines.add('  $_preferInline');
  // lines.add('  $fromCtorName((${members.dartCtorArgs}) t): this._((');
  // for (final (i, m) in members.indexed) lines.add('    ${m.type.dartToInternal('t.\$${i + 1}')},');
  // lines.add('  ));');
  // lines.add('');

  // // Member accessors
  // for (final (i, m) in members.indexed) {
  //   lines.add('  ${m.dartType} get ${m.dartName} => ${m.type.internalToDart('_.\$${i + 1}')};');
  // }
  // lines.add('');

  // // Read
  // lines.add('  $_preferInline');
  // lines.add('  $structName.read(ByteData data, int offset): this._((');
  // for (final m in members) {
  //   late final String length;

  //   if (m.isArray) {
  //     final array = m.type.asArray;
  //     length = '(data.lengthInBytes - offset - ${m.offset}) ~/ ${array.format.size}';
  //   } else {
  //     length = '';
  //   }

  //   final getter = m.type.readFn(offset: 'offset + ${m.offset}', length: length);
  //   lines.addAll(getter.indent(2));
  //   lines.last += ',';
  // }
  // lines.add('  ));');
  // lines.add('');

  // // Write
  // lines.add('  $_preferInline');
  // lines.add('  void write(ByteData data, int offset) {');
  // for (final (i, m) in members.indexed) {
  //   final write = m.type.writeFn('_.\$${i + 1}', offset: 'offset + ${m.offset}');
  //   lines.addAll(write.indent(2));
  // }
  // lines.add('  }');
  // lines.add('');

  // // as dart
  // lines.add('  $_preferInline');
  // lines.add('  ${struct.dartType} get asDart => (');
  // for (final m in members) {
  //   lines.add('    ${m.type.internalToDart('_.\$${members.indexOf(m) + 1}')},');
  // }
  // lines.add('  );');

  // lines.add('}');

  return lines;
}
