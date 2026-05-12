part of '../cubic.dart';

typedef CubicToQuadResult = (Quadratic2 quad, double t0, double t1);

List<CubicToQuadResult> _cubicToQuads(Cubic2 c, {double tolerance = 1.0}) {
  final (quads, ts) = ffi.cubicToQuads(c, tolerance, true);
  final result = <CubicToQuadResult>[];

  for (var i = 0; i < quads.length; i++) {
    final quad = quads[i];
    final t0 = i == 0 ? 0.0 : ts[i - 1];
    final t1 = i == quads.length - 1 ? 1.0 : ts[i];
    result.add((quad, t0, t1));
  }

  return result;
}
