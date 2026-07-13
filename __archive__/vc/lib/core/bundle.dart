part of 'core.dart';

class CellBundle {
  CellBundle._(this._cells);

  factory CellBundle({required List<Cell> cells}) {
    final vertices = <Vertex, Vertex>{};
    for (final v in cells.whereType<Vertex>()) {
      vertices[v] = v.copyWith();
    }

    final edges = <Edge, Edge>{};
    for (final e in cells.whereType<Edge>()) {
      final v1 = vertices.putIfAbsent(e.start, () => e.start.copyWith());
      final v2 = vertices.putIfAbsent(e.end, () => e.end.copyWith());
      edges[e] = e.copyWith(start: v1, end: v2);
    }

    final newCells = <Cell>[];
    for (final c in cells) {
      final instance = switch (c) {
        Vertex v => vertices[v]!,
        Edge e => edges[e]!,
      };

      newCells.add(instance);
    }

    return ._(newCells);
  }

  final List<Cell> _cells;
  Iterable<Vertex> get vertices => _cells.whereType<Vertex>();
  Iterable<Edge> get edges => _cells.whereType<Edge>();

  List<Cell> get cells {
    // Produce a fresh set of cells
    final bundle = CellBundle(cells: _cells);
    return bundle._cells;
  }
}

class PrimitiveBundle {
  PrimitiveBundle({required this.cells});
  PrimitiveBundle.empty() : cells = [];

  static PrimitiveBundle merge(List<PrimitiveBundle> bundles) {
    final mergedCells = <CellPrimitive>[];
    for (final bundle in bundles) mergedCells.addAll(bundle.cells);
    return .new(cells: mergedCells);
  }

  final List<CellPrimitive> cells;
  Iterable<VertexPrimitive> get vertices => cells.whereType<VertexPrimitive>();
  Iterable<EdgePrimitive> get edges => cells.whereType<EdgePrimitive>();

  C get<C extends CellPrimitive>(CellId id) => cells.firstWhere((c) => c.id == id) as C;

  CellBundle inflate() {
    final cells = <CellId, Cell>{};

    for (final v in vertices) cells[v.id] = v.inflate();
    for (final e in edges) {
      final v1 = cells[e.startId]! as Vertex;
      final v2 = cells[e.endId]! as Vertex;
      cells[e.id] = e.inflate(v1, v2);
    }

    return .new(cells: cells.values.toList());
  }

  PrimitiveBundle transform(Matrix4 transform) {
    final transformedCells = cells.map((c) => c.transform(transform)).toList();
    return .new(cells: transformedCells);
  }

  PrimitiveBundle withNewIds() {
    final newCells = <CellId, CellPrimitive>{};

    for (final v in vertices) newCells[v.id] = v.copyWith(id: .none);
    for (final e in edges) {
      final v1 = newCells[e.startId] as VertexPrimitive;
      final v2 = newCells[e.endId] as VertexPrimitive;
      newCells[e.id] = e.copyWith(id: .none, startId: v1.id, endId: v2.id);
    }

    return .new(cells: newCells.values.toList());
  }

  bool assertValid() {
    for (final e in edges) {
      if (!cells.any((c) => c.id == e.startId)) return false;
      if (!cells.any((c) => c.id == e.endId)) return false;
    }

    return true;
  }
}
