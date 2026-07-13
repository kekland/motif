part of '../core.dart';

class VectorGeometry with ChangeNotifier, ChangeNotifierDisposable {
  VectorGeometry();

  final _cells = <int, CellBundle>{};
  Iterable<CellBundle> get cells => _cells.values;
  final _ownedCells = <int, List<int>>{};

  final _pendingPushes = <Cell>{};
  bool get isDirty => _pendingPushes.isNotEmpty;

  void push(Cell c) {
    _pendingPushes.add(c);
  }

  void flush() {
    for (final c in _pendingPushes) _push(c);
    _pendingPushes.clear();
  }

  void _push(Cell c, {int? owner}) {
    final _ = switch (c) {
      Vertex v => _pushVertex(v),
      Edge e => _pushEdge(e),
      _ => throw ArgumentError.value(c, 'c', 'Unsupported cell type'),
    };

    if (owner != null) {
      _ownedCells.putIfAbsent(owner, () => []).add(c.id);
    }
  }

  C _applyModifiers<C extends Modifiable<ImmutableCell>>(C cell) {
    _removeOwnedById(cell.id);

    ImmutableCell c = cell as ImmutableCell;
    final additionalCells = <ImmutableCell>[];

    for (final modifier in cell.modifiers) {
      if (!modifier.isEnabled) continue;

      final (modifiedCell, newCells) = modifier.apply(c);
      c = modifiedCell;
      additionalCells.addAll(newCells);
    }

    for (final cell in additionalCells) _push(cell, owner: c.id);
    return c as C;
  }

  void _pushVertex(Vertex v) {
    final vertex = _applyModifiers(v.asImmutable());

    final id = vertex.id;
    _cells[id] = .vertex(vertex.id, position: vertex.position);
  }

  void _pushEdge(Edge e) {
    final edge = _applyModifiers(e.asImmutable(e.start.asImmutable(), e.end.asImmutable()));

    final id = edge.id;
    _cells[id] = .edge(
      edge.id,
      path: edge.path.asImmutable(),
      decoration: edge.decoration.asImmutable(),
      weights: edge.weights.asImmutable(),
    );
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
