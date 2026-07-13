part of '../blueprint.dart';

class GeometryInputNode extends GeometryInputNodeBase {
  @override
  void execute() {
    final cell = this.cell;

    final cells = <CellPrimitive>[];
    if (cell is Vertex) {
      cells.add(cell.deflate());
    } else if (cell is Edge) {
      cells.add(cell.start.deflate());
      cells.add(cell.end.deflate());
      cells.add(cell.deflate());
    }

    final bundle = PrimitiveBundle(cells: cells);
    assert(bundle.assertValid());

    o.geometry.value = .constant(bundle);
  }
}
