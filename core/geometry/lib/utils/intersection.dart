import 'package:geometry/geometry.dart';

final class Intersection {
  Intersection(this.ta, this.tb, this.point);

  static const epsD = 1e-6;
  static const epsD2 = epsD * epsD;
  static const epsT = 1e-9;

  final double ta, tb;
  final Vec2 point;

  @pragma('vm:prefer-inline')
  T? _resolveEndpoints<T>(double t, T Function() start, T Function() end) {
    if (t <= epsT) return start();
    if (t >= 1 - epsT) return end();
    return null;
  }

  @pragma('vm:prefer-inline')
  T? resolveEndpointsA<T>(T Function() start, T Function() end) => _resolveEndpoints(ta, start, end);

  @pragma('vm:prefer-inline')
  T? resolveEndpointsB<T>(T Function() start, T Function() end) => _resolveEndpoints(tb, start, end);
}

final class Overlap {
  Overlap(this.ta0, this.ta1, this.tb0, this.tb1);

  final double ta0, ta1;
  final double tb0, tb1;

  bool _contains(double a, double b, double t) => t >= a - 1e-6 && t <= b + 1e-6;

  bool containsA(double t) => _contains(ta0, ta1, t);
  bool containsB(double t) => _contains(tb0, tb1, t);
}

final class Intersections {
  const Intersections(this.intersections, this.overlaps);
  static const Intersections empty = .new([], []);

  final List<Intersection> intersections;
  final List<Overlap> overlaps;

  bool get isEmpty => intersections.isEmpty && overlaps.isEmpty;
  bool get isNotEmpty => intersections.isNotEmpty || overlaps.isNotEmpty;
}
