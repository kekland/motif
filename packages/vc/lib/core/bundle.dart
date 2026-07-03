part of 'core.dart';

class CellBundle {
  CellBundle({required this.cells});

  final List<Cell> cells;
  Iterable<Vertex> get vertices => cells.whereType<Vertex>();
  Iterable<Edge> get edges => cells.whereType<Edge>();
}

class PrimitiveBundle {
  PrimitiveBundle({required this.cells});

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
}
