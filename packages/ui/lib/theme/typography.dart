import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'theme.dart';

AppTypography generateMaterialTypography(AppColors colors) {
  const base = TextStyle(
    fontFamily: 'Roboto Mono',
    package: 'ui',
    fontWeight: .w300,
    leadingDistribution: TextLeadingDistribution.even,
  );

  return (
    largeTitle: .from(
      base.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 34.0,
        height: 41.0 / 34.0,
        letterSpacing: 0.0,
      ),
      colors.display,
    ),
    title: .from(
      base.copyWith(
        fontSize: 22.0,
        height: 28.0 / 22.0,
        letterSpacing: 0.0,
      ),
      colors.display,
    ),
    subtitle: .from(
      base.copyWith(
        fontSize: 13.0,
        height: 16.0 / 13.0,
        letterSpacing: 0.0,
      ),
      colors.display,
    ),
    body: .from(
      base.copyWith(
        fontSize: 12.0,
        height: 14.0 / 12.0,
        letterSpacing: 0.0,
      ),
      colors.display,
    ),
    footnote: .from(
      base.copyWith(
        fontSize: 8.0,
        height: 12.0 / 8.0,
        letterSpacing: 0.0,
      ),
      colors.display,
    ),
  );
}

AppTypography generateCupertinoTypography(AppColors colors) {
  if (kIsWeb) return generateMaterialTypography(colors);

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

  return (
    largeTitle: .from(
      base.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 34.0,
        height: 41.0 / 34.0,
        letterSpacing: 0.0,
      ),
      colors.display,
    ),
    title: .from(
      base.copyWith(
        fontSize: 22.0,
        height: 28.0 / 22.0,
        letterSpacing: -0.2,
      ),
      colors.display,
    ),
    subtitle: .from(
      base.copyWith(
        fontSize: 13.0,
        height: 16.0 / 13.0,
        letterSpacing: -0.2,
      ),
      colors.display,
    ),
    body: .from(
      base.copyWith(
        fontSize: 12.0,
        height: 14.0 / 12.0,
        letterSpacing: -0.2,
      ),
      colors.display,
    ),
    footnote: .from(
      base.copyWith(
        fontSize: 8.0,
        height: 12.0 / 8.0,
        letterSpacing: -0.2,
      ),
      colors.display,
    ),
  );
}
