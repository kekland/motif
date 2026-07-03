part of '../core.dart';

extension ComplexIntersections<C extends Cell, V extends Vertex, E extends Edge> on VectorComplex<C, V, E> {
  List<VectorComplexIntersection<E>> intersectWithCubic(Cubic2 cubic) => _intersectComplexWithCubic(this, cubic);
  List<VectorComplexIntersection<E>> intersectWithSpline(CubicSpline2 spline) =>
      _intersectComplexWithSpline(this, spline);
}

class VectorComplexIntersection<T extends Edge> extends Intersection {
  VectorComplexIntersection(super.point, super.tA, super.tB, this.edge);
  VectorComplexIntersection.from(Intersection intersection, this.edge)
    : super(intersection.point, intersection.tA, intersection.tB);

  final T edge;

  double get tEdge => tA;
  double get tArg => tB;
}

List<VectorComplexIntersection<T>> _intersectComplexWithGeometry<T extends Edge>(
  VectorComplex complex,
  Aabb2 bbox,
  List<Intersection> Function(CubicSpline2 spline) intersectFunction,
) {
  final result = <VectorComplexIntersection<T>>[];

  for (final edge in complex.edges) {
    final edgeBbox = edge.bbox;
    if (!edgeBbox.intersectsWithAabb2(bbox)) continue;

    final intersections = intersectFunction(edge.path.spline);
    result.addAll(intersections.map((e) => .from(e, edge as T)));
  }

  return result;
}

List<VectorComplexIntersection<T>> _intersectComplexWithCubic<T extends Edge>(VectorComplex complex, Cubic2 cubic) {
  return _intersectComplexWithGeometry<T>(
    complex,
    cubic.bbox,
    (spline) => spline.intersectWithCubic(cubic),
  );
}

List<VectorComplexIntersection<T>> _intersectComplexWithSpline<T extends Edge>(
  VectorComplex complex,
  CubicSpline2 spline,
) {
  return _intersectComplexWithGeometry<T>(
    complex,
    spline.bbox,
    (edgeSpline) => edgeSpline.intersectWith(spline),
  );
}
