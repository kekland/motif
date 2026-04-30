part of '../../vector_complex.dart';

extension CutEdge on VectorComplex {
  EdgeCutResult cutEdge(Edge edge, double t) {
    if (!contains(edge)) throw ArgumentError('Edge is not part of this complex');
    if (t <= 0 || t >= 1) throw ArgumentError.value(t, 't', 'must be between 0 and 1');

    return switch (edge) {
      OpenEdge e => _cutOpenEdge(e, t),
      ClosedEdge e => _cutClosedEdge(e, t),
    };
  }

  MultiEdgeCutResult cutEdgeMulti(Edge edge, List<double> ts) {
    if (!contains(edge)) throw ArgumentError('Edge is not part of this complex');
    if (ts.any((t) => t <= 0 || t >= 1)) throw ArgumentError.value(ts, 'ts', 'all values must be between 0 and 1');

    return switch (edge) {
      OpenEdge e => _multiCutOpenEdge(e, ts),
      ClosedEdge e => _multiCutClosedEdge(e, ts),
    };
  }

  OpenEdgeCutResult _cutOpenEdge(OpenEdge edge, double t) {
    final (leftSpline, rightSpline) = edge.spline.split(t);
    final splitPosition = leftSpline.knots.last.p.clone();

    final vertex = Vertex(splitPosition);
    final edge1 = OpenEdge.fromSpline(edge.start, vertex, leftSpline);
    final edge2 = OpenEdge.fromSpline(vertex, edge.end, rightSpline);

    _linkBelow(vertex, edge);
    _linkBelow(edge1, edge);
    _linkBelow(edge2, edge);

    _cells.add(vertex);
    _cells.add(edge1);
    _cells.add(edge2);

    for (final face in edge.directStar.whereType<Face>().toList()) {
      face.cycles = [
        for (final cycle in face.cycles)
          if (cycle is RegularCycle)
            RegularCycle([
              for (final he in cycle.halfEdges)
                if (he.edge != edge)
                  he
                else if (he.direction) ...[
                  .new(edge1, true),
                  .new(edge2, true),
                ] else ...[
                  .new(edge2, false),
                  .new(edge1, false),
                ],
            ])
          else
            cycle,
      ];
    }

    hardDelete(edge);
    return .new(vertex: vertex, edge1: edge1, edge2: edge2);
  }

  ClosedEdgeCutResult _cutClosedEdge(ClosedEdge edge, double t) {
    final (leftSpline, rightSpline) = edge.spline.split(t);
    final splitPosition = leftSpline.knots.last.p.clone();

    final seam = CubicKnot2(
      splitPosition,
      cIn: rightSpline.knots.last.cIn?.clone(),
      cOut: leftSpline.knots.first.cOut?.clone(),
    );

    final interior = [
      for (var i = 1; i < leftSpline.knots.length - 1; i++) leftSpline.knots[i],
      seam,
      for (var i = 1; i < rightSpline.knots.length - 1; i++) rightSpline.knots[i],
    ];

    final vertex = Vertex(splitPosition);
    final newEdge = OpenEdge(
      vertex,
      vertex,
      cStart: rightSpline.knots.last.cOut?.clone(),
      cEnd: leftSpline.knots.first.cIn?.clone(),
      interior: interior,
    );

    _linkBelow(vertex, edge);
    _linkBelow(newEdge, edge);
    _cells.add(vertex);
    _cells.add(newEdge);

    for (final face in edge.directStar.whereType<Face>()) {
      face.cycles = [
        for (final cycle in face.cycles)
          if (cycle is RegularCycle)
            RegularCycle([
              for (final he in cycle.halfEdges)
                if (he.edge == edge) .new(newEdge, he.direction) else he,
            ])
          else
            cycle,
      ];
    }

    hardDelete(edge);
    return .new(vertex: vertex, edge: newEdge);
  }

  MultiEdgeCutResult _multiCutOpenEdge(OpenEdge edge, List<double> ts) {
    final vertices = <Vertex>[];
    final edges = parametricSplit(edge, ts, (e, t) {
      final result = _cutOpenEdge(e, t);
      vertices.add(result.vertex);
      return (result.edge1, result.edge2);
    });

    return .new(vertices: vertices, edges: edges);
  }

  MultiEdgeCutResult _multiCutClosedEdge(ClosedEdge edge, List<double> ts) {
    // Cut closed edge first, and then defer to _multiCutOpenEdge for the remaining cuts.
    final _ts = List<double>.from(ts)..sort();

    final firstT = _ts.first;
    final firstCutResult = _cutClosedEdge(edge, firstT);
    final remainingTs = _ts.skip(1).map((t) => t - firstT).toList();
    return _multiCutOpenEdge(firstCutResult.edge, remainingTs);
  }
}

sealed class EdgeCutResult {
  const EdgeCutResult({required this.vertex});
  final Vertex vertex;
}

final class OpenEdgeCutResult extends EdgeCutResult {
  const OpenEdgeCutResult({
    required super.vertex,
    required this.edge1,
    required this.edge2,
  });

  final OpenEdge edge1;
  final OpenEdge edge2;
}

final class ClosedEdgeCutResult extends EdgeCutResult {
  const ClosedEdgeCutResult({
    required super.vertex,
    required this.edge,
  });

  /// Closed edge transforms into an open edge with start == end.
  final OpenEdge edge;
}

final class MultiEdgeCutResult {
  const MultiEdgeCutResult({required this.vertices, required this.edges});

  final List<Vertex> vertices;
  final List<OpenEdge> edges;
}
