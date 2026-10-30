#!/usr/bin/env dart

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:blueprint/blueprint_generator.dart';

import 'package:program/src/blueprints/blueprint_description.dart' as description;

void main() {
  final root = Directory.fromUri(Platform.script.resolve('..'));

  final outputBlueprintPath = root.uri.resolve('lib/src/blueprints/blueprint.g.dart').toFilePath();
  final outputCodecPath = root.uri.resolve('lib/src/blueprints/codec/blueprint_codec.g.dart').toFilePath();
  final outputProtoPath = root.uri.resolve('program.proto').toFilePath();

  final codes = generateFullBlueprint(
    nodes: description.nodes,
    sockets: description.sockets,
    prelude: [
      'import \'package:geometry/geometry.dart\';',
      'import \'package:program/program.dart\';',
      'import \'package:color/color_data.dart\';',
    ],
  );

  File(outputBlueprintPath).writeAsStringSync(codes.blueprintCode.join('\n'));
  File(outputCodecPath).writeAsStringSync(codes.codecCode.join('\n'));

  // Rewrite proto
  final generateProtoPath = root.uri.resolve('../../sync/schema/tool/generate_schema.py');
  final protoLines = File(outputProtoPath).readAsLinesSync();
  const mark = '// % GENERATOR MARK';
  final markIndex = protoLines.indexWhere((line) => line.contains(mark));
  if (markIndex == -1) throw Exception('Generator mark not found in proto file');
  protoLines.removeRange(markIndex + 1, protoLines.length);
  protoLines.add('');
  protoLines.addAll(codes.protoCode);
  File(outputProtoPath).writeAsStringSync(protoLines.join('\n'));
  print('Generated blueprint proto written to $outputProtoPath');

  final result = Process.runSync(generateProtoPath.toFilePath(), [], runInShell: true);
  print(result.stdout);
  print(result.stderr);
}
