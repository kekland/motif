import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'color_definitions.dart';
import 'typography_definitions.dart';
import 'color.dart';
import 'typography.dart';

export 'augmentations.dart';
export 'color_definitions.dart';
export 'color.dart';
export 'typography_definitions.dart';
export 'typography.dart';
export 'utils.dart';

typedef AppTheme = ({
  AppColors colors,
  AppTypography typography,
  AppThemePlatform platform,
  AppThemeDevice device,
  Brightness brightness,
  ColorScheme rawColorScheme,
});

enum AppThemePlatform {
  material,
  cupertino,
}

enum AppThemeDevice {
  mobile,
  desktop,
}

AppTheme generateAppTheme({
  required Color seedColor,
  required Brightness brightness,
  AppThemePlatform? platform,
  AppThemeDevice? device,
  DynamicSchemeVariant? dynamicSchemeVariant,
  double? contrastLevel,
}) {
  final (colors, scheme) = generateAppColors(
    seedColor: seedColor,
    brightness: brightness,
    dynamicSchemeVariant: dynamicSchemeVariant,
    contrastLevel: contrastLevel,
  );

  late final AppThemePlatform _platform;
  if (platform != null) {
    _platform = platform;
  } else {
    _platform = switch (defaultTargetPlatform) {
      .iOS || .macOS => .cupertino,
      _ => .material,
    };
  }

  late final AppThemeDevice _device;
  if (device != null) {
    _device = device;
  } else {
    _device = switch (defaultTargetPlatform) {
      .iOS || .android || .fuchsia => .mobile,
      _ => .desktop,
    };
  }

  return (
    platform: _platform,
    device: _device,
    brightness: brightness,
    colors: colors,
    typography: switch (_platform) {
      .material => generateMaterialTypography(colors),
      .cupertino => generateCupertinoTypography(colors),
    },
    rawColorScheme: scheme,
  );
}
