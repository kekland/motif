part of '../core.dart';

extension ComplexCutEdge on MutableVectorComplex {
  EdgeCutResult cutEdge(MutableEdge edge, double t) {
    if (t <= 0 || t >= 1) throw ArgumentError.value(t, 't', 'must be between 0 and 1');
    return _cutEdge(edge, t);
  }

  MultiEdgeCutResult cutEdgeMultiple(MutableEdge edge, List<double> ts) {
    if (ts.any((t) => t <= 0 || t >= 1)) throw ArgumentError.value(ts, 'ts', 'all values must be between 0 and 1');
    return _multiCutEdge(edge, ts);
  }

  void _onCutEdge(MutableEdge originalEdge, List<MutableVertex> vertices, List<MutableEdge> newEdges) {
    for (final vertex in vertices) {
      originalEdge.insertAfter(vertex);
    }

    for (var i = 0; i < newEdges.length; i++) {
      final edge = newEdges[i];
      originalEdge.insertAfter(edge);
    }

    hardDelete(originalEdge);
  }

  EdgeCutResult _cutEdge(MutableEdge edge, double t) {
    final (leftSpline, rightSpline) = edge.path.spline.split(t);
    final weights = edge.weights.split(t);

    final splitPosition = leftSpline.knots.last.p.clone();

    final vertex = MutableVertex(splitPosition);
    final edge1 = MutableEdge(
      edge.start,
      vertex,
      path: .immutable(knots: leftSpline.knots),
      weights: weights.$1,
      decoration: edge.decoration.asImmutable(),
    );
    final edge2 = MutableEdge(
      vertex,
      edge.end,
      path: .immutable(knots: rightSpline.knots),
      weights: weights.$2,
      decoration: edge.decoration.asImmutable(),
      modifiers: edge.modifiers.toList(),
    );

    _onCutEdge(edge, [vertex], [edge1, edge2]);
    return .new(vertex: vertex, edge1: edge1, edge2: edge2);
  }

  MultiEdgeCutResult _multiCutEdge(MutableEdge edge, List<double> ts) {
    final splines = edge.path.spline.splitMultiple(ts);
    final weights = edge.weights.splitMultiple(ts);

    final vertices = <MutableVertex>[];
    final newEdges = <MutableEdge>[];

    for (var i = 0; i < splines.length; i++) {
      final spline = splines[i];

      final startVertex = i == 0 ? edge.start : vertices[i - 1];
      final endVertex = i == splines.length - 1 ? edge.end : MutableVertex(spline.knots.last.p.clone());
      if (i != splines.length - 1) vertices.add(endVertex);

      final newEdge = MutableEdge(
        startVertex,
        endVertex,
        path: .immutable(knots: spline.knots),
        weights: weights[i],
        decoration: edge.decoration.asImmutable(),
        modifiers: edge.modifiers.toList(),
      );
      newEdges.add(newEdge);
    }

    _onCutEdge(edge, vertices, newEdges);
    return .new(vertices: vertices, edges: newEdges);
  }
}

final class EdgeCutResult {
  const EdgeCutResult({
    required this.vertex,
    required this.edge1,
    required this.edge2,
  });

  final MutableVertex vertex;
  final MutableEdge edge1;
  final MutableEdge edge2;
}

final class MultiEdgeCutResult {
  const MultiEdgeCutResult({required this.vertices, required this.edges});

  final List<MutableVertex> vertices;
  final List<MutableEdge> edges;
}
