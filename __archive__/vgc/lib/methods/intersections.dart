part of '../vector_complex.dart';

extension Intersections on VectorComplex {
  List<VectorComplexIntersection> intersectWithCubic(Cubic2 cubic) => _intersectComplexWithCubic(this, cubic);
  List<VectorComplexIntersection> intersectWithSpline(CubicSpline2 spline) => _intersectComplexWithSpline(this, spline);
}

class VectorComplexIntersection extends Intersection {
  VectorComplexIntersection(super.point, super.tA, super.tB, this.edge);
  VectorComplexIntersection.from(Intersection intersection, this.edge)
    : super(intersection.point, intersection.tA, intersection.tB);

  final Edge edge;

  double get tEdge => tA;
  double get tArg => tB;
}

List<VectorComplexIntersection> _intersectComplexWithGeometry<T>(
  VectorComplex complex,
  Aabb2 bbox,
  List<Intersection> Function(CubicSpline2 spline) intersectFunction,
) {
  final result = <VectorComplexIntersection>[];

  for (final edge in complex.edges) {
    final edgeBbox = edge.boundingBoxApproximate;
    if (!edgeBbox.intersectsWithAabb2(bbox)) continue;

    final intersections = intersectFunction(edge.spline);
    result.addAll(intersections.map((e) => .from(e, edge)));
  }

  return result;
}

List<VectorComplexIntersection> _intersectComplexWithCubic(VectorComplex complex, Cubic2 cubic) {
  return _intersectComplexWithGeometry(
    complex,
    cubic.bbox,
    (spline) => spline.intersectWithCubic(cubic),
  );
}

List<VectorComplexIntersection> _intersectComplexWithSpline(
  VectorComplex complex,
  CubicSpline2 spline,
) {
  return _intersectComplexWithGeometry(
    complex,
    spline.bbox,
    (edgeSpline) => edgeSpline.intersectWith(spline),
  );
}
