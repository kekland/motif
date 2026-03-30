#!/usr/bin/env fvm dart

import 'dart:io';

import 'package:stack_assets/stack_assets.dart';

Future<void> main() async {
  final icons = <IconData>[
    .new('square', 'Symbols.square_rounded'),
    .new('circle', 'Symbols.circle_rounded'),
    .new('container', 'Symbols.border_all_rounded'),
    .new('chevronLeft', 'Symbols.chevron_left_rounded'),
    .new('chevronRight', 'Symbols.chevron_right_rounded'),
    .new('rotateCw', 'Symbols.rotate_90_degrees_cw_rounded'),
    .new('rotateCcw', 'Symbols.rotate_90_degrees_ccw_rounded'),
    .new('move', 'Symbols.drag_pan_rounded'),
    .new('marquee', 'Symbols.select_rounded'),
    .new('close', 'Symbols.close_rounded'),
    .new('layoutSizeFixed', 'Symbols.lock_rounded'),
    .new('layoutSizeNonFixed', 'Symbols.lock_open_rounded'),
    .new('layoutSizeContain', 'Symbols.compress_rounded'),
    .new('layoutSizeExpand', 'Symbols.expand_rounded'),
  ];

  final root = Directory.fromUri(Platform.script.resolve('..'));

  final manifest = AssetManifest(
    rootDirectory: root,
    assetsDirectory: Directory.fromUri(root.uri.resolve('assets')),
    icons: icons,
    inputDirectoryName: 'dev',
    outputDirectoryName: 'gen',
    package: 'ui',
    prelude: ['import \'package:ui/ui.dart\';'],
  );

  final code = await generateAssets(manifest);
  final outputFile = File.fromUri(root.uri.resolve('lib/assets/assets.g.dart'));
  outputFile.createSync(recursive: true);
  outputFile.writeAsStringSync(code.join('\n'));
}
