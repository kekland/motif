part of '../cubic.dart';

final class CubicKnot2 {
  CubicKnot2(this.p, {this.cIn, this.cOut});
  CubicKnot2.point(this.p) : cIn = null, cOut = null;

  CubicKnot2 copy() => .new(p.clone(), cIn: cIn?.clone(), cOut: cOut?.clone());
  CubicKnot2 _reversed() => .new(p.clone(), cIn: cOut?.clone(), cOut: cIn?.clone());

  Vector2 p;
  Vector2? cIn;
  Vector2? cOut;

  Aabb2 get bboxCheap => _knotBboxCheap(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CubicKnot2) return false;
    return p == other.p && cIn == other.cIn && cOut == other.cOut;
  }

  @override
  int get hashCode => Object.hash(p, cIn, cOut);
}
