#!/usr/bin/env -S fvm dart run

import 'dart:io';

import 'package:js_interop_gen/src/cli.dart' as cli;

void main() async {
  final rootDir = Platform.script.resolve('../');
  final jsInteropGen = rootDir.resolve('build/web/js_interop_gen/lib/src').toFilePath();
  final bcdPath = rootDir
      .resolve('build/web/web_generator/node_modules/@mdn/browser-compat-data/data.json')
      .toFilePath();

  final shimIdl = rootDir.resolve('tool/webgpu_shim.idl').toFilePath();
  final webgpuIdl = rootDir.resolve('tool/webgpu.idl').toFilePath();

  await cli.runProc('npm', ['install'], workingDirectory: jsInteropGen);
  await cli.compileDartMain(langVersion: '3.13.0', dir: jsInteropGen);
  await cli.runNode([
    'main.mjs',
    '--idl',
    '--generate-all',
    '--bcd-json=$bcdPath',
    '--input=$shimIdl',
    '--input=$webgpuIdl',
    '--output=.',
  ], workingDirectory: jsInteropGen);

  final out = rootDir.resolve('lib/src/web/webgpu.g.dart').toFilePath();
  await File('$jsInteropGen/webgpu.dart').copy(out);

  // fix import
  var content = await File(out).readAsString();
  content = content.replaceAll(
    "import 'webgpu_shim.dart';",
    "import 'package:web/web.dart';",
  );

  content = content.replaceAll(
    'extension type GPU._',
    'extension type GPU',
  );

  await File(out).writeAsString(content);
}
