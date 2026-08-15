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
    dynamicSchemeVariant: dynamicSchemeVariant ?? DynamicSchemeVariant.content,
    contrastLevel: contrastLevel ?? 0.15,
  );

  final divider = _mixColor(scheme.surface, scheme.onSurface, 0.12);
  final secondaryMixRatio = brightness == Brightness.light ? 0.08 : 0.24;

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
      background: seedColor,
      foreground: scheme.onPrimary,
      tint: scheme.surfaceTint,
      divider: divider,
    ),
    secondary: .new(
      background: _mixColor(scheme.surfaceContainer, seedColor, secondaryMixRatio),
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

  final colors = (
    surface: surfaceColors,
    display: displayColors,
    accent: accentColors,
    danger: dangerColors,
    divider: divider,
    tint: scheme.surfaceTint,
  );

  return (colors, scheme);
}
