part of 'vector_complex.dart';

const _uuid = UuidV4();

/// A cell is the topological unit of the graph. It can be a:
/// - [Vertex] - a point in the plane
/// - [Edge] (open or closed) - a curve connecting two vertices (or a loop curve with no connections)
/// - [Face] - a region bounded by cycles of edges
///
/// Cells are identified with a UUID (`id`). Cells have a `star`, which is the set of cells whose direct boundary
/// contains this cell. For example, the star of a vertex contains all edges that contain it.
///
/// The cells are also doubly-linked in order to allow for an efficient traversal of the graph in the depth order.
sealed class Cell {
  Cell({String? id}) : id = id ?? _uuid.generate();

  /// Unique identifier of a cell.
  final String id;
  Cell? _prev, _next;

  /// Set of cells whose direct boundary contains this cell.
  UnmodifiableSetView<Cell> get directStar => UnmodifiableSetView(_directStar);
  final Set<Cell> _directStar = {};

  /// Complete star of a cell, which is the set of all cells that are connected to this cell.
  Set<Cell> get star {
    final s = <Cell>{};
    s.addAll(directStar);
    for (final c in directStar) s.addAll(c.star);
    return s;
  }

  /// Direct boundary of a given cell.
  Set<Cell> get directBoundary;

  /// Complete boundary of a cell, which is the set of all cells that are contained in this cell.
  Set<Cell> get boundary {
    final b = <Cell>{};
    b.addAll(directBoundary);
    for (final c in directBoundary) b.addAll(c.boundary);
    return b;
  }

  /// Previous cell in the depth order.
  Cell? get prev => _prev;

  /// Next cell in the depth order.
  Cell? get next => _next;
}

/// A vertex is a topological unit that represents a point in the plane. It can be connected to other vertices by edges.
///
/// Geometrically a vertex is also a single point on a plane.
final class Vertex extends Cell {
  Vertex(this.position, {super.id});
  Vector2 position;

  @override
  Set<Cell> get directBoundary => <Cell>{};
}

/// An edge is a topological unit that represents:
///
/// - A curve connecting two vertices (open edge)
/// - A loop curve with no connections (closed edge)
///
/// Geometrically, an edge is a curve in the plane. The curve is represented by a [CubicSpline2] (a sequence of cubics).
sealed class Edge extends Cell {
  Edge({super.id});
  CubicSpline2 get spline;
}

/// An open edge is a curve connecting two vertices.
///
/// Geometrically, it's represented by a cubic spline that:
/// - starts at the position of the `start` vertex with a tangent defined by `c1`
/// - continues with a list of knots
/// - ends at the position of the `end` vertex with a tangent defined by `c2`
final class OpenEdge extends Edge {
  OpenEdge(
    this._start,
    this._end, {
    this.c1,
    this.c2,
    List<CubicKnot2>? interior,
    super.id,
  }) : interior = interior ?? [] {
    _start._directStar.add(this);
    _end._directStar.add(this);
  }

  Vertex _start;
  Vertex get start => _start;
  set start(Vertex v) {
    _start._directStar.remove(this);
    _start = v;
    _start._directStar.add(this);
  }

  Vertex _end;
  Vertex get end => _end;
  set end(Vertex v) {
    _end._directStar.remove(this);
    _end = v;
    _end._directStar.add(this);
  }

  Vector2? c1;
  Vector2? c2;
  List<CubicKnot2> interior;

  @override
  CubicSpline2 get spline => .new([
    .new(start.position, c2: c1),
    ...interior,
    .new(end.position, c1: c2),
  ]);

  @override
  Set<Cell> get directBoundary => {start, end};
}

/// A closed edge represents a loop curve with no connections.
///
/// Geometrically, it's represented by a cubic spline that forms a closed loop.
final class ClosedEdge extends Edge {
  ClosedEdge(this.spline, {super.id});

  @override
  CubicSpline2 spline;

  @override
  Set<Cell> get directBoundary => <Cell>{};
}

/// A half edge represents an edge along with a direction.
final class HalfEdge {
  HalfEdge(this.edge, this.direction);

  final Edge edge;
  final bool direction;
}

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
}
