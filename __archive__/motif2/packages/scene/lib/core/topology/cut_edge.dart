part of '../core.dart';

final class EdgeCutResult {
  const EdgeCutResult({
    required this.vertex,
    required this.edge1,
    required this.edge2,
  });

  final Vertex vertex;
  final Edge edge1;
  final Edge edge2;
}

final class MultiEdgeCutResult {
  const MultiEdgeCutResult({required this.vertices, required this.edges});

  final List<Vertex> vertices;
  final List<Edge> edges;
}

TopologyId? _getCutVertexId(TopologyId? base, int index) {
  if (base == null) return null;
  return .from3(base, 'cut_v', index);
}

TopologyId? _getCutEdgeId(TopologyId? base, int index) {
  if (base == null) return null;
  return .from3(base, 'cut_e', index);
}

void _onCutEdge(Edge originalEdge, List<Vertex> vertices, List<Edge> newEdges) {
  final topology = originalEdge.topology;
  topology.addAll([...vertices, ...newEdges], after: originalEdge);

  final walk1 = <HalfEdge>[]; // positive walk
  final walk2 = <HalfEdge>[]; // negative walk

  for (var i = 0; i < newEdges.length; i++) {
    final j = newEdges.length - 1 - i;
    walk1.add(.from(newEdges[i], true));
    walk2.add(.from(newEdges[j], false));
  }

  for (final face in originalEdge.star.whereType<Face>().toList()) {
    final newCycles = <Cycle>[];

    for (final cycle in face.geometry.cycles) {
      final halfEdges = <HalfEdge>[];
      for (final he in cycle.halfEdges) {
        if (he.id == originalEdge.id) {
          halfEdges.addAll(he.direction ? walk1 : walk2);
        } else {
          halfEdges.add(he);
        }
      }

      newCycles.add(.new(halfEdges));
    }

    face.geometry.cycles = newCycles;
  }

  topology.remove(originalEdge);
}

extension TopologyCutEdge on Topology {
  EdgeCutResult cutEdge(Edge target, double t) {
    if (target.owner != null) {
      return target.owner!.cutEdge(target, t);
    }

    final (leftPath, rightPath) = target.path.split(t);

    final splitPosition = leftPath.last.p.clone();

    final baseId = target.topologyId;

    final vertex = Vertex(splitPosition, topologyId: _getCutVertexId(baseId, 0));
    final edge1 = Edge(target.start, vertex, path: leftPath, topologyId: _getCutEdgeId(baseId, 0));
    final edge2 = Edge(vertex, target.end, path: rightPath, topologyId: _getCutEdgeId(baseId, 1));

    _onCutEdge(target, [vertex], [edge1, edge2]);

    return EdgeCutResult(
      vertex: vertex,
      edge1: edge1,
      edge2: edge2,
    );
  }

  MultiEdgeCutResult multiCutEdge(Edge target, List<double> ts) {
    final paths = target.path.splitMultiple(ts);

    final baseId = target.topologyId;

    final vertices = <Vertex>[];
    final newEdges = <Edge>[];

    for (var i = 0; i < paths.length; i++) {
      final path = paths[i];

      final startVertex = i == 0 ? target.start : vertices[i - 1];

      late final Vertex endVertex;
      if (i == paths.length - 1) {
        endVertex = target.end;
      } else {
        endVertex = Vertex(path.knots.last.p.clone(), topologyId: _getCutVertexId(baseId, i));
        vertices.add(endVertex);
      }

      final newEdge = Edge(
        startVertex,
        endVertex,
        path: path,
        topologyId: _getCutEdgeId(baseId, i),
      );

      newEdges.add(newEdge);
    }

    _onCutEdge(target, vertices, newEdges);

    return MultiEdgeCutResult(
      vertices: vertices,
      edges: newEdges,
    );
  }
}
