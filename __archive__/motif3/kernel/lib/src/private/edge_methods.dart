part of '../kernel.dart';

extension TopologyBundleEdge on TopologyBundle {
  EdgeHandle _edgeAt(EdgeIndex i) => _edge.handleFor(i);

  EdgeHandle _addEdge(
    CellId id,
    VertexHandle v0,
    VertexHandle v1, {
    Vec2? t0,
    Vec2? t1,
    FrameHandle? parent,
    SiblingHandleAnchor anchor = const .append(),
  }) {
    assert(_checkVertex(v0));
    assert(_checkVertex(v1));
    assert(_checkInsertion(parent, anchor));

    final i = _edge.alloc();
    final frame = parent?.index ?? .root;

    final cv0 = _addCovertex(
      v0.index,
      i,
      isStart: true,
      tangent: t0 != null ? _tangentIntoCovertex(t0, v0.index, frame) : null,
    );

    final cv1 = _addCovertex(
      v1.index,
      i,
      isStart: false,
      tangent: t1 != null ? _tangentIntoCovertex(t1, v1.index, frame) : null
    );

    _edge.vStart[i] = v0.index;
    _edge.vEnd[i] = v1.index;
    _edge.cvStart[i] = cv0;
    _edge.cvEnd[i] = cv1;
    _edge.radialStart[i] = .none;
    _edge.parent[i] = frame;
    _edge.siblingPrev[i] = .none;
    _edge.siblingNext[i] = .none;

    _siblingInsert(frame, i.cell, anchor: anchor.map((h) => h.cell));

    _edge.id.assign(i, id);
    return _edge.handleFor(i);
  }

  void _removeEdge(EdgeHandle h) {
    assert(_checkEdge(h));
    assert(!edgeHasUses(h), 'cannot remove edge with uses');

    final i = h.index;
    _removeCovertex(_edge.cvStart[i]);
    _removeCovertex(_edge.cvEnd[i]);
    _siblingUnlink(i.cell);
    _edge.id.release(i);
    _edge.release(i);
  }

  void _setEdgeTangents(EdgeHandle h, {Vec2? start, Vec2? end}) {
    assert(_checkEdge(h));
    if (start != null) _setCovertexTangent(_edge.cvStart[h.index], start);
    if (end != null) _setCovertexTangent(_edge.cvEnd[h.index], end);
  }

  void _repointEdge(EdgeHandle e, {VertexHandle? start, VertexHandle? end}) {
    assert(_checkEdge(e));

    if (start != null) {
      assert(_checkVertex(start));
      _repointCovertex(_edge.cvStart[e.index], to: start.index);
    }

    if (end != null) {
      assert(_checkVertex(end));
      _repointCovertex(_edge.cvEnd[e.index], to: end.index);
    }
  }

  Cubic2 _edgeCubicIn(EdgeIndex e, FrameIndex space) {
    final cv0 = _edge.cvStart[e], cv1 = _edge.cvEnd[e];
    final v0 = _edge.vStart[e], v1 = _edge.vEnd[e];
    final f0 = _vertex.parent[v0], f1 = _vertex.parent[v1];
    _useVertex(_vertex.handleFor(v0));
    _useVertex(_vertex.handleFor(v1));

    var a = _vertex.position[v0], b = _vertex.position[v1];
    var t0 = _covertex.tangent[cv0], t1 = _covertex.tangent[cv1];

    if (f0 == space && f1 == space) {
      return .new(a, b, p1: a + t0, p2: b + t1);
    }

    final m0 = _frameTransformBetween(f0, space);
    a = m0.transform2(a);
    t0 = m0.transformDelta2(t0);

    final m1 = f0 == f1 ? m0 : _frameTransformBetween(f1, space);
    b = m1.transform2(b);
    t1 = m1.transformDelta2(t1);

    return .new(a, b, p1: a + t0, p2: b + t1);
  }

  Cubic2 _edgeCubicWorld(EdgeIndex e) {
    final cv0 = _edge.cvStart[e], cv1 = _edge.cvEnd[e];
    final v0 = _edge.vStart[e], v1 = _edge.vEnd[e];
    final f0 = _vertex.parent[v0], f1 = _vertex.parent[v1];

    final m0 = _frameWorldTransform(f0);
    final a = m0.transform2(_vertex.position[v0]);
    final t0 = m0.transformDelta2(_covertex.tangent[cv0]);

    final m1 = f0 == f1 ? m0 : _frameWorldTransform(f1);
    final b = m1.transform2(_vertex.position[v1]);
    final t1 = m1.transformDelta2(_covertex.tangent[cv1]);

    return .new(a, b, p1: a + t0, p2: b + t1);
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
}
