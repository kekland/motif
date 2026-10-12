part of '../_program.dart';

final class const LayoutInsets(
  final double left,
  final double top,
  final double right,
  final double bottom,
) {
  const LayoutInsets.all(double value) : this(value, value, value, value);

  const LayoutInsets.symmetric({
    double horizontal = 0,
    double vertical = 0,
  }) : this(horizontal, vertical, horizontal, vertical);

  const LayoutInsets.only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) : this(left, top, right, bottom);

  static const zero = LayoutInsets(0, 0, 0, 0);

  double get horizontal => left + right;
  double get vertical => top + bottom;

  Vec2 get origin => Vec2(left, top);

  LayoutInsets copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) => .new(
    left ?? this.left,
    top ?? this.top,
    right ?? this.right,
    bottom ?? this.bottom,
  );
}
