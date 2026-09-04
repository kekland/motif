part of '../kernel.dart';

extension GeometryMethods on Bundle {
  // -------------------------------------------------------------------------------------------------------------------
  // Frame
  // -------------------------------------------------------------------------------------------------------------------

  Mat4 _frameTransform(FrameIndex i, {FrameIndex? space}) {
    if (space == null) return _frame.transform[i].copy();
    if (i == space) return .identity();
    return _frameTransformBetween(space, i);
  }

  Size2? _frameSize(FrameIndex i, {FrameIndex? space}) {
    final s = _frame.hasSize[i] ? _frame.size[i] : null;
    if (s == null || space == null || i == space) return s;

    final m = _frameTransformBetween(i, space);
    return s.transformed(m);
  }

  FaceIndex? _frameClip(FrameIndex i) {
    final clip = _frame.clip[i];
    return clip.isNone ? null : clip;
  }

  void _frameSetTransform(FrameHandle h, Mat4 transform, {FrameIndex? space}) {
    assert(_checkFrame(h));
    final i = h.index;

    final before = _frame.transform[i];
    final after = space == null || i == space ? transform : (_frameTransformBetween(space, i)..multiply(transform));

    if (!before.equals(after)) {
      _frame.transform[i] = after;
      _frameInvalidateWorldTransforms();
    }

    _frame.touch(i);
  }

  void _frameSetSize(FrameHandle h, Size2? size, {FrameHandle? space}) {
    assert(_checkFrame(h));
    final i = h.index;
    _frame.hasSize[i] = size != null;
    _frame.size[i] = switch (size) {
      null => .zero(),
      final s when space == null || h == space => s,
      final s => s.transformed(_frameTransformBetween(space.index, i)),
    };

    _frame.touch(i);
  }

  void _frameSetClip(FrameHandle h, FaceHandle? clip) {
    assert(_checkFrame(h));
    assert(clip == null || _checkFace(clip));
    final i = h.index;

    if (clip != null && _treeParentOf(clip.cell) != h.index) {
      throw ArgumentError.value(clip, 'clip', 'must be a child of the frame');
    }

    _frame.clip[i] = clip?.index ?? .none;
    _frame.touch(i);
  }

  List<FrameIndex> _frameChainToRoot(FrameIndex start) {
    final chain = <FrameIndex>[];
    for (var q = start; q.isNotNone; q = _frame.parent[q]) chain.add(q);
    return chain;
  }

  Mat4 _frameTransformBetween(FrameIndex from, FrameIndex to) {
    if (from == to) return .identity();
    if (from == .root) return _frameWorldTransform(to);
    if (to == .root) return _frameInverseWorldTransform(from);

    final chainFrom = _frameChainToRoot(from);
    final chainTo = _frameChainToRoot(to);

    var nf = chainFrom.length, nt = chainTo.length;
    while (nf > 0 && nt > 0 && chainFrom[nf - 1] == chainTo[nt - 1]) {
      nf--;
      nt--;
    }

    final down = Mat4.identity();
    for (var k = nt - 1; k >= 0; k--) down.multiply(_frame.transform[chainTo[k]]);
    if (down.invert() == 0) return Mat4.zero();

    for (var k = nf - 1; k >= 0; k--) down.multiply(_frame.transform[chainFrom[k]]);
    return down;
  }

  Mat4 _frameWorldTransform(FrameIndex f) {
    _frameEnsureWorldTransform(f);
    return _frame.worldTransform[f].copy();
  }

  Mat4 _frameInverseWorldTransform(FrameIndex f) {
    _frameEnsureWorldTransform(f);
    return _frame.inverseWorldTransform[f].copy();
  }

  void _frameInvalidateWorldTransforms() {
    _worldEpoch++;
    // _cachedArrangement = null;
  }

  void _frameEnsureWorldTransform(FrameIndex f) {
    final epoch = _worldEpoch;
    if (_frame.composedAt[f] == epoch) return;

    final chain = <int>[];
    for (var q = f; q.isNotNone && _frame.composedAt[q] != epoch; q = _frame.parent[q]) {
      chain.add(q.i);
    }

    for (var k = chain.length - 1; k >= 0; k--) {
      final q = FrameIndex(chain[k]);
      final p = _frame.parent[q];

      if (p.isNone) {
        assert(q == .root);
        final t = _frame.transform[q];
        _frame.worldTransform[q] = t;
        _frame.inverseWorldTransform[q] = t.inverted();
      } else {
        _frame.worldTransform[q] = _frame.worldTransform[p];
        _frame.worldTransform[q].multiply(_frame.transform[q]);

        final t = _frame.worldTransform[q];
        _frame.inverseWorldTransform[q] = t.inverted();
      }

      _frame.composedAt[q] = epoch;
    }
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Vertex
  // -------------------------------------------------------------------------------------------------------------------

  Vec2 _vertexPosition(VertexIndex v, {FrameIndex? space}) {
    late final f = _vertex.parent[v];
    final p = _vertex.position[v];
    if (space == null || f == space) return p;

    final m = _frameTransformBetween(f, space);
    return m.transform2(p);
  }

  void _vertexSetPosition(VertexHandle h, Vec2 p, {FrameHandle? space}) {
    assert(_checkVertex(h));
    final i = h.index;
    final s = space?.index;

    late final f = _vertex.parent[i];
    final prev = _vertex.position[i];
    final next = s == null || f == s ? p : _frameTransformBetween(s, f).transform2(p);
    if (prev.equals(next)) return;

    _vertex.position[i] = next;
    _vertex.touch(i);
    for (var cv = _vertex.diskStart[i]; cv != .none; cv = _covertex.diskNext[cv]) _edge.touch(_covertex.edge[cv]);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Covertex
  // -------------------------------------------------------------------------------------------------------------------

  Vec2 _covertexTangent(CovertexIndex cv, {FrameIndex? space}) {
    late final f = _vertex.parent[_covertex.vertex[cv]];
    final t = _covertex.tangent[cv];
    if (space == null || f == space) return t;

    final m = _frameTransformBetween(f, space);
    return m.transform2(t);
  }

  void _covertexSetTangent(CovertexIndex c, Vec2 t, {FrameHandle? space}) {
    late final f = _vertex.parent[_covertex.vertex[c]];
    final s = space?.index;

    final prev = _covertex.tangent[c];
    final next = s == null || f == s ? t : _frameTransformBetween(s, f).transform2(t);
    if (prev.equals(next)) return;

    _covertex.tangent[c] = next;
    _edge.touch(_covertex.edge[c]);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Edge
  // -------------------------------------------------------------------------------------------------------------------

  Vec2 _edgeStartTangent(EdgeIndex e, {FrameIndex? space}) => _covertexTangent(_edge.cvStart[e], space: space);
  Vec2 _edgeEndTangent(EdgeIndex e, {FrameIndex? space}) => _covertexTangent(_edge.cvEnd[e], space: space);

  void _edgeSetTangents(EdgeHandle h, {Vec2? start, Vec2? end, FrameHandle? space}) {
    assert(_checkEdge(h));
    final i = h.index;

    if (start != null) _covertexSetTangent(_edge.cvStart[i], start, space: space);
    if (end != null) _covertexSetTangent(_edge.cvEnd[i], end, space: space);
  }

  Cubic2 _edgeCubic(EdgeIndex e, {FrameIndex? space}) {
    final f = _edge.parent[e];
    if (space != null && space != f) return _edgeCubicIn(e, space: space);

    final crossFrame = _vertex.parent[_edge.vStart[e]] != f || _vertex.parent[_edge.vEnd[e]] != f;
    final valid = _edge.cubicVersion[e] == _edge.version[e.i] && (!crossFrame || _edge.cubicEpoch[e] == _worldEpoch);
    if (valid) return _edge.cubic[e];

    final c = _edgeCubicIn(e);
    _edge.cubic[e] = c;
    _edge.cubicVersion[e] = _edge.version[e.i];
    _edge.cubicEpoch[e] = _worldEpoch;
    _edge.cubicArcIndex[e] = null;
    return c;
  }

  Cubic2 _edgeCubicIn(EdgeIndex e, {FrameIndex? space}) {
    final f = space ?? _edge.parent[e];

    final cv0 = _edge.cvStart[e], cv1 = _edge.cvEnd[e];
    final v0 = _edge.vStart[e], v1 = _edge.vEnd[e];
    late final f0 = _vertex.parent[v0], f1 = _vertex.parent[v1];

    var a = _vertex.position[v0], b = _vertex.position[v1];
    var t0 = _covertex.tangent[cv0], t1 = _covertex.tangent[cv1];

    if (f0 != f || f1 != f) {
      final m0 = _frameTransformBetween(f0, f);
      a = m0.transform2(a);
      t0 = m0.transform2(t0);

      final m1 = f0 == f1 ? m0 : _frameTransformBetween(f1, f);
      b = m1.transform2(b);
      t1 = m1.transform2(t1);
    }

    return .new(a, b, p1: a + t0, p2: b + t1);
  }

  CubicArcIndex _edgeCubicArcIndex(EdgeIndex e, {FrameIndex? space}) {
    if (space != null && space != _edge.parent[e]) {
      return _edgeCubicIn(e, space: space).arcIndex;
    }

    return _edge.cubicArcIndex[e] ??= _edgeCubic(e).arcIndex;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Cycle
  // -------------------------------------------------------------------------------------------------------------------

  double _cycleSignedArea(Cycle cycle) {
    var total = 0.0;
    for (final u in cycle) {
      final a = _edgeCubic(u.edge.index, space: .root).signedAreaIntegral;
      total += u.forward ? a : -a;
    }
    return total;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Face
  // -------------------------------------------------------------------------------------------------------------------

  double _faceSignedArea(FaceIndex i) {
    var total = 0.0;
    for (final head in _faceBoundary(i)) {
      final cycle = _cycleFor(_cycleCoedges(head));
      total += _cycleSignedArea(cycle);
    }
    return total;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Tree
  // -------------------------------------------------------------------------------------------------------------------

  FrameIndex _treeSpaceOf(CellIndex i) => i.kind == .frame ? i.asFrame : _treeParentOf(i);

  FrameIndex _treeLca(CellIndex a, CellIndex b) {
    final chainA = _frameChainToRoot(_treeSpaceOf(a));
    final chainB = _frameChainToRoot(_treeSpaceOf(b));
    var ia = chainA.length - 1, ib = chainB.length - 1;
    var lca = chainA[ia];
    while (ia > 0 && ib > 0 && chainA[ia - 1] == chainB[ib - 1]) {
      ia--;
      ib--;
      lca = chainA[ia];
    }

    return lca;
  }

  bool _treeIsAncestorOf(CellIndex target, {required FrameIndex ancestor}) {
    for (var q = _treeSpaceOf(target); q.isNotNone; q = _frame.parent[q]) {
      if (q == ancestor) return true;
    }
    return false;
  }

  Mat4 _treeTransformBetween(CellIndex from, CellIndex to) {
    return _frameTransformBetween(_treeSpaceOf(from), _treeSpaceOf(to));
  }
}
