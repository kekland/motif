part of '../vector_complex.dart';

/// A cycle is a:
/// - Single vertex ([SteinerCycle])
/// - A sequence of connected half edges ([RegularCycle])
sealed class Cycle {
  Iterable<Cell> get _cells;
}

/// A cycle that consists of a single vertex.
final class SteinerCycle extends Cycle {
  SteinerCycle(this.vertex);
  final Vertex vertex;

  @override
  Iterable<Cell> get _cells => [vertex];
}

/// A cycle that consists of a sequence of connected half edges.
final class RegularCycle extends Cycle {
  RegularCycle(this._halfEdges);

  final List<HalfEdge> _halfEdges;
  UnmodifiableListView<HalfEdge> get halfEdges => .new(_halfEdges);

  @override
  Iterable<Cell> get _cells => _halfEdges.map((he) => he.edge);
}
