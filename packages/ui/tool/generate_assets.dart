#!/usr/bin/env fvm dart

import 'dart:io';

import 'package:stack_assets/stack_assets.dart';

Future<void> main() async {
  final icons = <IconData>[
    .new('square', 'Symbols.square_rounded'),
    .new('circle', 'Symbols.circle_rounded'),
    .new('container', 'Symbols.cards_rounded'),
    .new('chevronLeft', 'Symbols.chevron_left_rounded'),
    .new('chevronRight', 'Symbols.chevron_right_rounded'),
    .new('chevronUp', 'Symbols.keyboard_arrow_up_rounded'),
    .new('chevronDown', 'Symbols.keyboard_arrow_down_rounded'),
    .new('rotateCw', 'Symbols.rotate_90_degrees_cw_rounded'),
    .new('rotateCcw', 'Symbols.rotate_90_degrees_ccw_rounded'),
    .new('move', 'Symbols.drag_pan_rounded'),
    .new('marquee', 'Symbols.select_rounded'),
    .new('close', 'Symbols.close_rounded'),
    .new('layoutSizeFixed', 'Symbols.lock_rounded'),
    .new('layoutSizeNonFixed', 'Symbols.lock_open_rounded'),
    .new('layoutSizeContain', 'Symbols.compress_rounded'),
    .new('layoutSizeExpand', 'Symbols.expand_rounded'),
    .new('borderRadius', 'Symbols.rounded_corner_rounded'),
    .new('star', 'Symbols.star_rounded'),
    .new('polygon', 'Symbols.pentagon_rounded'),
    .new('check', 'Symbols.check_rounded'),
    .new('eyedropper', 'Symbols.dropper_eye_rounded'),
    .new('pen', 'Symbols.stylus_fountain_pen_rounded'),
    .new('pencil', 'Symbols.draw_rounded'),
    .new('fill', 'Symbols.colors_rounded'),
    .new('weight', 'Symbols.line_weight_rounded'),
    .new('eraser', 'Symbols.ink_eraser_rounded'),
    .new('delete', 'Symbols.delete_rounded'),
    .new('dragHandle', 'Symbols.drag_indicator_rounded'),
    .new('topology', 'Symbols.hub_rounded'),
    .new('squiggly', 'Symbols.gesture_rounded'),
    .new('tune', 'Symbols.tune_rounded'),
    .new('add', 'Symbols.add_2_rounded'),
    .new('wrench', 'Symbols.build_rounded'),
    .new('applyModifier', 'Symbols.shape_line_rounded'),
    .new('visibility', 'Symbols.visibility_rounded'),
    .new('visibilityOff', 'Symbols.visibility_off_rounded'),
    .new('mirror', 'Symbols.flip_rounded'),
    .new('generator', 'Symbols.graph_4_rounded'),
    .new('symbols', 'Symbols.category_rounded'),
    .new('unknown', 'Symbols.help_rounded'),
    .new('stacks', 'Symbols.stacks_rounded'),
    .new('world', 'Symbols.public_rounded'),
    .new('glue', 'Symbols.merge_rounded'),
    .new('lock', 'Symbols.lock_rounded'),
    .new('home', 'Symbols.home_rounded'),
    .new('animation', 'Symbols.animation_rounded'),
    .new('variable', 'Symbols.style_rounded'),
    .new('checkbox', 'Symbols.check_box_outline_blank_rounded'),
    .new('checkbox_checked', 'Symbols.check_box_rounded'),
    .new('fillet', 'Symbols.rounded_corner_rounded'),
    .new('commander', 'Symbols.call_to_action_rounded'),
    .new('group', 'Symbols.folder_rounded'),
    .new('tree', 'Symbols.account_tree_rounded'),
    .new('program', 'Symbols.code_blocks_rounded'),
    .new('open', 'Symbols.folder_open_rounded'),
    .new('document', 'Symbols.design_services_rounded'),
    .new('join', 'Symbols.link_2_rounded'),
    .new('folder', 'Symbols.folder_rounded'),
    .new('cloud', 'Symbols.cloud_rounded'),
    .new('refresh', 'Symbols.refresh_rounded'),
    .new('copy', 'Symbols.content_copy_rounded'),
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
