part of '../kernel.dart';

extension TopologyMethods on Bundle {
  // -------------------------------------------------------------------------------------------------------------------
  // Tree
  // -------------------------------------------------------------------------------------------------------------------

  bool _treeCheckInsertion(FrameHandle? parent) {
    assert(parent == null || parent.index == .root || _liveFrame(parent));
    return true;
  }

  void _treeSetSiblingPrev(CellIndex t, CellIndex v) {
    final storage = _treeSiblingPrevStorage(t.kind);
    storage[t.index] = v;
  }

  void _treeSetSiblingNext(CellIndex t, CellIndex v) {
    final storage = _treeSiblingNextStorage(t.kind);
    storage[t.index] = v;
  }

  void _treeSiblingInsert(FrameIndex frame, CellIndex t) {
    final head = _frame.childHead[frame];
    _treeSetSiblingPrev(t, .none);
    _treeSetSiblingNext(t, head);
    if (head.isNotNone) _treeSetSiblingPrev(head, t);
    _frame.childHead[frame] = t;
  }

  void _treeSiblingUnlink(CellIndex t) {
    final frame = _treeParentOf(t);
    final p = _treeSiblingPrev(t), n = _treeSiblingNext(t);

    if (p.isNone) {
      _frame.childHead[frame] = n;
    } else {
      _treeSetSiblingNext(p, n);
    }

    if (n.isNotNone) _treeSetSiblingPrev(n, p);
    _treeSetSiblingPrev(t, .none);
    _treeSetSiblingNext(t, .none);
  }

  void _treeSetParent(CellHandle h, FrameHandle parent) {
    assert(_checkCell(h));
    assert(_treeCheckInsertion(parent));

    final t = h.cellIndex;
    final p = parent.index;
    if (_treeParentOf(t) == p) return;

    _treeSiblingUnlink(t);
    _treeParentStorage(t.kind)[t.index] = p;
    _treeSiblingInsert(p, t);

    final kind = t.kind;
    if (kind == .frame) {
      _frame.touch(t.asFrame);
      _frameInvalidateWorldTransforms();
      final cells = _frameDependents(p).map((cf) => _coframe.cell[cf]);
      for (final c in cells) _cellCrossUpdate(c);
    } else if (kind == .vertex) {
      _vertex.touch(t.asVertex);
      for (final e in _vertexEdges(t.asVertex)) {
        _edge.touch(e);
        _cellCrossUpdate(e.cell);
        for (final f in _edgeFaces(e)) _cellCrossUpdate(f.cell);
      }
    } else if (kind == .edge) {
      _edge.touch(t.asEdge);
      _cellCrossUpdate(t);
      for (final f in _edgeFaces(t.asEdge)) _cellCrossUpdate(f.cell);
    } else if (kind == .face) {
      _face.touch(t.asFace);
      _cellCrossUpdate(t);
    }
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Frame
  // -------------------------------------------------------------------------------------------------------------------

  FrameHandle _frameAdd(
    CellId id, {
    Mat4? transform,
    Size2? size,
    FrameHandle? parent,
  }) {
    assert(_treeCheckInsertion(parent));

    final i = _frame.alloc();
    final p = parent?.index ?? .root;

    _frame.transform[i] = transform?.copy() ?? .identity();
    _frame.size[i] = size ?? .zero();
    _frame.hasSize[i] = size != null;
    _frame.clip[i] = .none;
    _frame.childHead[i] = .none;
    _frame.dependentStart[i] = .none;

    _frameLink(i, p);
    _frame.id.assign(i, id);
    return _frame.handleFor(i);
  }

  void _frameLink(FrameIndex i, FrameIndex parent) {
    _frame.parent[i] = parent;
    _treeSiblingInsert(parent, i.cell);
    _frameInvalidateWorldTransforms();
  }

  void _frameRemove(FrameHandle h) {
    assert(_liveFrame(h));
    assert(_frame.childHead[h.index].isNone, 'cannot remove frame with children');
    _treeSiblingUnlink(h.cellIndex);
    _frame.ghost(h.index);
    _frameInvalidateWorldTransforms();
  }

  void _frameRelink(FrameHandle h, {FrameHandle? parent}) {
    assert(_ghostFrame(h));
    assert(_treeCheckInsertion(parent));
    _frame.relink(h.index);
    _frameLink(h.index, parent?.index ?? .root);
  }

  void _frameFree(FrameHandle h) {
    assert(_liveFrame(h));
    assert(_frame.childHead[h.index].isNone, 'cannot free frame with children');
    assert(_frame.dependentStart[h.index].isNone, 'cannot free frame with dependents');
    _treeSiblingUnlink(h.cellIndex);
    _frame.id.free(h.index);
    _frame.free(h.index);
    _frameInvalidateWorldTransforms();
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Coframe
  // -------------------------------------------------------------------------------------------------------------------

  CoframeIndex _coframeAdd(FrameIndex f, CellIndex c) {
    final cf = _coframe.alloc();
    _coframe.frame[cf] = f;
    _coframe.cell[cf] = c;
    _frameDependentsInsert(f, cf);
    _cellCrossInsert(c, cf);
    return cf;
  }

  void _coframeRemove(CoframeIndex cf) {
    _frameDependentsUnlink(_coframe.frame[cf], cf);
    _coframe.free(cf);
  }

  void _frameDependentsInsert(FrameIndex f, CoframeIndex cf) {
    _coframe.dependentNext[cf] = _frame.dependentStart[f];
    _frame.dependentStart[f] = cf;
  }

  void _frameDependentsUnlink(FrameIndex f, CoframeIndex cf) {
    var cur = _frame.dependentStart[f];
    if (cur == cf) {
      _frame.dependentStart[f] = _coframe.dependentNext[cf];
      return;
    }

    while (_coframe.dependentNext[cur] != cf) cur = _coframe.dependentNext[cur];
    _coframe.dependentNext[cur] = _coframe.dependentNext[cf];
  }

  void _cellCrossInsert(CellIndex c, CoframeIndex cf) {
    _coframe.crossNext[cf] = _cellCrossStart(c);
    _cellSetCrossStart(c, cf);
  }

  void _cellSetCrossStart(CellIndex c, CoframeIndex cf) => switch (c.kind) {
    .edge => _edge.crossStart[c.asEdge] = cf,
    .face => _face.crossStart[c.asFace] = cf,
    _ => throw ArgumentError('invalid cell kind for cross start: ${c.kind}'),
  };

  void _cellCrossRemove(CellIndex c) {
    for (var cf = _cellCrossStart(c); cf != .none;) {
      final next = _coframe.crossNext[cf];
      _coframeRemove(cf);
      cf = next;
    }
    if (c.kind == .edge || c.kind == .face) _cellSetCrossStart(c, .none);
  }

  void _cellCrossUpdate(CellIndex c) {
    _cellCrossRemove(c);
    if (c.kind != .edge && c.kind != .face) return;

    final own = _treeSpaceOf(c);
    final dependencies = _cellDependencies(c).toList();
    var lca = own, cross = false;
    for (final d in dependencies) {
      final f = _treeSpaceOf(d);
      if (f == own) continue;
      lca = _frameLca(lca, f);
      cross = true;
    }
    if (!cross) return;
    _cellCrossInsertPath(c, own, lca);
    for (final d in dependencies) _cellCrossInsertPath(c, _treeSpaceOf(d), lca);
  }

  void _cellCrossInsertPath(CellIndex c, FrameIndex from, FrameIndex to) {
    for (var f = from; f != to; f = _frame.parent[f]) _coframeAdd(f, c);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Vertex
  // -------------------------------------------------------------------------------------------------------------------

  VertexHandle _vertexAdd(
    CellId id,
    Vec2 position, {
    FrameHandle? parent,
  }) {
    assert(_treeCheckInsertion(parent));

    final i = _vertex.alloc();
    final frame = parent?.index ?? .root;

    _vertex.position[i] = position;
    _vertex.diskStart[i] = .none;
    _vertex.positionVersion[i] = -1;

    _vertexLink(i, frame);
    _vertex.id.assign(i, id);
    return _vertex.handleFor(i);
  }

  void _vertexLink(VertexIndex i, FrameIndex parent) {
    _vertex.parent[i] = parent;
    _treeSiblingInsert(parent, i.cell);
  }

  void _vertexRemove(VertexHandle h) {
    assert(_liveVertex(h));
    assert(!_vertexHasUses(h.index), 'cannot remove vertex with uses');
    _treeSiblingUnlink(h.cellIndex);
    _vertex.ghost(h.index);
  }

  void _vertexRelink(VertexHandle h, {FrameHandle? parent}) {
    assert(_ghostVertex(h));
    assert(_treeCheckInsertion(parent));
    _vertex.relink(h.index);
    _vertexLink(h.index, parent?.index ?? .root);
  }

  void _vertexFree(VertexHandle h) {
    assert(_liveVertex(h));
    assert(_vertex.diskStart[h.index].isNone, 'cannot free vertex with uses');
    _treeSiblingUnlink(h.cellIndex);
    _vertex.id.free(h.index);
    _vertex.free(h.index);
  }

  void _vertexDiskInsert(VertexIndex v, CovertexIndex cv) {
    _covertex.diskNext[cv] = _vertex.diskStart[v];
    _vertex.diskStart[v] = cv;
  }

  void _vertexDiskUnlink(VertexIndex v, CovertexIndex cv) {
    var cur = _vertex.diskStart[v];
    if (cur == cv) {
      _vertex.diskStart[v] = _covertex.diskNext[cv];
      return;
    }

    while (_covertex.diskNext[cur] != cv) cur = _covertex.diskNext[cur];
    _covertex.diskNext[cur] = _covertex.diskNext[cv];
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Covertex
  // -------------------------------------------------------------------------------------------------------------------

  CovertexIndex _covertexAdd(VertexIndex v, EdgeIndex e, {required bool isStart, Vec2? tangent}) {
    assert(_vertex.isLive(v));
    final cv = _covertex.alloc();
    _covertex.vertex[cv] = v;
    _covertex.edge[cv] = e;
    _covertex.isStart[cv] = isStart;
    _covertex.tangent[cv] = tangent ?? .zero();
    _vertexDiskInsert(v, cv);
    return cv;
  }

  void _covertexRemove(CovertexIndex cv) {
    _vertexDiskUnlink(_covertex.vertex[cv], cv);
    _covertex.free(cv);
  }

  bool _covertexRepoint(CovertexIndex cv, {required VertexIndex to}) {
    final from = _covertex.vertex[cv];
    if (from == to) return false;

    _vertexDiskUnlink(from, cv);
    _covertex.vertex[cv] = to;
    final e = _covertex.edge[cv];
    if (_covertex.isStart[cv]) {
      _edge.vStart[e] = to;
    } else {
      _edge.vEnd[e] = to;
    }
    _vertexDiskInsert(to, cv);
    _edge.touch(e);
    return true;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Edge
  // -------------------------------------------------------------------------------------------------------------------

  EdgeHandle _edgeAdd(
    CellId id,
    VertexHandle v0,
    VertexHandle v1, {
    Vec2? startTangent,
    Vec2? endTangent,
    FrameHandle? parent,
  }) {
    assert(_liveVertex(v0) && _liveVertex(v1));
    assert(_treeCheckInsertion(parent));

    final i = _edge.alloc();
    final frame = parent?.index ?? .root;

    final cv0 = _covertexAdd(v0.index, i, isStart: true, tangent: startTangent);
    final cv1 = _covertexAdd(v1.index, i, isStart: false, tangent: endTangent);

    _edge.vStart[i] = v0.index;
    _edge.vEnd[i] = v1.index;
    _edge.cvStart[i] = cv0;
    _edge.cvEnd[i] = cv1;
    _edge.radialStart[i] = .none;
    _edge.cubicVersion[i] = -1;
    _edge.crossStart[i] = .none;

    _edgeLink(i, frame);
    _cellCrossUpdate(i.cell);
    _edge.id.assign(i, id);
    return _edge.handleFor(i);
  }

  void _edgeLink(EdgeIndex i, FrameIndex parent) {
    _edge.parent[i] = parent;
    _treeSiblingInsert(parent, i.cell);
  }

  void _edgeRemove(EdgeHandle h) {
    assert(_liveEdge(h));
    assert(!_edgeHasUses(h.index), 'cannot remove edge with uses');
    _treeSiblingUnlink(h.cellIndex);
    _edge.ghost(h.index);
  }

  void _edgeRelink(EdgeHandle h, {FrameHandle? parent}) {
    assert(_ghostEdge(h));
    assert(_treeCheckInsertion(parent));

    final i = h.index;
    assert(_vertex.isLive(_edge.vStart[i]) && _vertex.isLive(_edge.vEnd[i]));
    _edge.relink(i);
    _edgeLink(i, parent?.index ?? .root);
  }

  void _edgeFree(EdgeHandle h) {
    assert(_liveEdge(h));
    assert(_edge.radialStart[h.index].isNone, 'cannot free edge with uses');
    final i = h.index;
    _cellCrossRemove(i.cell);
    _treeSiblingUnlink(h.cellIndex);
    _covertexRemove(_edge.cvStart[i]);
    _covertexRemove(_edge.cvEnd[i]);
    _edge.id.free(i);
    _edge.free(i);
  }

  void _edgeRepoint(EdgeHandle e, {VertexHandle? start, VertexHandle? end}) {
    assert(_checkEdge(e));

    var repointed = false;

    if (start != null) {
      assert(_checkVertex(start));
      repointed |= _covertexRepoint(_edge.cvStart[e.index], to: start.index);
    }

    if (end != null) {
      assert(_checkVertex(end));
      repointed |= _covertexRepoint(_edge.cvEnd[e.index], to: end.index);
    }

    if (repointed) {
      _cellCrossUpdate(e.cellIndex);
      for (final f in _edgeFaces(e.index)) _cellCrossUpdate(f.cell);
    }
  }

  void _edgeRadialInsert(EdgeIndex e, CoedgeIndex ce) {
    _coedge.radialNext[ce] = _edge.radialStart[e];
    _edge.radialStart[e] = ce;
  }

  void _edgeRadialUnlink(EdgeIndex e, CoedgeIndex ce) {
    var cur = _edge.radialStart[e];
    if (cur == ce) {
      _edge.radialStart[e] = _coedge.radialNext[ce];
      return;
    }

    while (_coedge.radialNext[cur] != ce) cur = _coedge.radialNext[cur];
    _coedge.radialNext[cur] = _coedge.radialNext[ce];
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Coedge
  // -------------------------------------------------------------------------------------------------------------------

  CoedgeIndex _coedgeAdd(EdgeIndex e, FaceIndex f, {required bool isForward}) {
    final i = _coedge.alloc();
    _coedge.edge[i] = e;
    _coedge.direction[i] = isForward;
    _coedge.face[i] = f;

    _edgeRadialInsert(e, i);
    return i;
  }

  void _coedgeRemove(CoedgeIndex ce) {
    _edgeRadialUnlink(_coedge.edge[ce], ce);
    _coedge.free(ce);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Cycle
  // -------------------------------------------------------------------------------------------------------------------

  Cycle _cycleAdd(FaceIndex face, Cycle cycle) {
    assert(cycle.isNotEmpty, 'cannot add empty cycle');

    final coedges = <CoedgeIndex>[];

    for (final ce in cycle) coedges.add(_coedgeAdd(ce.edge.index, face, isForward: ce.forward));
    for (var i = 0; i < coedges.length; i++) {
      _coedge.cycleNext[coedges[i]] = coedges[(i + 1) % coedges.length];
    }

    _face.boundary[face].add(coedges.first);
    _cellCrossUpdate(face.cell);
    return cycle;
  }

  void _cycleRemove(FaceIndex face, CoedgeIndex head) {
    final cycle = _cycleCoedges(head).toList();
    for (final ce in cycle) _coedgeRemove(ce);
    _face.boundary[face].remove(head);
    _cellCrossUpdate(face.cell);
  }

  void _cycleSplice(FaceHandle face, List<Coedge> remove, List<Coedge> insert) {
    assert(_checkFace(face));
    assert(remove.isNotEmpty && insert.isNotEmpty, 'remove and insert must be non-empty');

    final faceIndex = face.index;
    CoedgeIndex startC = .none;

    for (final c in _edgeRadial(remove.first.edge.index)) {
      if (_coedge.face[c] == faceIndex && _coedge.direction[c] == remove.first.forward) {
        startC = c;
        break;
      }
    }

    assert(startC.isNotNone, 'face cycle does not contain the provided run');

    final slots = <CoedgeIndex>[startC];
    var curr = startC;
    for (var k = 1; k < remove.length; k++) {
      curr = _coedge.cycleNext[curr];
      slots.add(curr);

      assert(() {
        final expected = remove[k];
        return _coedge.edge[curr] == expected.edge.index && _coedge.direction[curr] == expected.forward;
      }(), 'face cycle does not match the provided run');
    }

    final next = _coedge.cycleNext[curr];

    final newCoedges = <CoedgeIndex>[];
    for (final ce in insert) newCoedges.add(_coedgeAdd(ce.edge.index, faceIndex, isForward: ce.forward));
    for (var i = 0; i < newCoedges.length - 1; i++) {
      _coedge.cycleNext[newCoedges[i]] = newCoedges[i + 1];
    }

    if (next == startC) {
      _coedge.cycleNext[newCoedges.last] = newCoedges.first;
    } else {
      var prev = next;
      while (_coedge.cycleNext[prev] != startC) {
        prev = _coedge.cycleNext[prev];
      }

      _coedge.cycleNext[prev] = newCoedges.first;
      _coedge.cycleNext[newCoedges.last] = next;
    }

    final cycles = _face.boundary[faceIndex];
    final inRun = slots.toSet();
    for (var i = 0; i < cycles.length; i++) {
      if (inRun.contains(cycles[i])) cycles[i] = newCoedges.first;
    }

    for (final c in slots) _coedgeRemove(c);
    _cellCrossUpdate(face.cellIndex);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Face
  // -------------------------------------------------------------------------------------------------------------------

  FaceHandle _faceAdd(
    CellId id, {
    List<Cycle> boundary = const [],
    FrameHandle? parent,
  }) {
    assert(_treeCheckInsertion(parent));

    final i = _face.alloc();
    final frame = parent?.index ?? .root;

    _face.boundary[i] = .empty();
    _face.crossStart[i] = .none;

    _faceLink(i, frame);
    _face.id.assign(i, id);
    for (final cycle in boundary) _cycleAdd(i, cycle);
    return _face.handleFor(i);
  }

  void _faceLink(FaceIndex i, FrameIndex parent) {
    _face.parent[i] = parent;
    _treeSiblingInsert(parent, i.cell);
  }

  void _faceRemove(FaceHandle h) {
    assert(_liveFace(h));
    _treeSiblingUnlink(h.cellIndex);
    _face.ghost(h.index);
  }

  void _faceRelink(FaceHandle h, {FrameHandle? parent}) {
    assert(_ghostFace(h));
    assert(_treeCheckInsertion(parent));
    final i = h.index;
    assert(
      _faceBoundary(i).every((head) => _cycleCoedges(head).every((ce) => _edge.isLive(_coedge.edge[ce]))),
      'face relink contains non-live coedges',
    );
    _face.relink(i);
    _faceLink(i, parent?.index ?? .root);
  }

  void _faceFree(FaceHandle h) {
    assert(_liveFace(h));
    final i = h.index;
    for (final head in _faceBoundary(i).toList()) _cycleRemove(i, head);
    _cellCrossRemove(i.cell);
    _treeSiblingUnlink(h.cellIndex);
    _face.id.free(i);
    _face.free(i);
  }

  void _faceSetBoundary(FaceHandle f, List<Cycle> boundary) {
    assert(_checkFace(f));

    final i = f.index;
    for (final head in _faceBoundary(i).toList()) _cycleRemove(i, head);
    for (final cycle in boundary) _cycleAdd(i, cycle);
  }
}
