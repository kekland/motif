#!/usr/bin/env dart

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:blueprint/blueprint_generator.dart';
import 'package:program/src/generator/generator_description.dart';

void main() {
  final root = Directory.fromUri(Platform.script.resolve('..'));
  final outputPath = root.uri.resolve('lib/src/generator/generator.g.dart').toFilePath();
  final outputCodecPath = root.uri.resolve('lib/src/generator/generator.codec.g.dart').toFilePath();
  final outputProtoPath = root.uri.resolve('program.proto').toFilePath();

  final generateProtoPath = root.uri.resolve('../../sync/schema/tool/generate_schema.py');

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
  File(outputCodecPath).writeAsStringSync(generateBlueprintCodec(nodes: nodes, sockets: sockets).join('\n'));

  final protoCode = File(outputProtoPath).readAsLinesSync();
  const mark = '// % GENERATOR MARK';
  final markIndex = protoCode.indexWhere((line) => line.contains(mark));
  if (markIndex == -1) throw Exception('Generator mark not found in proto file');
  protoCode.removeRange(markIndex + 1, protoCode.length);
  protoCode.add('');
  protoCode.addAll(generateBlueprintProto(nodes: nodes, sockets: sockets));
  File(outputProtoPath).writeAsStringSync(protoCode.join('\n'));

  print('Generated blueprint code written to $outputPath');
  print('Generated blueprint proto written to $outputProtoPath');
  print('Generated blueprint codec written to $outputCodecPath');

  final result = Process.runSync(generateProtoPath.toFilePath(), [], runInShell: true);
  print(result.stdout);
  print(result.stderr);
}
