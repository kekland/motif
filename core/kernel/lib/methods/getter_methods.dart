part of '../kernel.dart';

extension GetterMethods on Bundle {
  // -------------------------------------------------------------------------------------------------------------------
  // Tree
  // -------------------------------------------------------------------------------------------------------------------

  FrameIndexStorage _treeParentStorage(CellKind k) {
    return switch (k) {
      .vertex => _vertex.parent,
      .edge => _edge.parent,
      .face => _face.parent,
      .frame => _frame.parent,
    };
  }

  CellIndexStorage _treeSiblingPrevStorage(CellKind k) {
    return switch (k) {
      .vertex => _vertex.siblingPrev,
      .edge => _edge.siblingPrev,
      .face => _face.siblingPrev,
      .frame => _frame.siblingPrev,
    };
  }

  CellIndexStorage _treeSiblingNextStorage(CellKind k) {
    return switch (k) {
      .vertex => _vertex.siblingNext,
      .edge => _edge.siblingNext,
      .face => _face.siblingNext,
      .frame => _frame.siblingNext,
    };
  }

  CellIndex _treeSiblingPrev(CellIndex t) {
    if (t.isNone) return .none;
    return _treeSiblingPrevStorage(t.kind)[t.index];
  }

  CellIndex _treeSiblingNext(CellIndex t) {
    if (t.isNone) return .none;
    return _treeSiblingNextStorage(t.kind)[t.index];
  }

  FrameIndex _treeParentOf(CellIndex t) {
    if (t.isNone) return .none;
    return _treeParentStorage(t.kind)[t.index];
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Frame
  // -------------------------------------------------------------------------------------------------------------------

  Iterable<CellIndex> _frameChildren(FrameIndex f) sync* {
    for (var c = _frame.childHead[f]; c != .none; c = _treeSiblingNext(c)) yield c;
  }

  CellIndex _frameChildHead(FrameIndex f) => _frame.childHead[f];

  bool _frameHasChildren(FrameIndex f) => _frame.childHead[f] != .none;

  Iterable<CoframeIndex> _frameDependents(FrameIndex f) sync* {
    for (var c = _frame.dependentStart[f]; c != .none; c = _coframe.dependentNext[c]) yield c;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Coframe
  // -------------------------------------------------------------------------------------------------------------------

  // -------------------------------------------------------------------------------------------------------------------
  // Vertex
  // -------------------------------------------------------------------------------------------------------------------

  Iterable<CovertexIndex> _vertexDisk(VertexIndex v) sync* {
    for (var c = _vertex.diskStart[v]; c != .none; c = _covertex.diskNext[c]) yield c;
  }

  Iterable<CovertexIndex> _vertexDiskLive(VertexIndex v) sync* {
    for (final cv in _vertexDisk(v)) if (_edge.isLive(_covertex.edge[cv])) yield cv;
  }

  bool _vertexHasUses(VertexIndex v) => _vertexDiskLive(v).isNotEmpty;

  Iterable<EdgeIndex> _vertexEdges(VertexIndex v) sync* {
    for (final cv in _vertexDiskLive(v)) yield _covertex.edge[cv];
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Covertex
  // -------------------------------------------------------------------------------------------------------------------

  Covertex _covertexFor(CovertexIndex cv) {
    assert(cv.isNotNone);
    return .new(_edge.handleFor(_covertex.edge[cv]), isStart: _covertex.isStart[cv]);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Edge
  // -------------------------------------------------------------------------------------------------------------------

  Iterable<CovertexIndex> _edgeCovertices(EdgeIndex e) sync* {
    yield _edge.cvStart[e];
    yield _edge.cvEnd[e];
  }

  Iterable<CoedgeIndex> _edgeRadial(EdgeIndex e) sync* {
    for (var c = _edge.radialStart[e]; c != .none; c = _coedge.radialNext[c]) yield c;
  }

  Iterable<CoedgeIndex> _edgeRadialLive(EdgeIndex e) sync* {
    for (final ce in _edgeRadial(e)) if (_face.isLive(_coedge.face[ce])) yield ce;
  }

  bool _edgeHasUses(EdgeIndex e) => _edgeRadialLive(e).isNotEmpty;

  Iterable<FaceIndex> _edgeFaces(EdgeIndex e) sync* {
    for (final ce in _edgeRadialLive(e)) yield _coedge.face[ce];
  }

  VertexIndex _edgeStart(EdgeIndex e) => _edge.vStart[e];
  VertexIndex _edgeEnd(EdgeIndex e) => _edge.vEnd[e];
  Iterable<VertexIndex> _edgeVertices(EdgeIndex e) sync* {
    final start = _edgeStart(e), end = _edgeEnd(e);
    if (start == end) {
      yield start;
    } else {
      yield start;
      yield end;
    }
  }

  _EdgeChain _chainEdges(List<EdgeHandle> edges) {
    if (edges.isEmpty) throw ArgumentError.value(edges, 'edges', 'must not be empty');

    final forward = <bool>[];
    final vertices = <VertexHandle>[];

    {
      final a = edgeStart(edges.first), b = edgeEnd(edges.first);
      if (edges.length == 1) {
        forward.add(true);
        vertices.add(a);
        vertices.add(b);
        return .new(vertices, edges, forward);
      }

      final next = {edgeStart(edges[1]), edgeEnd(edges[1])};
      if (next.contains(b)) {
        forward.add(true);
        vertices.add(a);
        vertices.add(b);
      } else if (next.contains(a)) {
        forward.add(false);
        vertices.add(b);
        vertices.add(a);
      } else {
        throw ArgumentError.value(edges, 'edges', 'edges do not chain');
      }
    }

    for (var k = 1; k < edges.length; k++) {
      final e = edges[k];
      final a = edgeStart(e), b = edgeEnd(e);

      final cursor = vertices.last;
      if (a == cursor) {
        forward.add(true);
        vertices.add(b);
      } else if (b == cursor) {
        forward.add(false);
        vertices.add(a);
      } else {
        throw ArgumentError.value(edges, 'edges', 'edges do not chain');
      }
    }

    return .new(vertices, edges, forward);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Coedge
  // -------------------------------------------------------------------------------------------------------------------

  Coedge _coedgeFor(CoedgeIndex ce) {
    assert(ce.isNotNone);
    return .new(_edge.handleFor(_coedge.edge[ce]), forward: _coedge.direction[ce]);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Cycle
  // -------------------------------------------------------------------------------------------------------------------

  Cycle _cycleFor(CoedgeIndex head) {
    final out = <Coedge>[];
    var i = head;
    do {
      out.add(_coedgeFor(i));
      i = _coedge.cycleNext[i];
    } while (i != head);
    return .new(out);
  }

  List<CoedgeIndex> _cycleCoedges(CoedgeIndex head) {
    final out = <CoedgeIndex>[];
    var i = head;
    do {
      out.add(i);
      i = _coedge.cycleNext[i];
    } while (i != head);
    return out;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Face
  // -------------------------------------------------------------------------------------------------------------------

  List<CoedgeIndex> _faceBoundary(FaceIndex f) => _face.boundary[f].storage;

  // -------------------------------------------------------------------------------------------------------------------
  // Cell
  // -------------------------------------------------------------------------------------------------------------------

  H _cellHandle<H extends CellHandle>(CellIndex t) {
    assert(t.isNotNone);
    return switch (t.kind) {
      .frame => _frame.handleFor(t.asFrame),
      .vertex => _vertex.handleFor(t.asVertex),
      .edge => _edge.handleFor(t.asEdge),
      .face => _face.handleFor(t.asFace),
    } as H;
  }

  CoframeIndex _cellCrossStart(CellIndex c) => switch (c.kind) {
    .edge => _edge.crossStart[c.asEdge],
    .face => _face.crossStart[c.asFace],
    .frame || .vertex => .none,
  };

  Iterable<CoframeIndex> _cellCross(CellIndex c) sync* {
    for (var cf = _cellCrossStart(c); cf != .none; cf = _coframe.crossNext[cf]) yield cf;
  }

  Iterable<CellIndex> _cellDependents(CellIndex c) {
    return switch (c.kind) {
      .frame => _frameChildren(c.asFrame),
      .vertex => _vertexEdges(c.asVertex).map((e) => e.cell),
      .edge => _edgeFaces(c.asEdge).map((f) => f.cell),
      .face => .empty(),
    };
  }

  Iterable<CellIndex> _cellDependencies(CellIndex c) {
    final out = <CellIndex>[];

    if (c.kind == .edge) {
      out.add(_edge.vStart[c.asEdge].cell);
      out.add(_edge.vEnd[c.asEdge].cell);
    } else if (c.kind == .face) {
      for (final head in _faceBoundary(c.asFace)) {
        for (final ce in _cycleCoedges(head)) {
          out.add(_coedge.edge[ce].cell);
        }
      }
    }

    return out;
  }
}
