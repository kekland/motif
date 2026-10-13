part of 'blueprint_generator.dart';

String _camelToSnake(String input) {
  final buffer = StringBuffer();
  for (var i = 0; i < input.length; i++) {
    final char = input[i];
    if (char.toUpperCase() == char && i > 0) {
      buffer.write('_');
    }
    buffer.write(char.toLowerCase());
  }
  return buffer.toString();
}

String _lowerCamel(String input) {
  if (input.isEmpty) return input;
  return input[0].toLowerCase() + input.substring(1);
}

String _upperCamel(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

List<String> generateBlueprintProto({
  List<NodeDescription> nodes = const [],
}) {
  final code = <String>[
    'message Node {',
    '  NodeId id = 1;',
    '',
    '  oneof kind {',
  ];

  final resolved = <String, List<(String, String)>>{};

  for (final n in nodes) {
    final fields = <(String, String)>[];

    for (final input in n.inputs) {
      if (input.type.multi) continue;
      fields.add((input.type.type, input.name));
    }

    resolved[n.name] = fields;
  }

  for (final (i, entry) in resolved.entries.indexed) {
    code.add('    ${entry.key} ${_camelToSnake(entry.key)} = ${i + 10};');
  }

  code.add('  }');
  code.add('');

  for (final entry in resolved.entries) {
    code.add('  message ${entry.key} {');
    for (final (i, (type, name)) in entry.value.indexed) {
      final pbType = switch (type) {
        'int' => 'int32',
        _ => type,
      };

      code.add('    optional $pbType ${_camelToSnake(name)} = ${i + 1};');
    }
    code.add('  }');
    code.add('');
  }

  code.removeLast();
  code.add('}');

  return code;
}

List<String> generateBlueprintCodec({
  List<NodeDescription> nodes = const [],
}) {
  final code = <String>[
    'import \'package:program/program.dart\';',
    'import \'package:blueprint/core.dart\';',
    'import \'package:schema/program.dart\' as gen;',
    '',
  ];

  final passthroughTypes = <String>{'int', 'double', 'String', 'bool'};

  for (final node in nodes) {
    final nodeName = _lowerCamel(node.name);
    code.add('final _${_lowerCamel(node.name)}Codec = \$codec<${node.name}Node, gen.Node>(');
    code.add('  decoder: (v) => .new(');
    code.add('    id: v.id.decode(),');

    for (final input in node.inputs) {
      if (input.type.multi) continue;

      final name = input.name;
      final isPassthrough = passthroughTypes.contains(input.type.type);
      if (isPassthrough) {
        code.add('    $name: \$opt(v.$nodeName.has${_upperCamel(name)}, () => v.$nodeName.$name),');
      } else {
        code.add('    $name: \$opt(v.$nodeName.has${_upperCamel(name)}, () => v.$nodeName.$name.decode()),');
      }
    }
    code.add('  ),');
    code.add('  encoder: (v) => .new(');
    code.add('    id: v.id.encode(),');
    code.add('    $nodeName: .new(');
    for (final input in node.inputs) {
      if (input.type.multi) continue;

      final name = input.name;
      final isPassthrough = passthroughTypes.contains(input.type.type);
      if (isPassthrough) {
        code.add('      $name: v.i.$name.inlineValue,');
      } else {
        code.add('      $name: v.i.$name.inlineValue.encode(),');
      }
    }
    code.add('    ),');
    code.add('  ),');
    code.add(');');
    code.add('');
  }

  code.add('extension NodeEncode on Node { gen.Node encode() => _nodeCodec.encode(this); }');
  code.add('extension NodeDecode on gen.Node { Node decode() => _nodeCodec.decode(this); }');
  code.add('');

  code.add('final _nodeCodec = \$codec<Node, gen.Node>(');
  code.add('  decoder: (v) => switch(v.whichKind()) {');

  for (final node in nodes) {
    var name = _lowerCamel(node.name);
    if (name == 'index') name = 'index_';

    code.add('    .$name  => _${_lowerCamel(node.name)}Codec.decode(v),');
  }
  code.add('    _ => throw ArgumentError(),');
  code.add('  },');
  code.add('  encoder: (v) => switch(v) {');

  for (final node in nodes) {
    var name = _lowerCamel(node.name);
    if (name == 'index') name = 'index_';

    code.add('    ${node.name}Node v => _${_lowerCamel(node.name)}Codec.encode(v),');
  }
  code.add('    _ => throw ArgumentError(),');
  code.add('  },');
  code.add(');');
  code.add('');

  return code;
}
