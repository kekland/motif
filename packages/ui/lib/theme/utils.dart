import 'package:flutter/material.dart';
import 'package:ui/slate.dart';
import 'theme.dart';

class AppThemeWidget extends StatelessWidget {
  const AppThemeWidget({
    super.key,
    required this.theme,
    this.iconTheme,
    required this.builder,
  });

  final AppTheme theme;
  final IconThemeData? iconTheme;
  final Widget Function(BuildContext context, ThemeData themeData) builder;

  @override
  Widget build(BuildContext context) {
    final materialThemeData = ThemeData.from(colorScheme: theme.rawColorScheme).copyWith(
      iconTheme: iconTheme,
    );

    return InheritedBrightness(
      brightness: theme.brightness,
      child: InheritedAppTheme(
        theme: theme,
        child: Theme(
          data: materialThemeData,
          child: builder(context, materialThemeData),
        ),
      ),
    );
  }
}

class InheritedAppTheme extends InheritedWidget {
  const InheritedAppTheme({
    super.key,
    required this.theme,
    required super.child,
  });

  static AppTheme of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<InheritedAppTheme>()!.theme;

  final AppTheme theme;

  @override
  bool updateShouldNotify(covariant InheritedAppTheme oldWidget) => theme != oldWidget.theme;
}

extension ThemeContextExtension on BuildContext {
  AppTheme get theme => InheritedAppTheme.of(this);
  AppThemePlatform get platform => theme.platform;
  AppThemeDevice get device => theme.device;
  AppColors get colors => theme.colors;
  AppTypography get typography => theme.typography;
}
