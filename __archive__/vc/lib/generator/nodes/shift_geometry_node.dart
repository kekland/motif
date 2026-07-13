part of '../blueprint.dart';

class ShiftGeometryNode extends ShiftGeometryNodeBase {
  @override
  void execute() {
    final geometryInput = i.geometry.resolve();
    final shiftInput = i.shift.resolve();

    final output = <CellPrimitive>[];
    for (final (i, cell) in geometryInput.value.cells.indexed) {
      final context = EvaluationContext.filled(index: i, element: cell);
      final shift = shiftInput.evaluate(context);
      final transform = Matrix4.translationValues(shift.x, shift.y, 0.0);
      output.add(cell.transform(transform));
    }

    o.geometry.value = .constant(.new(cells: output));
  }
}
