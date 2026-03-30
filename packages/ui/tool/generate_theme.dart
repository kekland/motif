#!/usr/bin/env fvm dart
import 'dart:io';

import 'package:stack_theme/stack_theme.dart';
import 'package:ui/theme/theme_description.dart';

void main() {
  final outputPath = 'lib/ui/theme/theme.g.dart';
  final code = generateThemeFromDescription(themeDescription);

  final file = File(outputPath);
  file.writeAsStringSync(code.join('\n'));
}