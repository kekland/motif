part of '../cubic_impl.dart';

int _cubicToQuadraticCount(Cubic2 c, double tolerance) {
  final d3 = c.p3 - (c.p2 * 3) + (c.p1 * 3) - c.p0;
  final err = d3.length * (math.sqrt(3) / 36);
  if (err <= tolerance) return 1;
  return math.pow(err / tolerance, 1 / 3).ceil();
}

List<Quadratic2> _cubicToQuadratics(Cubic2 c, double tolerance) {
  final out = <Quadratic2>[];
  var current = c.p0;
  _cubicToQuadraticsRaw(c, _cubicToQuadraticCount(c, tolerance), (control, end) {
    out.add(Quadratic2(current, end, p1: control));
    current = end;
  });
  return out;
}

void _cubicToQuadraticsRaw(Cubic2 c, int n, void Function(Vec2, Vec2) callback) {
  var current = c.p0;
  var currentVel = c.velocity(0);

  final dt = 1 / n;
  for (var i = 1; i <= n; i++) {
    final t = i == n ? 1.0 : i * dt;
    final end = i == n ? c.p3 : c.point(t);
    final endVel = c.velocity(t);

    final control = (current + end) * 0.5 + (currentVel - endVel) * (dt * 0.25);
    callback(control, end);
    current = end;
    currentVel = endVel;
  }
}
