import 'dart:math' as math;

import 'package:geometry/gen/_import.dart';

extension type const Quadratic2._(Vec2List storage) implements Object {
  Quadratic2.zero() : storage = .new(3);
  Quadratic2.line(Vec2 p0, Vec2 p2) : this(p0, p2, p1: p0 + (p2 - p0).scale(0.5));
  Quadratic2.view(Vec2List storage) : storage = storage;

  Quadratic2(Vec2 p0, Vec2 p2, {Vec2? p1}) : storage = .new(3) {
    storage[0] = p0;
    storage[1] = p1 ?? (p0 + p2).scale(0.5);
    storage[2] = p2;
  }

  Vec2 get p0 => storage[0];
  Vec2 get p1 => storage[1];
  Vec2 get p2 => storage[2];

  set p0(Vec2 v) => storage[0] = v;
  set p1(Vec2 v) => storage[1] = v;
  set p2(Vec2 v) => storage[2] = v;

  Aabb2 get bboxTight => _quadraticBboxTight(this);
}

Aabb2 _quadraticBboxTight(Quadratic2 q) {
  var minX = math.min(q.p0.x, q.p2.x), minY = math.min(q.p0.y, q.p2.y);
  var maxX = math.max(q.p0.x, q.p2.x), maxY = math.max(q.p0.y, q.p2.y);

  final ex = _quadraticExtrema(q.p0.x, q.p1.x, q.p2.x);
  if (ex != null) {
    minX = math.min(minX, ex);
    maxX = math.max(maxX, ex);
  }

  final ey = _quadraticExtrema(q.p0.y, q.p1.y, q.p2.y);
  if (ey != null) {
    minY = math.min(minY, ey);
    maxY = math.max(maxY, ey);
  }

  return .new(minX, minY, maxX, maxY);
}

double? _quadraticExtrema(double a, double b, double c) {
  final d = a - 2 * b + c;
  if (d == 0) return null;

  final t = (a - b) / d;
  if (t <= 0 || t >= 1) return null;

  final s = 1 - t;
  return s * s * a + 2 * s * t * b + t * t * c;
}
