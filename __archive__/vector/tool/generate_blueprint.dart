// #!/usr/bin/env dart

// import 'dart:io';

// import 'package:blueprint/generator.dart';
// import '../__old__/blueprint/blueprint_description.dart';

// void main() {
//   final root = Directory.fromUri(Platform.script.resolve('..'));
//   final outputPath = root.uri.resolve('lib/blueprint/blueprint.g.dart').toFilePath();

//   final code = generateBlueprint(blocks: blocks);
//   File(outputPath).writeAsStringSync(code.join('\n'));

//   // ignore: avoid_print
//   print('Generated blueprint code written to $outputPath');
// }
