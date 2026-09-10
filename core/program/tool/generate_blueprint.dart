#!/usr/bin/env dart

import 'dart:io';

import 'package:blueprint/generator.dart';
import 'package:program/generator/generator_description.dart';

void main() {
  final root = Directory.fromUri(Platform.script.resolve('..'));
  final outputPath = root.uri.resolve('lib/generator/generator.g.dart').toFilePath();

  final code = generateBlueprint(
    nodes: nodes,
    sockets: sockets,
    prelude: [
      'import \'package:geometry/geometry.dart\';',
      'import \'package:program/program.dart\';',
      'import \'package:color/color_data.dart\';',
    ],
  );

  File(outputPath).writeAsStringSync(code.join('\n'));

  // ignore: avoid_print
  print('Generated blueprint code written to $outputPath');
}
