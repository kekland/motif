part of '../core.dart';

abstract class CellBundle {
  CellBundle(this.id);
  factory CellBundle.vertex(int id, {required Vector2 position}) = VertexBundle;
  factory CellBundle.edge(int id, {
    required ImmutableEdgePath path,
    required ImmutableEdgeDecoration decoration,
    required ImmutableEdgeWeights weights,
  }) = EdgeBundle;

  final int id;

  Aabb2 get bbox;
}

class VertexBundle extends CellBundle {
  VertexBundle(super.id, {required this.position});

  final Vector2 position;

  @override
  Aabb2 get bbox => Aabb2.minMax(position, position);
}

class EdgeBundle extends CellBundle {
  EdgeBundle(super.id, {required this.path, required this.decoration, required this.weights});

  final ImmutableEdgePath path;
  final ImmutableEdgeDecoration decoration;
  final ImmutableEdgeWeights weights;

  @override
  Aabb2 get bbox => path.spline.bbox;
}
