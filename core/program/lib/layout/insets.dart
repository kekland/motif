part of '../program.dart';

extension type const LayoutInsets._((double left, double top, double right, double bottom) _) {
  const LayoutInsets(double left, double top, double right, double bottom) : this._((left, top, right, bottom));

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

  double get left => _.$1;
  double get top => _.$2;
  double get right => _.$3;
  double get bottom => _.$4;

  double get horizontal => left + right;
  double get vertical => top + bottom;

  Vec2 get origin => Vec2(left, top);
}
