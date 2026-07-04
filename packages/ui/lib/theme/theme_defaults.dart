import 'package:flutter/foundation.dart';
import 'package:ui/ui.dart';

/* Typography */

AppTypography generateMaterialTypography(AppColors colors) {
  const base = TextStyle(
    fontFamily: 'Roboto Mono',
    fontWeight: .w300,
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
    title: base.copyWith(
      fontSize: 22.0,
      height: 28.0 / 22.0,
      letterSpacing: 0.0,
    ),
    subtitle: base.copyWith(
      fontSize: 16.0,
      height: 20.0 / 16.0,
      letterSpacing: 0.0,
    ),
    body: base.copyWith(
      fontSize: 13.0,
      height: 17.0 / 13.0,
      letterSpacing: 0.0,
    ),
    footnote: base.copyWith(
      fontSize: 10.0,
      height: 14.0 / 10.0,
      letterSpacing: 0.0,
    ),
  );
}

AppTypography generateCupertinoTypography(AppColors colors) {
  const fallback = [
    '.AppleSystemUIFont',
    'Apple Color Emoji',
  ];

  const base = TextStyle(
    fontFamily: 'SF Mono',
    fontWeight: .w300,
    leadingDistribution: TextLeadingDistribution.even,
    fontFamilyFallback: fallback,
  );

  return AppTypographyGenerator.generate(
    colors,
    largeTitle: base.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 34.0,
      height: 41.0 / 34.0,
      letterSpacing: 0.0,
    ),
    title: base.copyWith(
      fontSize: 22.0,
      height: 28.0 / 22.0,
      letterSpacing: -0.2,
    ),
    subtitle: base.copyWith(
      fontSize: 13.0,
      height: 16.0 / 13.0,
      letterSpacing: -0.2,
    ),
    body: base.copyWith(
      fontSize: 12.0,
      height: 14.0 / 12.0,
      letterSpacing: -0.2,
    ),
    footnote: base.copyWith(
      fontSize: 8.0,
      height: 12.0 / 8.0,
      letterSpacing: -0.2,
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
  window: AnimationStyle(
    duration: Duration(milliseconds: 400),
    curve: Curves.linear,
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
  window: AnimationStyle(
    duration: Duration(milliseconds: 400),
    curve: Curves.linear,
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
  final seed = scheme.primary;
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
        background: isLight ? scheme.surfaceContainer : scheme.surfaceContainer,
        foreground: scheme.onSurface,
      ),
      disabled: .new(
        background: _mixColor(background, isLight ? scheme.surfaceContainer : scheme.surfaceContainer, 0.5),
        foreground: _mixColor(background, scheme.onSurface, 0.75),
      ),
      hovered: .new(
        background: getSurfaceHoverColor(isLight ? scheme.surfaceContainer : scheme.surfaceContainer),
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
    blueprint: _generateBlueprintColors(seedColor, brightness),
  );
}

BlueprintColors _generateBlueprintColors(Color seedColor, Brightness brightness) {
  final _dataInt = Color(0xFF5E239D);
  final _dataFloat = Color(0xFF1B998B);
  final _dataVector = Color(0xFF5398BE);
  final _dataSymbol = Color(0xFFB00020);
  final _dataGeometry = seedColor;

  final _nodeMath = Color(0xFF5398BE);
  final _nodePrimitive = Color(0xFF5E239D);
  final _nodeInstance = Color(0xFF1B998B);
  final _nodeSymbol = Color(0xFFB00020);
  final _nodeGeometry = seedColor;

  Color _resolve(Color c) {
    final scheme = ColorScheme.fromSeed(seedColor: c, brightness: brightness);
    return scheme.primaryContainer;
  }

  return (
    data: (
      int: _resolve(_dataInt),
      float: _resolve(_dataFloat),
      vector: _resolve(_dataVector),
      geometry: _resolve(_dataGeometry),
      symbol: _resolve(_dataSymbol),
    ),
    node: (
      math: _resolve(_nodeMath),
      primitive: _resolve(_nodePrimitive),
      geometry: _resolve(_nodeGeometry),
      instance: _resolve(_nodeInstance),
      symbol: _resolve(_nodeSymbol),
    ),
  );
}

const AppSizes _mobileSizes = (
  panel: 48.0,
);

const AppSizes _desktopSizes = (
  panel: 36.0,
);

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
        .iOS || .macOS => ThemePlatform.cupertino,
        _ => ThemePlatform.material,
      };

  final _variant = switch (defaultTargetPlatform) {
    .iOS || .android || .fuchsia => ThemeVariant.mobile,
    _ => ThemeVariant.desktop,
  };

  return (
    variant: _variant,
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
      medium: [
        .new(
          color: colors.shadow.withScaledAlpha(0.1),
          offset: .new(0.0, 4.0),
          blurRadius: 8.0,
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
    sizes: switch (_variant) {
      .mobile => _mobileSizes,
      .desktop => _desktopSizes,
    },
  );
}
