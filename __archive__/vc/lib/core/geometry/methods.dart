part of '../core.dart';

extension DeflateBundle on CellBundle {
  PrimitiveBundle deflate(VectorComplexContext context) {
    final cells = <CellId, CellPrimitive>{};

    final toProcess = Queue<Cell>.from(this._cells);
    while (toProcess.isNotEmpty) {
      var cell = toProcess.removeFirst();

      for (final modifier in cell.modifiers) {
        if (!modifier.isEnabled) continue;

        final (modifiedCell, newCells) = modifier.apply(context, cell);
        cell = modifiedCell;
        toProcess.addAll(newCells);
      }

      cells[cell.id] = cell.deflate();
    }

    return .new(cells: cells.values.toList());
  }
}
