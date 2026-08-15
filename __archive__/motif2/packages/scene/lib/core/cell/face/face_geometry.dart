part of '../../core.dart';

final class FaceGeometry {
  FaceGeometry(List<Cycle>? cycles) : _cycles = cycles ?? [];

  Face? _face;
  void _setFace(Face face) {
    if (_face == face) return;
    _face = face;
  }

  List<Cycle> _cycles;
  List<Cycle> get cycles => _cycles;
  set cycles(List<Cycle> newCycles) {
    for (final c in _cycles) c._detachFromTopology();
    _cycles = newCycles;
    for (final c in _cycles) c._attachToTopology(_face!);
    _face?._markNeedsLayout();
  }

  Aabb2 get bbox {
    final edges = _cycles.expand((c) => c.edges);
    final bboxes = edges.map((e) => e.bbox);
    return bboxes.bbox;
  }

  void _attachToTopology(Topology topology) {
    for (final c in _cycles) c._attachToTopology(_face!);
  }

  void _detachFromTopology() {
    for (final c in _cycles) c._detachFromTopology();
  }
}

final class HalfEdge {
  HalfEdge(this.id, this.direction);
  HalfEdge.from(Edge edge, bool direction) : this(edge.id, direction);

  final NodeId id;
  final bool direction;

  HalfEdge reversed() => HalfEdge(id, !direction);

  Edge get edge => _topology!.getById(id);

  Topology? _topology;
}

final class Cycle {
  Cycle(this.halfEdges);

  final List<HalfEdge> halfEdges;

  Face? _face;
  void _attachToTopology(Face face) {
    final topology = face._topology;
    _face = face;
    for (final halfEdge in halfEdges) {
      halfEdge._topology = topology;
      topology?._addStar(halfEdge.id, face);
    }
  }

  void _detachFromTopology() {
    for (final halfEdge in halfEdges) {
      _face!._topology?._removeStar(halfEdge.id, _face!);
      halfEdge._topology = null;
    }
    _face = null;
  }

  bool get isEmpty => halfEdges.isEmpty;

  Iterable<NodeId> get ids => halfEdges.map((he) => he.id);
  Iterable<Edge> get edges => halfEdges.map((he) => he.edge);
}
