import 'package:flutter/rendering.dart' hide Selectable;
import 'package:vc/vc.dart';

sealed class CellHitTestEntry<T extends Cell> extends BoxHitTestEntry {
  CellHitTestEntry(
    super.target,
    super.localPosition, {
    required this.cell,
    required this.distance,
  });

  final T cell;
  final double distance;

  Selectable get hitObject => cell;
}

final class VertexHitTestEntry extends CellHitTestEntry<Vertex> {
  VertexHitTestEntry(
    super.target,
    super.localPosition, {
    required super.cell,
    required super.distance,
  });
}

final class EdgeHitTestEntry extends CellHitTestEntry<Edge> {
  EdgeHitTestEntry(
    super.target,
    super.localPosition, {
    required this.t,
    required super.cell,
    required super.distance,
  });

  final double t;
}

final class EdgeKnotHitTestEntry extends EdgeHitTestEntry {
  EdgeKnotHitTestEntry(
    super.target,
    super.localPosition, {
    required this.knotIndex,
    required super.cell,
    required super.t,
    required super.distance,
  });

  final int knotIndex;
  EdgeKnot get knot => cell.path.knot(knotIndex);

  @override
  EdgeKnot get hitObject => knot;
}

final class KnotControlPointHitTestEntry extends CellHitTestEntry<Edge> {
  KnotControlPointHitTestEntry(
    super.target,
    super.localPosition, {
    required super.distance,
    required this.knotIndex,
    required this.isIn,
    required super.cell,
  });

  final int knotIndex;
  final bool isIn;

  EdgeKnot get knot => cell.path.knot(knotIndex);

  @override
  EdgeKnotControlPoint get hitObject => isIn ? knot.cIn! : knot.cOut!;
}

final class CellHitTestTolerance {
  const CellHitTestTolerance({
    required this.vertex,
    required this.edge,
    required this.knot,
    required this.controlPoint,
  });

  static const defaultTolerance = CellHitTestTolerance(
    vertex: 16.0,
    edge: 12.0,
    knot: 16.0,
    controlPoint: 12.0,
  );

  /// Tolerance for hitting vertices, in canvas-space units.
  final double vertex;

  /// Tolerance for hitting edges, in canvas-space units.
  final double edge;

  /// Tolerance for hitting edge knots, in canvas-space units.
  final double knot;

  /// Tolerance for hitting edge control points, in canvas-space units.
  final double controlPoint;

  CellHitTestTolerance scaled(double f) => CellHitTestTolerance(
    vertex: vertex * f,
    edge: edge * f,
    knot: knot * f,
    controlPoint: controlPoint * f,
  );

  CellHitTestTolerance operator *(double f) => scaled(f);
}
