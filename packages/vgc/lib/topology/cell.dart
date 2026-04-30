part of '../vector_complex.dart';

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
  int get degree => directStar.length;

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

  Cell? get prev => _prev;
  Cell? get next => _next;

  /// Returns the approximate bounding box of this cell.
  Aabb2 get boundingBoxApproximate;
}
