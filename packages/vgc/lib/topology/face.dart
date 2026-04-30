part of '../vector_complex.dart';


/// A face is a topological unit that represents a region bounded by cycles with holes (i.e. a face can have multiple
/// cycles, one of which is the outer boundary and the others are holes, determined by the orientation of the cycles).
///
/// Geometrically, a face is a region in the plane bounded by the curves of the cycles.
final class Face extends Cell {
  Face(this._cycles, {super.id}) {
    for (final c in directBoundary) c._directStar.add(this);
  }

  List<Cycle> _cycles;
  Iterable<Cycle> get cycles => _cycles;
  set cycles(Iterable<Cycle> newCycles) {
    final before = directBoundary;
    _cycles = newCycles.toList();
    final after = directBoundary;

    for (final c in before.difference(after)) c._directStar.remove(this);
    for (final c in after.difference(before)) c._directStar.add(this);
  }

  @override
  Set<Cell> get directBoundary {
    final b = <Cell>{};

    for (final cycle in _cycles) {
      if (cycle is SteinerCycle) {
        b.add(cycle.vertex);
      } else if (cycle is RegularCycle) {
        for (final halfEdge in cycle._halfEdges) b.add(halfEdge.edge);
      }
    }

    return b;
  }

  @override
  Aabb2 get boundingBoxApproximate {
    var min = Vector2(.infinity, .infinity);
    var max = Vector2(.negativeInfinity, .negativeInfinity);

    for (final cycle in _cycles) {
      for (final cell in cycle._cells) {
        final aabb = cell.boundingBoxApproximate;
        Vector2.min(min, aabb.min, min);
        Vector2.max(max, aabb.max, max);
      }
    }

    return Aabb2.minMax(min, max);
  }
}
