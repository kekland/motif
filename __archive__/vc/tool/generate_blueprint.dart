#!/usr/bin/env dart

import 'dart:io';

import 'package:blueprint/generator.dart';
import '../lib/generator/blueprint_description.dart';

void main() {
  final root = Directory.fromUri(Platform.script.resolve('..'));
  final outputPath = root.uri.resolve('lib/generator/blueprint.g.dart').toFilePath();

  final code = generateBlueprint(
    nodes: nodes,
    sockets: sockets,
    prelude: [
      'import \'package:vc/vc.dart\';',
      'import \'package:geometry/geometry.dart\';',
      'import \'package:ui/ui.dart\';',
    ],
  );

  File(outputPath).writeAsStringSync(code.join('\n'));

  // ignore: avoid_print
  print('Generated blueprint code written to $outputPath');
}
