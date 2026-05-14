part of '../generator.dart';

List<String> generateOverrides(List<OverrideInfo> infos) {
  final lines = <String>[];

  final members = <String>[];
  for (final info in infos) {
    members.add('${info.type!.dartType}? ${info.dartName}');
  }

  lines.add('@wgsl.Overrides()');
  lines.add('extension type const Overrides._((${members.join(', ')}) _) {');
  lines.add('  const Overrides({${members.join(', ')}}): this._((${infos.map((e) => e.dartName).join(', ')}));');
  lines.add('');

  for (final (i, info) in infos.indexed) {
    lines.add('  ${info.type!.dartType}? get ${info.dartName} => _.\$${i + 1};');
  }

  lines.add('');
  lines.add('  List<wgpu.ConstantEntry> get entries => [');
  for (final info in infos) {
    var cast = '.toDouble()';
    if (info.type!.name == 'bool') {
      cast = ' ? 1.0 : 0.0';
    }

    lines.add('    if (${info.dartName} != null) .new(');
    lines.add('      key: \'${info.name}\',');
    lines.add('      value: ${info.dartName}!$cast,');
    lines.add('    ),');
  }
  lines.add('  ];');
  lines.add('}');

  return lines;
}
