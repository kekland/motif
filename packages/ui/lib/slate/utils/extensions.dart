part of '../slate.dart';

extension BrightnessExtensions on Brightness {
  Brightness get inverse => switch (this) {
    .light => .dark,
    .dark => .light,
  };
}

extension DurationExtensions on Duration {
  bool get isPositive => this > Duration.zero;
}

extension AnimationStyleExtensions on AnimationStyle {
  bool get hasDuration => duration != null && duration!.isPositive;
}
