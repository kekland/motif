part of 'generator.dart';

List<String> generateNode(NodeDescription description) {
  final code = <String>[];
  var className = description.baseClassName;
  className += 'Base';

  code.add('abstract class $className extends bp.Node {');
  code.add('  $className(): super(');
  code.add('    name: \'${description.name}\',');

  if (description.inputs.isNotEmpty) {
    code.add('    inputs: [');
    for (final input in description.inputs) {
      code.add('      ${input.ioClassName}(name: \'${input.name}\'),');
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

  if (description.color != null) {
    code.add('');
    code.add('  @override');
    code.add('  Color? resolveColor(BuildContext context) => ${description.color};');
  }

  code.add('}');

  return code;
}
