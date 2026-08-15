part of '../core.dart';

final class ReconciliationResult {
  const ReconciliationResult({
    required this.cells,
    required this.deadCells,
    required this.danglingCells,
  });

  final List<Cell> cells;
  final List<Cell> deadCells;
  final List<Cell> danglingCells;
}

extension TopologyReconciliation on Topology {
  ReconciliationResult reconcile(Topology previousTopology) {
    final newTopologyCells = <Cell>[];
    final deadCells = previousTopology.cells.toSet();

    final transientToLiveId = <NodeId, NodeId>{};
    for (final tCell in cells) {
      var liveCell = previousTopology.maybeGet(tCell.topologyId);
      if (liveCell != null) {
        liveCell.setFrom(tCell);
        deadCells.remove(liveCell);
      } else {
        liveCell = tCell;
      }

      newTopologyCells.add(liveCell);
      transientToLiveId[tCell.id] = liveCell.id;
    }

    for (var i = 0; i < cells.length; i++) {
      final tCell = cells[i];
      final liveCell = newTopologyCells[i];
      _replaceCellConnections(liveCell, transientToLiveId, transient: tCell);
    }

    final danglingCells = <Cell>[];
    for (final oldCell in deadCells) {
      final externalConnections = oldCell.star.where((c) => !previousTopology.cells.contains(c)).toList();
      if (externalConnections.isEmpty) continue;

      var replacementCell = newTopologyCells.firstWhereOrNull((c) => c.topologyId == oldCell.topologyId);
      replacementCell ??= closestCellTo(oldCell);

      if (replacementCell == null) {
        replacementCell = oldCell;
        danglingCells.add(replacementCell);
      }

      for (final extCell in externalConnections) {
        oldCell._removeStar(extCell);
        replacementCell._addStar(extCell);
        _replaceCellConnections(extCell, {oldCell.id: replacementCell.id});
      }
    }

    return ReconciliationResult(
      cells: newTopologyCells,
      deadCells: deadCells.toList(),
      danglingCells: danglingCells,
    );
  }

  void _replaceCellConnections(Cell c, Map<NodeId, NodeId> ids, {Cell? transient}) {
    if (c is Edge) {
      final e = (transient ?? c) as Edge;
      if (ids.containsKey(e.startId)) c._startId = ids[e.startId]!;
      if (ids.containsKey(e.endId)) c._endId = ids[e.endId]!;
    }

    if (c is Face) {
      final f = (transient ?? c) as Face;

      final cycles = <Cycle>[];
      for (final cycle in f.geometry.cycles) {
        final halfEdges = <HalfEdge>[];
        for (var i = 0; i < cycle.halfEdges.length; i++) {
          final he = cycle.halfEdges[i];
          if (ids.containsKey(he.id)) {
            halfEdges.add(HalfEdge(ids[he.id]!, he.direction));
          } else {
            halfEdges.add(he);
          }
        }
        
        final newCycle = Cycle(halfEdges);
        newCycle._attachToTopology(c);
        cycles.add(newCycle);
      }

      c.geometry._cycles = cycles;
    }
  }

  Cell? closestCellTo(Cell c) {
    return switch (c) {
      Vertex vertex => closestVertexTo(vertex.position),
      Edge edge => closestEdgeTo(edge.path),
      Face _ => null,
    };
  }

  Vertex? closestVertexTo(Vector2 position) {
    var minDistSq = double.infinity;
    Vertex? closestVertex;

    for (final v in vertices) {
      final distSq = (v.position - position).length2;
      if (distSq < minDistSq) {
        minDistSq = distSq;
        closestVertex = v;
      }
    }

    return closestVertex;
  }

  Edge? closestEdgeTo(CubicSpline2 path) {
    // TODO: Refine this
    var minDistSq = double.infinity;
    final center = path.bbox.center;
    Edge? closestEdge;

    for (final e in edges) {
      final distSq = (e.path.bbox.center - center).length2;
      if (distSq < minDistSq) {
        minDistSq = distSq;
        closestEdge = e;
      }
    }

    return closestEdge;
  }
}
