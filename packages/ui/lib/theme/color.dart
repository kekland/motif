import 'package:flutter/material.dart';

import 'theme.dart';

Color _mixColor(Color background, Color foreground, double opacity) => Color.lerp(background, foreground, opacity)!;

(AppColors, ColorScheme) generateAppColors({
  required Color seedColor,
  required Brightness brightness,
  DynamicSchemeVariant? dynamicSchemeVariant,
  double? contrastLevel,
}) {
  final scheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
    dynamicSchemeVariant: dynamicSchemeVariant ?? .content,
    contrastLevel: contrastLevel ?? 0.6,
  );

  final divider = _mixColor(scheme.surface, scheme.onSurface, 0.12);
  final secondaryMixRatio = brightness == Brightness.light ? 0.08 : 0.12;

  final AppDisplayColors displayColors = (
    primary: scheme.onSurface,
    secondary: _mixColor(scheme.surface, scheme.onSurface, 0.7),
    tertiary: _mixColor(scheme.surface, scheme.onSurface, 0.5),
  );

  final AppSurfaceColors surfaceColors = (
    primary: .new(
      background: scheme.surface,
      foreground: displayColors.primary,
      tint: scheme.surfaceTint,
      divider: divider,
    ),
    secondary: .new(
      background: scheme.surfaceContainerLow,
      foreground: displayColors.primary,
      tint: scheme.surfaceTint,
      divider: divider,
    ),
    tertiary: .new(
      background: scheme.surfaceDim,
      foreground: displayColors.primary,
      tint: scheme.surfaceTint,
      divider: divider,
    ),
    canvas: .new(
      background: scheme.surfaceContainerLowest,
      foreground: _mixColor(scheme.surfaceContainerLowest, scheme.onSurface, 0.25),
      tint: scheme.surfaceTint,
      divider: divider,
    ),
  );

  final AppAccentColors accentColors = (
    primary: .new(
      background: scheme.primary,
      foreground: scheme.onPrimary,
      tint: scheme.surfaceTint,
      divider: divider,
    ),
    secondary: .new(
      background: _mixColor(scheme.surfaceContainer, scheme.primary, secondaryMixRatio),
      foreground: scheme.primary,
      tint: scheme.surfaceTint,
      divider: divider,
    ),
  );

  final AppDangerColors dangerColors = (
    primary: .new(
      background: scheme.errorContainer,
      foreground: scheme.onErrorContainer,
      divider: divider,
      tint: scheme.surfaceTint,
    ),
    secondary: .new(
      background: _mixColor(scheme.surfaceContainer, scheme.error, secondaryMixRatio),
      foreground: scheme.error,
      tint: scheme.surfaceTint,
      divider: divider,
    ),
  );

  final AppColors colors = (
    surface: surfaceColors,
    display: displayColors,
    accent: accentColors,
    danger: dangerColors,
    selection: (
      primary: scheme.primaryContainer,
      secondary: _mixColor(surfaceColors.tertiary.background, scheme.primaryContainer, 0.25),
    ),
    divider: divider,
    tint: scheme.surfaceTint,
    shadow: scheme.shadow,
    normal: switch (brightness) {
      .light => Colors.white,
      .dark => Colors.black,
    },
    inverse: switch (brightness) {
      .light => Colors.black,
      .dark => Colors.white,
    },
    blueprint: _generateBlueprintColors(seedColor, brightness),
  );

  return (colors, scheme);
}

AppBlueprintColors _generateBlueprintColors(Color seedColor, Brightness brightness) {
  final _int = Color(0xFF5E239D);
  final _float = Color(0xFF1B998B);
  final _vector = Color(0xFF5398BE);
  final _geometry = seedColor;
  final _math = Color(0xFF5398BE);

  Color _resolve(Color c) {
    final scheme = ColorScheme.fromSeed(seedColor: c, brightness: brightness);
    return scheme.primaryContainer;
  }

  return (
    int: _int,
    float: _float,
    vector: _vector,
    geometry: _resolve(_geometry),
    math: _math,
  );
}
