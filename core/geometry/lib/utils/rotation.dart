import 'constants.dart';

extension type const Angle2._(double _angleRad) implements double {
  const Angle2.fromRad(double angleRad) : this._(angleRad);
  const Angle2.fromDeg(double angleDeg) : this._(angleDeg * deg2Rad);

  static const Angle2 zero = Angle2._(0.0);

  double get rad => this;
  double get deg => this * rad2Deg;
}
