import 'package:flutter/foundation.dart';
import 'package:ui/ui.dart';

/* Typography */

AppTypography generateMaterialTypography(AppColors colors) {
  const base = TextStyle(
    fontFamily: 'Roboto',
    leadingDistribution: TextLeadingDistribution.even,
  );

  return AppTypographyGenerator.generate(
    colors,
    largeTitle: base.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 34.0,
      height: 41.0 / 34.0,
      letterSpacing: 0.0,
    ),
    title1Bold: base.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 28.0,
      height: 34.0 / 28.0,
      letterSpacing: 0.0,
    ),
    title1Regular: base.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 28.0,
      height: 34.0 / 28.0,
      letterSpacing: 0.0,
    ),
    title2Bold: base.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 22.0,
      height: 28.0 / 22.0,
      letterSpacing: 0.0,
    ),
    title2Regular: base.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 22.0,
      height: 28.0 / 22.0,
      letterSpacing: 0.0,
    ),
    subtitle1Bold: base.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
      height: 25.0 / 20.0,
      letterSpacing: 0.0,
    ),
    subtitle1Regular: base.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 20.0,
      height: 25.0 / 20.0,
      letterSpacing: 0.0,
    ),
    body1Bold: base.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 17.0,
      height: 23.0 / 17.0,
      letterSpacing: 0.0,
    ),
    body1Regular: base.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 17.0,
      height: 23.0 / 17.0,
      letterSpacing: 0.0,
    ),
    caption1Bold: base.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 15.0,
      height: 19.0 / 15.0,
      letterSpacing: 0.0,
    ),
    caption1Regular: base.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 15.0,
      height: 19.0 / 15.0,
      letterSpacing: 0.0,
    ),
    caption2Bold: base.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 13.0,
      height: 17.0 / 13.0,
      letterSpacing: 0.0,
    ),
    caption2Regular: base.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 13.0,
      height: 17.0 / 13.0,
      letterSpacing: 0.0,
    ),
    caption3Bold: base.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 11.0,
      height: 15.0 / 11.0,
      letterSpacing: 0.0,
    ),
    caption3Regular: base.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 11.0,
      height: 15.0 / 11.0,
      letterSpacing: 0.0,
    ),
    footnoteBold: base.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 10.0,
      height: 16.0 / 10.0,
      letterSpacing: 0.2,
    ),
    footnoteRegular: base.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 10.0,
      height: 16.0 / 10.0,
      letterSpacing: 0.2,
    ),
  );
}

AppTypography generateCupertinoTypography(AppColors colors) {
  const fallback = [
    '.AppleSystemUIFont',
    'Apple Color Emoji',
  ];

  const base = TextStyle(
    leadingDistribution: TextLeadingDistribution.even,
  );

  final baseDisplay = base.copyWith(
    fontFamily: 'CupertinoSystemDisplay',
    fontFamilyFallback: [
      'SF Pro Display',
      ...fallback,
    ],
  );

  final baseText = base.copyWith(
    fontFamily: 'CupertinoSystemText',
    fontFamilyFallback: [
      'SF Pro Text',
      ...fallback,
    ],
  );

  return AppTypographyGenerator.generate(
    colors,
    largeTitle: baseDisplay.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 34.0,
      height: 41.0 / 34.0,
      letterSpacing: 0.4,
    ),
    title1Bold: baseDisplay.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 28.0,
      height: 34.0 / 28.0,
      letterSpacing: 0.38,
    ),
    title1Regular: baseDisplay.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 28.0,
      height: 34.0 / 28.0,
      letterSpacing: 0.38,
    ),
    title2Bold: baseDisplay.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 22.0,
      height: 28.0 / 22.0,
      letterSpacing: 0.28,
    ),
    title2Regular: baseDisplay.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 22.0,
      height: 28.0 / 22.0,
      letterSpacing: 0.37,
    ),
    subtitle1Bold: baseDisplay.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
      height: 25.0 / 20.0,
      letterSpacing: 0.36,
    ),
    subtitle1Regular: baseDisplay.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 20.0,
      height: 25.0 / 20.0,
      letterSpacing: 0.5,
    ),
    body1Bold: baseText.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 17.0,
      height: 23.0 / 17.0,
      letterSpacing: -0.43,
    ),
    body1Regular: baseText.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 17.0,
      height: 23.0 / 17.0,
      letterSpacing: -0.43,
    ),
    caption1Bold: baseText.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 15.0,
      height: 19.0 / 15.0,
      letterSpacing: -0.23,
    ),
    caption1Regular: baseText.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 15.0,
      height: 19.0 / 15.0,
      letterSpacing: -0.23,
    ),
    caption2Bold: baseText.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 13.0,
      height: 17.0 / 13.0,
      letterSpacing: -0.08,
    ),
    caption2Regular: baseText.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 13.0,
      height: 17.0 / 13.0,
      letterSpacing: -0.08,
    ),
    caption3Bold: baseText.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 11.0,
      height: 15.0 / 11.0,
      letterSpacing: 0.06,
    ),
    caption3Regular: baseText.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 11.0,
      height: 15.0 / 11.0,
      letterSpacing: 0.06,
    ),
    footnoteBold: baseText.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 10.0,
      height: 16.0 / 10.0,
      letterSpacing: 0.12,
    ),
    footnoteRegular: baseText.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 10.0,
      height: 16.0 / 10.0,
      letterSpacing: 0.12,
    ),
  );
}

/* Animations */

const AppAnimations materialAnimations = (
  spatialFast: AnimationStyle(
    duration: Duration(milliseconds: 350),
    curve: Cubic(0.42, 1.67, 0.21, 0.90),
  ),
  spatialDefault: AnimationStyle(
    duration: Duration(milliseconds: 500),
    curve: Cubic(0.38, 1.21, 0.22, 1.00),
  ),
  spatialSlow: AnimationStyle(
    duration: Duration(milliseconds: 650),
    curve: Cubic(0.39, 1.29, 0.35, 0.98),
  ),
  effectFast: AnimationStyle(
    duration: Duration(milliseconds: 150),
    curve: Cubic(0.31, 0.94, 0.34, 1.00),
  ),
  effectDefault: AnimationStyle(
    duration: Duration(milliseconds: 200),
    curve: Cubic(0.34, 0.80, 0.34, 1.00),
  ),
  effectSlow: AnimationStyle(
    duration: Duration(milliseconds: 300),
    curve: Cubic(0.34, 0.88, 0.34, 1.00),
  ),
);

const AppAnimations cupertinoAnimations = (
  spatialFast: AnimationStyle(
    duration: Duration(milliseconds: 350),
    curve: Cubic(0.42, 1.67, 0.21, 0.90),
  ),
  spatialDefault: AnimationStyle(
    duration: Duration(milliseconds: 500),
    curve: Cubic(0.38, 1.21, 0.22, 1.00),
  ),
  spatialSlow: AnimationStyle(
    duration: Duration(milliseconds: 650),
    curve: Cubic(0.39, 1.29, 0.35, 0.98),
  ),
  effectFast: AnimationStyle(
    duration: Duration(milliseconds: 150),
    curve: Cubic(0.31, 0.94, 0.34, 1.00),
  ),
  effectDefault: AnimationStyle(
    duration: Duration(milliseconds: 200),
    curve: Cubic(0.34, 0.80, 0.34, 1.00),
  ),
  effectSlow: AnimationStyle(
    duration: Duration(milliseconds: 300),
    curve: Cubic(0.34, 0.88, 0.34, 1.00),
  ),
);

/* Colors */

Color _mixColor(Color background, Color foreground, double opacity) => Color.lerp(background, foreground, opacity)!;

AppColors generateAppColors({
  required Color seedColor,
  required Brightness brightness,
  DynamicSchemeVariant? dynamicSchemeVariant,
  double? contrastLevel,
}) {
  final scheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
    dynamicSchemeVariant: dynamicSchemeVariant ?? DynamicSchemeVariant.content,
    contrastLevel: contrastLevel ?? 0.35,
  );

  final secondaryMixRatio = brightness == Brightness.light ? 0.08 : 0.24;

  Color getSurfaceHoverColor(Color baseColor) => _mixColor(baseColor, scheme.surfaceTint, 0.08);
  Color getAccentHoverColor(Color baseColor) => _mixColor(baseColor, seedColor, 0.12);

  final isLight = brightness == Brightness.light;
  final background = scheme.surface;
  final seed = seedColor;
  final SurfaceColors surfaceColors = (
    primary: .new(
      idle: .new(
        background: background,
        foreground: scheme.onSurface,
      ),
      disabled: .new(
        background: background,
        foreground: _mixColor(background, scheme.onSurface, 0.5),
      ),
      hovered: .new(
        background: getSurfaceHoverColor(background),
        foreground: scheme.onSurface,
      ),
    ),
    secondary: .new(
      idle: .new(
        background: isLight ? scheme.surfaceContainer : scheme.surfaceContainerLow,
        foreground: scheme.onSurface,
      ),
      disabled: .new(
        background: _mixColor(background, isLight ? scheme.surfaceContainer : scheme.surfaceContainerLow, 0.5),
        foreground: _mixColor(background, scheme.onSurface, 0.75),
      ),
      hovered: .new(
        background: getSurfaceHoverColor(isLight ? scheme.surfaceContainer : scheme.surfaceContainerLow),
        foreground: scheme.onSurface,
      ),
    ),
    tertiary: .new(
      idle: .new(
        background: scheme.surfaceContainerLowest,
        foreground: scheme.onSurface,
      ),
      disabled: .new(
        background: _mixColor(background, scheme.surfaceContainerLowest, 0.5),
        foreground: _mixColor(background, scheme.onSurface, 0.75),
      ),
      hovered: .new(
        background: getSurfaceHoverColor(scheme.surfaceContainerLowest),
        foreground: scheme.onSurface,
      ),
    ),
  );

  final accentPrimary = seed;
  final onAccentPrimary = scheme.onPrimary;

  final accentSecondary = _mixColor(scheme.surfaceContainer, seedColor, secondaryMixRatio);
  final onAccentSecondary = scheme.primary;

  final accentTertiary = _mixColor(background, seedColor, isLight ? secondaryMixRatio : secondaryMixRatio / 2.0);
  final onAccentTertiary = scheme.primary;

  final AccentColors accentColors = (
    primary: .new(
      idle: .new(
        background: accentPrimary,
        foreground: onAccentPrimary,
      ),
      hovered: .new(
        background: getAccentHoverColor(accentPrimary),
        foreground: onAccentPrimary,
      ),
      disabled: .new(
        background: _mixColor(background, scheme.surfaceContainerLow, 0.5),
        foreground: _mixColor(background, scheme.onSurface, 0.75),
      ),
    ),
    secondary: .new(
      idle: .new(
        background: accentSecondary,
        foreground: onAccentSecondary,
      ),
      hovered: .new(
        background: getAccentHoverColor(accentSecondary),
        foreground: onAccentSecondary,
      ),
      disabled: .new(
        background: _mixColor(background, scheme.surfaceContainerLow, 0.5),
        foreground: _mixColor(background, scheme.onSurface, 0.75),
      ),
    ),
    tertiary: .new(
      idle: .new(
        background: accentTertiary,
        foreground: onAccentTertiary,
      ),
      hovered: .new(
        background: getAccentHoverColor(accentTertiary),
        foreground: onAccentTertiary,
      ),
      disabled: .new(
        background: _mixColor(background, scheme.surfaceContainerLow, 0.5),
        foreground: _mixColor(background, scheme.onSurface, 0.75),
      ),
    ),
  );

  final dangerPrimary = scheme.errorContainer;
  final onDangerPrimary = scheme.onErrorContainer;
  final dangerSecondary = _mixColor(background, scheme.errorContainer, 0.16);
  final onDangerSecondary = scheme.error;

  final DangerColors dangerColors = (
    primary: .new(
      idle: .new(
        background: dangerPrimary,
        foreground: onDangerPrimary,
      ),
      hovered: .new(
        background: getAccentHoverColor(dangerPrimary),
        foreground: onDangerPrimary,
      ),
      disabled: .new(
        background: _mixColor(background, dangerPrimary, 0.08),
        foreground: _mixColor(background, onDangerPrimary, 0.5),
      ),
    ),
    secondary: .new(
      idle: .new(
        background: dangerSecondary,
        foreground: onDangerSecondary,
      ),
      hovered: .new(
        background: getAccentHoverColor(dangerSecondary),
        foreground: onDangerSecondary,
      ),
      disabled: .new(
        background: _mixColor(background, dangerSecondary, 0.08),
        foreground: _mixColor(background, onDangerSecondary, 0.5),
      ),
    ),
  );

  return (
    surface: surfaceColors,
    accent: accentColors,
    danger: dangerColors,
    display: (
      primary: scheme.onSurface,
      secondary: _mixColor(background, scheme.onSurface, 0.8),
      tertiary: _mixColor(background, scheme.onSurface, 0.55),
    ),
    divider: _mixColor(background, scheme.onSurface, 0.12),
    normal: brightness == Brightness.light ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
    inverse: brightness == Brightness.light ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
    gestureOverlay: brightness == Brightness.light
        ? Colors.black.withScaledAlpha(0.12)
        : Colors.white.withScaledAlpha(0.12),
    scrim: brightness == Brightness.light ? Colors.black.withScaledAlpha(0.32) : Colors.white.withScaledAlpha(0.32),
    shadow: scheme.shadow,
  );
}

/* Final */

AppTheme generateAppTheme({
  required Color seedColor,
  required Brightness brightness,
  ThemePlatform? platform,
  DynamicSchemeVariant? dynamicSchemeVariant,
  double? contrastLevel,
}) {
  final colors = generateAppColors(
    seedColor: seedColor,
    brightness: brightness,
    dynamicSchemeVariant: dynamicSchemeVariant,
    contrastLevel: contrastLevel,
  );

  final _platform =
      platform ??
      switch (defaultTargetPlatform) {
        TargetPlatform.iOS || TargetPlatform.macOS => ThemePlatform.cupertino,
        _ => ThemePlatform.material,
      };

  return (
    colors: colors,
    brightness: brightness,
    platform: _platform,
    typography: switch (_platform) {
      .cupertino => generateCupertinoTypography(colors),
      .material => generateMaterialTypography(colors),
    },
    animations: switch (_platform) {
      .cupertino => cupertinoAnimations,
      .material => materialAnimations,
    },
    shadows: (
      window: [
        .new(
          color: colors.shadow.withScaledAlpha(0.1),
          offset: .new(0.0, 8.0),
          blurRadius: 12.0,
        ),
      ],
      small: [
        .new(
          color: colors.shadow.withScaledAlpha(0.1),
          offset: .new(0.0, 2.0),
          blurRadius: 4.0,
        ),
      ],
    ),
  );
}
