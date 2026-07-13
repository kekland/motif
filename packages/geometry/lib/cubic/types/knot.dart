part of '../cubic.dart';

class CubicKnot2 {
  CubicKnot2(this.p, {Vector2? cIn, Vector2? cOut}) : cIn = cIn ?? p.clone(), cOut = cOut ?? p.clone();
  CubicKnot2.point(Vector2 p) : this(p);

  CubicKnot2 copy() => .new(p.clone(), cIn: cIn.clone(), cOut: cOut.clone());
  CubicKnot2 _reversed() => .new(p.clone(), cIn: cOut.clone(), cOut: cIn.clone());

  Vector2 p;
  Vector2 cIn;
  Vector2 cOut;

  Aabb2 get bbox => _knotBbox(this);

  CubicKnot2 shifted(Vector2 delta) => .new(
    p + delta,
    cIn: cIn + delta,
    cOut: cOut + delta,
  );

  CubicKnot2 transform(Matrix4 transform) => .new(
    transform.transform2(p),
    cIn: transform.transform2(cIn),
    cOut: transform.transform2(cOut),
  );

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;
  //   if (other is! CubicKnot2) return false;
  //   return p == other.p && cIn == other.cIn && cOut == other.cOut;
  // }

  // @override
  // int get hashCode => Object.hash(p, cIn, cOut);
}

extension CubicKnot2IterableExtension on Iterable<CubicKnot2> {
  List<CubicKnot2> copy() => map((knot) => knot.copy()).toList();
}
