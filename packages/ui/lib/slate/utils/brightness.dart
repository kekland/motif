part of '../slate.dart';

class InheritedBrightness extends InheritedWidget {
  const InheritedBrightness({
    super.key,
    required this.brightness,
    required super.child,
  });

  static Brightness? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedBrightness>()?.brightness;
  }

  static Brightness of(BuildContext context) => maybeOf(context)!;

  final Brightness brightness;

  @override
  bool updateShouldNotify(InheritedBrightness oldWidget) => brightness != oldWidget.brightness;
}

extension ThemeBrightnessExtension on BuildContext {
  Brightness get brightness => InheritedBrightness.of(this);
}
