part of '../core.dart';

extension VectorComplexCutEdge on VectorComplex {
  EdgeCutResult cutEdge(Edge edge, double t) {
    if (t <= 0 || t >= 1) throw ArgumentError.value(t, 't', 'must be between 0 and 1');
    return _cutEdge(edge, t);
  }

  MultiEdgeCutResult cutEdgeMultiple(Edge edge, List<double> ts) {
    if (ts.any((t) => t <= 0 || t >= 1)) throw ArgumentError.value(ts, 'ts', 'all values must be between 0 and 1');
    return _multiCutEdge(edge, ts);
  }

  void _onCutEdge(Edge originalEdge, List<Vertex> vertices, List<Edge> newEdges) {
    for (final vertex in vertices) {
      originalEdge.insertAfter(vertex);
    }

    for (var i = 0; i < newEdges.length; i++) {
      final edge = newEdges[i];
      originalEdge.insertAfter(edge);
    }

    remove(originalEdge);
  }

  EdgeCutResult _cutEdge(Edge edge, double t) {
    final (leftPath, rightPath) = edge.path.split(t);
    final (leftWeight, rightWeight) = edge.weights.split(t);
    final (leftDecoration, rightDecoration) = edge.decoration.split(t);

    final splitPosition = leftPath.last.p.clone();

    final vertex = Vertex(splitPosition);
    final edge1 = Edge(
      edge.start,
      vertex,
      path: leftPath,
      weights: leftWeight,
      decoration: leftDecoration,
    );
    final edge2 = Edge(
      vertex,
      edge.end,
      path: rightPath,
      weights: rightWeight,
      decoration: rightDecoration,
      modifiers: edge.modifiers.toList(),
    );

    _onCutEdge(edge, [vertex], [edge1, edge2]);
    return .new(vertex: vertex, edge1: edge1, edge2: edge2);
  }

  MultiEdgeCutResult _multiCutEdge(Edge edge, List<double> ts) {
    final paths = edge.path.splitMultiple(ts);
    final weights = edge.weights.splitMultiple(ts);
    final decorations = edge.decoration.splitMultiple(ts);

    final vertices = <Vertex>[];
    final newEdges = <Edge>[];

    for (var i = 0; i < paths.length; i++) {
      final path = paths[i];
      final weight = weights[i];
      final decoration = decorations[i];

      final startVertex = i == 0 ? edge.start : vertices[i - 1];
      final endVertex = i == paths.length - 1 ? edge.end : Vertex(path.knots.last.p.clone());
      if (i != paths.length - 1) vertices.add(endVertex);

      final newEdge = Edge(
        startVertex,
        endVertex,
        path: path,
        weights: weight,
        decoration: decoration,
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

  final Vertex vertex;
  final Edge edge1;
  final Edge edge2;
}

final class MultiEdgeCutResult {
  const MultiEdgeCutResult({required this.vertices, required this.edges});

  final List<Vertex> vertices;
  final List<Edge> edges;
}
