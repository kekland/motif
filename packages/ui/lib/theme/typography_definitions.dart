import 'package:flutter/widgets.dart';
import 'theme.dart';

final class AppTextStyle extends AugmentedTextStyle {
  AppTextStyle(
    super.base, {
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  AppTextStyle.from(TextStyle base, AppDisplayColors colors)
    : this(
        base,
        primary: base.copyWith(color: colors.primary),
        secondary: base.copyWith(color: colors.secondary),
        tertiary: base.copyWith(color: colors.tertiary),
      );

  final TextStyle primary;
  final TextStyle secondary;
  final TextStyle tertiary;
}

typedef AppTypography = ({
  AppTextStyle largeTitle,
  AppTextStyle title,
  AppTextStyle subtitle,
  AppTextStyle body,
  AppTextStyle footnote,
});
