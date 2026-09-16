part of '../cubic.dart';

double _cubicFlatness(Cubic2 c) {
  final chord = c.p3 - c.p0;
  final len2 = chord.length2;
  if (len2 < 1e-18) return math.max((c.p1 - c.p0).length, (c.p2 - c.p0).length);

  final invLen = 1 / math.sqrt(len2);
  final d1 = chord.cross(c.p1 - c.p0).abs();
  final d2 = chord.cross(c.p2 - c.p0).abs();
  return math.max(d1, d2) * invLen;
}

bool _cubicIsFlat(Cubic2 c, {double? tolerance}) {
  tolerance ??= 1e-9;
  if (c.p0.equals(c.p1, tolerance) && c.p2.equals(c.p3, tolerance)) return true;
  return _cubicFlatness(c) <= tolerance;
}
