import 'dart:math';

import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart';

extension type const Angle2._(double _angleRad) implements double {
  const Angle2.fromRad(double angleRad) : this._(angleRad);
  const Angle2.fromDeg(double angleDeg) : this._(angleDeg * degrees2Radians);

  static const Angle2 zero = Angle2._(0.0);

  double get rad => this;
  double get deg => this * radians2Degrees;

  Vec2 asVector() => Vec2(cos(_angleRad), sin(_angleRad));
}
