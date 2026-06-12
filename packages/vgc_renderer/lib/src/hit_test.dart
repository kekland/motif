import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:vgc/vgc.dart';
import 'package:vgc_renderer/vgc_renderer.dart';
import 'package:flutter/rendering.dart';

sealed class CellHitTestEntry extends HitTestEntry<RenderCell> {
  CellHitTestEntry(super.target, {required this.distance, required this.localPosition});

  Cell get cell => target.cell;
  final double distance;
  final Vector2 localPosition;

  Object get hitObject => cell;
}

final class VertexHitTestEntry extends CellHitTestEntry {
  VertexHitTestEntry(RenderVertex super.target, {required super.distance, required super.localPosition});

  Vertex get vertex => cell as Vertex;
}

final class EdgeHitTestEntry extends CellHitTestEntry {
  EdgeHitTestEntry(
    RenderEdge super.target, {
    required this.t,
    required super.distance,
    required super.localPosition,
  });

  Edge get edge => cell as Edge;

  final double t;
}

final class EdgeKnotHitTestEntry extends EdgeHitTestEntry {
  EdgeKnotHitTestEntry(
    super.target, {
    required this.knotIndex,
    required super.t,
    required super.distance,
    required super.localPosition,
  });

  final int knotIndex;
  CubicKnot2 get knot => edge.spline.knot(knotIndex);

  @override
  Object get hitObject => knot;
}

final class FaceHitTestEntry extends CellHitTestEntry {
  FaceHitTestEntry(RenderFace super.target, {required super.distance, required super.localPosition});

  Face get face => cell as Face;
}

final class CellHitTestTolerance {
  const CellHitTestTolerance({required this.vertex, required this.edge});
  static const defaultTolerance = CellHitTestTolerance(vertex: 16.0, edge: 12.0);

  /// Tolerance for hitting vertices, in canvas-space units.
  final double vertex;

  /// Tolerance for hitting edges, in canvas-space units.
  final double edge;

  CellHitTestTolerance scaled(double f) => CellHitTestTolerance(vertex: vertex * f, edge: edge * f);
}
