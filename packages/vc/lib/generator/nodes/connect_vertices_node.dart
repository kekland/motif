part of '../blueprint.dart';

class ConnectVerticesNode extends ConnectVerticesNodeBase {
  @override
  void execute() {
    final geometryInput = i.vertices.resolve();

    final output = <CellPrimitive>[];
    output.addAll(geometryInput.value.cells);

    VertexPrimitive? _lastVertex;
    for (final cell in geometryInput.value.cells) {
      if (cell is! VertexPrimitive) continue;

      if (_lastVertex != null) {
        final cubic = Cubic2.line(_lastVertex.position.clone(), cell.position.clone());

        final edge = EdgePrimitive(
          startId: _lastVertex.id,
          endId: cell.id,
          path: .cubics([cubic]),
        );
        output.add(edge);
      }

      _lastVertex = cell;
    }

    o.geometry.value = .constant(.new(cells: output));
  }
}
