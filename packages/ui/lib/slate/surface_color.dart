part of 'slate.dart';

class AugmentedColor extends Color {
  AugmentedColor(Color color)
    : this._(red: color.r, green: color.g, blue: color.b, alpha: color.a, colorSpace: color.colorSpace);

  const AugmentedColor._({
    required super.red,
    required super.green,
    required super.blue,
    required super.alpha,
    super.colorSpace = .sRGB,
  }) : super.from();
}

final class SurfaceColor extends AugmentedColor {
  SurfaceColor({
    required Color background,
    required this.foreground,
    this.divider,
    this.tint,
  }) : super(background);

  Color get background => this;
  final Color foreground;
  final Color? divider;
  final Color? tint;
}
