part of '../blueprint.dart';

class ShiftVerticesNode extends ShiftVerticesNodeBase {
  @override
  void execute() {
    final verticesInput = i.vertices.resolve();
    final shiftInput = i.shift.resolve();

    final output = <CellPrimitive>[];
    for (final (i, cell) in verticesInput.value.cells.indexed) {
      final context = EvaluationContext.filled(index: i, element: cell);

      output.add(switch (cell) {
        VertexPrimitive v => v.copyWith(position: v.position + shiftInput(context)),
        _ => cell,
      });
    }

    o.geometry.value = .constant(.new(cells: output));
  }
}
