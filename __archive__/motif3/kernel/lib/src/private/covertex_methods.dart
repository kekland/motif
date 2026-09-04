part of '../kernel.dart';

extension TopologyBundleCovertex on TopologyBundle {
  Covertex _covertexAt(CovertexIndex i) {
    assert(i.isNotNone);
    return .new(
      _edge.handleFor(_covertex.edge[i]),
      isStart: _covertex.isStart[i],
    );
  }

  Iterable<CovertexIndex> _vertexDisk(VertexIndex v) sync* {
    for (var c = _vertex.diskStart[v]; c != .none; c = _covertex.diskNext[c]) yield c;
  }

  CovertexIndex _addCovertex(VertexIndex v, EdgeIndex e, {required bool isStart, Vec2? tangent}) {
    final cv = _covertex.alloc();
    _covertex.vertex[cv] = v;
    _covertex.edge[cv] = e;
    _covertex.isStart[cv] = isStart;
    _covertex.tangent[cv] = tangent ?? .zero();
    _diskInsert(v, cv);
    return cv;
  }

  void _removeCovertex(CovertexIndex cv) {
    _diskUnlink(_covertex.vertex[cv], cv);
    _covertex.release(cv);
  }

  void _diskInsert(VertexIndex v, CovertexIndex cv) {
    _covertex.diskNext[cv] = _vertex.diskStart[v];
    _vertex.diskStart[v] = cv;
  }

  void _diskUnlink(VertexIndex v, CovertexIndex cv) {
    var cur = _vertex.diskStart[v];
    if (cur == cv) {
      _vertex.diskStart[v] = _covertex.diskNext[cv];
      return;
    }

    while (_covertex.diskNext[cur] != cv) cur = _covertex.diskNext[cur];
    _covertex.diskNext[cur] = _covertex.diskNext[cv];
  }

  void _repointCovertex(CovertexIndex cv, {required VertexIndex to}) {
    final from = _covertex.vertex[cv];
    if (from == to) return;

    final fFrom = _vertex.parent[from], fTo = _vertex.parent[to];
    if (fFrom != fTo) {
      final t = _covertex.tangent[cv];
      final m = _frameTransformBetween(fFrom, fTo);
      _covertex.tangent[cv] = m.transformDelta2(t);
    }

    _diskUnlink(from, cv);
    _covertex.vertex[cv] = to;
    final e = _covertex.edge[cv];
    if (_covertex.isStart[cv]) {
      _edge.vStart[e] = to;
    } else {
      _edge.vEnd[e] = to;
    }
    _diskInsert(to, cv);
  }

  void _setCovertexTangent(CovertexIndex cv, Vec2 t) {
    _covertex.tangent[cv] = t;
  }

  Vec2 _tangentIntoCovertex(Vec2 t, VertexIndex v, FrameIndex from) {
    final f = _vertex.parent[v];
    if (f == from) return t;
    return _frameTransformBetween(from, f).transformDelta2(t);
  }

  Vec2 _covertexTangentIn(CovertexIndex cv, {FrameIndex? space}) {
    final t = _covertex.tangent[cv];
    if (space == null) return t;

    final f = _vertex.parent[_covertex.vertex[cv]];
    if (f == space) return t;

    return _frameTransformBetween(f, space).transformDelta2(t);
  }

  Vec2 _covertexTangentWorld(CovertexIndex cv) {
    final t = _covertex.tangent[cv];
    final v = _covertex.vertex[cv];
    return _frameWorldTransform(_vertex.parent[v]).transformDelta2(t);
  }
}
