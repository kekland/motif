part of 'blueprint_generator.dart';

List<String> generateNode(NodeDescription description) {
  final code = <String>[];
  var className = description.baseClassName;
  className += 'Base';

  final inline = [
    for (final i in description.inputs)
      if (!i.type.multi && !i.type.enum_) i,
  ];

  final enums = [
    for (final i in description.inputs)
      if (i.type.enum_) i,
  ];

  code.add('abstract class $className extends bp.Node {');
  code.add('  $className({');
  code.add('    required super.id,');

  for (final input in inline) {
    code.add('    ${input.type.type}? ${input.name},');
  }

  for (final e in enums) {
    code.add('    this.${e.name} = ${e.defaultValue ?? e.type.defaultValue},');
  }

  code.add('  }) : super(');
  code.add('    name: \'${description.name}\',');
  code.add('    category: #${description.category},');

  if (description.inputs.isNotEmpty) {
    code.add('    inputs: [');
    for (final input in description.inputs) {
      if (input.type.enum_) continue;

      var inlineValue = input.name;
      if (input.defaultValue != null) inlineValue = '$inlineValue ?? ${input.defaultValue}';

      final args = input.type.multi ? '' : ', inlineValue: $inlineValue';
      code.add('      ${input.ioClassName}(name: \'${input.name}\'$args),');
    }
    code.add('    ],');
  } else {
    code.add('    inputs: const [],');
  }

  if (description.outputs.isNotEmpty) {
    code.add('    outputs: [');
    for (final output in description.outputs) {
      code.add('      ${output.ioClassName}(name: \'${output.name}\'),');
    }
    code.add('    ],');
  } else {
    code.add('    outputs: const [],');
  }
  code.add('  );');

  if (description.inputs.isNotEmpty) {
    code.add('');
    code.add('  late final i = (');
    for (final (i, input) in description.inputs.indexed) {
      if (input.type.enum_) continue;
      code.add('    ${input.name}: inputs[$i] as ${input.ioClassName},');
    }
    code.add('  );');
  }

  if (description.outputs.isNotEmpty) {
    code.add('');
    code.add('  late final o = (');
    for (final (i, output) in description.outputs.indexed) {
      code.add('    ${output.name}: outputs[$i] as ${output.ioClassName},');
    }
    code.add('  );');
  }

  if (enums.isNotEmpty) {
    code.add('');
    for (final e in enums) {
      code.add('  final ${e.type.type} ${e.name};');
    }
  }

  code.add('');
  code.add('  @override');
  code.add('  Iterable<Object> get properties => [');
  for (final i in description.inputs) {
    if (i.type.enum_) continue;
    code.add('    i.${i.name},');
  }
  for (final e in enums) {
    code.add('    ${e.name},');
  }
  code.add('  ];');
  code.add('');

  code.add('  @override');
  code.add('  ${description.baseClassName} copyWith({');
  code.add('    bp.NodeId? id,');
  for (final i in [...inline, ...enums]) {
    code.add('    ${i.type.type}? ${i.name},');
  }
  code.add('  }) => .new(');
  code.add('    id: id ?? this.id,');
  for (final i in inline) {
    code.add('    ${i.name}: ${i.name} ?? i.${i.name}.inlineValue,');
  }

  for (final e in enums) {
    code.add('    ${e.name}: ${e.name} ?? this.${e.name},');
  }

  code.add('  );');
  code.add('');
  code.add('  @override');
  code.add('  ${description.baseClassName} copyWithProperty(int index, Object? value) => switch(index) {');
  for (final (i, input) in description.inputs.indexed) {
    if (input.type.multi) continue;
    code.add('    $i => copyWith(${input.name}: value as ${input.type.type}),');
  }
  code.add('    _ => throw RangeError.index(index, inputs),');
  code.add('  };');

  code.add('}');

  return code;
}
