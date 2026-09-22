import 'package:geometry/geometry.dart';

extension type const CornerRadius._(Vec2 _v) {
  CornerRadius(double x, double y) : _v = .new(x, y);
  CornerRadius.vec(Vec2 v) : _v = v;

  static final zero = CornerRadius._(.zero());

  double get x => _v.x;
  double get y => _v.y;
}
