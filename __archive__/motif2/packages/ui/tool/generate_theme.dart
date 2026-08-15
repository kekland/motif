#!/usr/bin/env fvm dart
import 'dart:io';

import 'package:stack_theme/stack_theme.dart';
import 'package:ui/theme/theme_description.dart';

void main() {
  final root = Directory.fromUri(Platform.script.resolve('..'));
  final outputPath = root.uri.resolve('lib/theme/theme.g.dart').toFilePath();
  final code = generateThemeFromDescription(themeDescription);

  final file = File(outputPath);
  file.writeAsStringSync(code.join('\n'));
}