part of '../core.dart';

class VectorGeometry {
  VectorGeometry(this.context);
  final VectorComplexContext context;

  final _cells = <CellId, Cell>{};
  Iterable<Cell> get cells => _cells.values;
  final _ownedCells = <CellId, List<CellId>>{};

  final _pendingPushes = <Cell>{};
  bool get isDirty => _pendingPushes.isNotEmpty;

  void push(Cell c) {
    _pendingPushes.add(c);
  }

  void flush() {
    for (final c in _pendingPushes) _push(c);
    _pendingPushes.clear();
  }

  void _push(Cell c, {CellId? owner}) {
    _removeOwnedById(c.id);

    Cell cell = c;
    final additionalCells = <Cell>[];

    for (final modifier in cell.modifiers) {
      if (!modifier.isEnabled) continue;

      final (modifiedCell, newCells) = modifier.apply(context, c);
      c = modifiedCell;
      additionalCells.addAll(newCells);
    }

    for (final cell in additionalCells) _push(cell, owner: c.id);

    final id = c.id;
    _cells[id] = cell;

    if (owner != null) {
      _ownedCells.putIfAbsent(owner, () => []).add(c.id);
    }
  }

  void _removeOwnedById(int id) {
    final ownedIds = _ownedCells.remove(id);
    if (ownedIds != null) {
      for (final id in ownedIds) _removeById(id);
    }
  }

  void _removeById(int id) {
    _cells.remove(id);
    _removeOwnedById(id);
  }

  void remove(Cell c) {
    _removeById(c.id);
  }

  Aabb2 get bbox {
    if (_cells.isEmpty) return .minMax(.zero(), .zero());

    final min = _cells.values.first.bbox.min;
    final max = _cells.values.first.bbox.max;
    for (final c in _cells.values.skip(1)) {
      Vector2.min(c.bbox.min, min, min);
      Vector2.max(c.bbox.max, max, max);
    }

    return .minMax(min, max);
  }
}
