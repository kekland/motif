part of '../cubic.dart';

List<Intersection> _ffiCubicIntersect(Cubic2 a, Cubic2 b) => ffi.cubicIntersect(a, b);
Intersection? _ffiCubicSelfIntersect(Cubic2 c) => ffi.cubicSelfIntersect(c);
Aabb2 _ffiCubicBboxTight(Cubic2 a) => ffi.cubicBboxTight(a);
double _ffiCubicArcLength(Cubic2 a) => ffi.cubicArcLength(a);
Vector2 _ffiCubicPosAtDistance(Cubic2 a, double distance) => ffi.cubicPosTanAtDistance(a, distance).$1;
Vector2 _ffiCubicTanAtDistance(Cubic2 a, double distance) => ffi.cubicPosTanAtDistance(a, distance).$2;
