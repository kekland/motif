part of 'generator.dart';

List<String> generateSocket(SocketDescription description) {
  final code = <String>[];

  // List nodes can only be used as inputs, and have ListInputSocket mixin applied.
  final isList = description.isList;

  var type = description.type;
  if (isList) {
    type = 'List<$type>';
  }

  final name = description.name;
  final inputClassName = description.inputClassName;
  final outputClassName = description.outputClassName;

  code.add('abstract class ${name}Socket extends bp.Socket<$type> {');
  code.add('  ${name}Socket({required super.name});');
  if (description.color != null) {
    code.add('');
    code.add('  @override');
    code.add('  Color? resolveColor(BuildContext context) => ${description.color};');
  }
  code.add('}');
  code.add('');

  final inputBase = 'abstract class $inputClassName extends ${name}Socket with bp.InputSocket<$type>';

  if (!isList) {
    code.add('$inputBase {');
    code.add('  $inputClassName({required super.name});');
    code.add('');
    code.add('  @override');
    code.add('  $type get defaultValue => ${description.defaultValue};');
    code.add('}');
    code.add('');
  } else {
    code.add('$inputBase, bp.ListInputSocket<${description.type}, $type> {');
    code.add('  $inputClassName({required super.name});');
    code.add('}');
    code.add('');
  }

  if (!isList) {
    code.add('abstract class $outputClassName extends ${name}Socket with bp.OutputSocket<$type> {');
    code.add('  $outputClassName({required super.name});');
    code.add('}');
    code.add('');
  }

  // Constant classes
  final constantInputClassName = description.constantInputClassName;
  final constantOutputClassName = description.constantOutputClassName;

  code.add('class $constantInputClassName extends $inputClassName with bp.ConstantSocket<$type> {');
  code.add('  $constantInputClassName({required super.name});');
  code.add('}');
  code.add('');

  if (!isList) {
    code.add('class $constantOutputClassName extends $outputClassName with bp.ConstantSocket<$type> {');
    code.add('  $constantOutputClassName({required super.name});');
    code.add('}');
    code.add('');
  }

  // Dynamic classes
  final dynamicInputClassName = description.dynamicInputClassName;
  final dynamicOutputClassName = description.dynamicOutputClassName;

  code.add('class $dynamicInputClassName extends $inputClassName with bp.DynamicSocket<$type> {');
  code.add('  $dynamicInputClassName({required super.name});');
  code.add('}');
  code.add('');

  if (!isList) {
    code.add('class $dynamicOutputClassName extends $outputClassName with bp.DynamicSocket<$type> {');
    code.add('  $dynamicOutputClassName({required super.name});');
    code.add('}');
  }

  return code;
}
