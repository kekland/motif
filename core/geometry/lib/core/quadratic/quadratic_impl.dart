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
}
