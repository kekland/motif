part of '../../vector_complex.dart';

extension CutEdge on VectorComplex {
  EdgeCutResult cutEdge(Edge edge, double t) {
    if (!contains(edge)) throw ArgumentError('Edge is not part of this complex');
    if (t < 0 || t > 1) throw ArgumentError.value(t, 't', 'must be between 0 and 1');

    return switch (edge) {
      OpenEdge e => _cutOpenEdge(e, t),
      ClosedEdge e => _cutClosedEdge(e, t),
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

    // TODO: Faces
    // final affectedFaces = edge.directStar.whereType<Face>();
    // for (final face in affectedFaces) {
    //   face.cycles = [
    //     for (final cycle in face.cycles)

    //   ];
    // }

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

    // TODO: Faces

    hardDelete(edge);
    return .new(vertex: vertex, edge: newEdge);
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
