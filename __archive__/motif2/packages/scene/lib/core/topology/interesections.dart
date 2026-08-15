part of '../core.dart';

class CellIntersection extends Intersection {
  CellIntersection(super.point, super.tA, super.tB, this.edge);
  CellIntersection.from(Intersection intersection, this.edge)
    : super(intersection.point, intersection.tA, intersection.tB);

  final Edge edge;

  double get tEdge => tA;
  double get tArg => tB;
}

List<CellIntersection> _intersectCellsWithGeometry(
  Iterable<Cell> cells,
  Aabb2 bbox,
  List<Intersection> Function(CubicSpline2 spline) intersectFunction,
) {
  final result = <CellIntersection>[];

  for (final edge in cells.whereType<Edge>()) {
    final edgeBbox = edge.bbox;
    if (!edgeBbox.intersectsWithAabb2(bbox)) continue;

    final intersections = intersectFunction(edge.path);
    result.addAll(intersections.map((i) => CellIntersection.from(i, edge)));
  }

  return result;
}

List<CellIntersection> _intersectCellsWithCubic(Iterable<Cell> cells, Cubic2 cubic) => _intersectCellsWithGeometry(
  cells,
  cubic.bbox,
  (spline) => spline.intersectWithCubic(cubic),
);

List<CellIntersection> _intersectCellsWithSpline(Iterable<Cell> cells, CubicSpline2 spline) => _intersectCellsWithGeometry(
  cells,
  spline.bbox,
  (spline) => spline.intersectWith(spline),
);

extension MultiChildSceneObjectIntersections on Iterable<Cell> {
  List<CellIntersection> intersectionsWithCubic(Cubic2 cubic) => _intersectCellsWithCubic(this, cubic);
  List<CellIntersection> intersectionsWithSpline(CubicSpline2 spline) => _intersectCellsWithSpline(this, spline);
}
