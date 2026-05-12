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

  MultiEdgeCutResult cutEdgeMultiple(Edge edge, List<double> ts) {
    if (!contains(edge)) throw ArgumentError('Edge is not part of this complex');
    if (ts.any((t) => t <= 0 || t >= 1)) throw ArgumentError.value(ts, 'ts', 'all values must be between 0 and 1');

    return switch (edge) {
      OpenEdge e => _multiCutOpenEdge(e, ts),
      ClosedEdge e => _multiCutClosedEdge(e, ts),
    };
  }

  void _onCutEdge(Edge originalEdge, List<Vertex> vertices, List<OpenEdge> newEdges) {
    for (final vertex in vertices) {
      _linkBelow(vertex, originalEdge);
      _cells.add(vertex);
    }

    final walk1 = <HalfEdge>[]; // positive walk
    final walk2 = <HalfEdge>[]; // negative walk

    for (var i = 0; i < newEdges.length; i++) {
      final edge = newEdges[i];

      _linkBelow(edge, originalEdge);
      _cells.add(edge);
      walk1.add(.new(edge, true));

      final j = newEdges.length - 1 - i;
      walk2.add(.new(newEdges[j], false));
    }

    for (final face in originalEdge.directStar.whereType<Face>().toList()) {
      face.cycles = [
        for (final cycle in face.cycles)
          if (cycle is RegularCycle)
            RegularCycle([
              for (final he in cycle.halfEdges)
                if (he.edge != originalEdge) he else if (he.direction) ...walk1 else ...walk2,
            ])
          else
            cycle,
      ];
    }

    hardDelete(originalEdge);
  }

  OpenEdgeCutResult _cutOpenEdge(OpenEdge edge, double t) {
    final (leftSpline, rightSpline) = edge.spline.split(t);
    final splitPosition = leftSpline.knots.last.p.clone();

    final vertex = Vertex(splitPosition);
    final edge1 = OpenEdge.fromSpline(edge.start, vertex, leftSpline);
    final edge2 = OpenEdge.fromSpline(vertex, edge.end, rightSpline);
    _onCutEdge(edge, [vertex], [edge1, edge2]);

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

    _onCutEdge(edge, [vertex], [newEdge]);
    return .new(vertex: vertex, edge: newEdge);
  }

  MultiEdgeCutResult _multiCutOpenEdge(OpenEdge edge, List<double> ts) {
    final splines = edge.spline.splitMultiple(ts);
    final vertices = <Vertex>[];
    final newEdges = <OpenEdge>[];

    for (var i = 0; i < splines.length; i++) {
      final spline = splines[i];

      final startVertex = i == 0 ? edge.start : vertices[i - 1];
      final endVertex = i == splines.length - 1 ? edge.end : Vertex(spline.knots.last.p.clone());
      if (i != splines.length - 1) vertices.add(endVertex);

      final newEdge = OpenEdge.fromSpline(startVertex, endVertex, spline);
      newEdges.add(newEdge);
    }

    _onCutEdge(edge, vertices, newEdges);
    return .new(vertices: vertices, edges: newEdges);
  }

  MultiEdgeCutResult _multiCutClosedEdge(ClosedEdge edge, List<double> ts) {
    const knotEps = 1e-9;

    final _ts = List<double>.from(ts)..sort();
    for (final t in _ts) {
      if (!(t > 0 && t < 1)) throw ArgumentError.value(t, 't', 'must be in range (0, 1)');
    }

    for (var i = 1; i < _ts.length; i++) {
      if ((_ts[i] - _ts[i - 1]).abs() < 1e-9) {
        throw ArgumentError.value(ts, 'ts', 'values must be unique (also not near-coincident)');
      }
    }

    final seamT = _ts.first;
    final n = edge.spline.segmentCount;
    final scaledSeam = seamT * n;

    var kSeam = scaledSeam.floor();
    var uSeam = scaledSeam - kSeam;
    if (uSeam < knotEps) {
      uSeam = 0;
    } else if (uSeam > 1 - knotEps) {
      uSeam = 0;
      kSeam += 1;
    }
    kSeam %= n;

    double _remapT(double t) {
      final scaledT = t * n;
      var k = scaledT.floor();
      var u = scaledT - k;
      if (u < knotEps) {
        u = 0;
      } else if (u > 1 - knotEps) {
        u = 0;
        k += 1;
      }
      k %= n;

      if (uSeam == 0.0) {
        final j = (k - kSeam + n) % n;
        return ((j + u) / n).clamp(0, 1);
      }

      if (k == kSeam) {
        if (u >= uSeam) {
          final local = (u - uSeam) / (1 - uSeam);
          return (local / (n + 1)).clamp(0, 1);
        } else {
          final local = u / uSeam;
          return ((n + local) / (n + 1)).clamp(0, 1);
        }
      }

      final j = (k - kSeam + n) % n;
      return ((j + u) / (n + 1)).clamp(0, 1);
    }

    final firstCutResult = _cutClosedEdge(edge, seamT);
    final remaining = _ts.skip(1).map(_remapT).toList();
    final result = _multiCutOpenEdge(firstCutResult.edge, remaining);
    return MultiEdgeCutResult(
      vertices: [firstCutResult.vertex, ...result.vertices],
      edges: [...result.edges],
    );
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
