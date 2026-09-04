part of '../program.dart';

extension type CornerRadius._((double x, double y) _) {
  const CornerRadius(double x, double y) : _ = (x, y);
  const CornerRadius.circular(double radius) : this(radius, radius);
  static const zero = CornerRadius(0, 0);

  double get x => _.$1;
  double get y => _.$2;

  bool get isZero => x <= 0 || y <= 0;
  CornerRadius scale(double f) => CornerRadius(x * f, y * f);

  Vec2 get vec => .new(x, y);
}
