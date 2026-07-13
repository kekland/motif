part of '../blueprint.dart';

class JoinGeometryNode extends JoinGeometryNodeBase {
  @override
  void execute() {
    final geometryInput = i.geometry.resolve();
    final inputs = geometryInput.evaluate();

    final cells = <CellPrimitive>[];
    for (final input in inputs) {
      cells.addAll(input.cells);
    }

    final bundle = PrimitiveBundle(cells: cells);
    o.geometry.value = .constant(bundle);
  }
}
