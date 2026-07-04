import 'package:vector_math/vector_math_64.dart';

extension type const Angle2._(double angleRad) implements double {
  const Angle2(double angleRad) : this._(angleRad);
  const Angle2.degrees(double angleDeg) : this._(angleDeg * degrees2Radians);

  static const Angle2 zero = Angle2._(0.0);

  double get value => this;
  double get valueDegrees => this * radians2Degrees;
}
