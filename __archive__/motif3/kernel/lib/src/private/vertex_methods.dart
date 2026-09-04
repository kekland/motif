part of '../kernel.dart';

extension TopologyBundleVertex on TopologyBundle {
  VertexHandle _vertexAt(VertexIndex i) => _vertex.handleFor(i);

  VertexHandle _addVertex(
    CellId id,
    Vec2 position, {
    FrameHandle? parent,
    SiblingHandleAnchor anchor = const .append(),
  }) {
    assert(_checkInsertion(parent, anchor));
    final i = _vertex.alloc();
    final frame = parent?.index ?? .root;

    _vertex.position[i] = position;
    _vertex.diskStart[i] = .none;
    _vertex.parent[i] = frame;
    _vertex.siblingPrev[i] = .none;
    _vertex.siblingNext[i] = .none;

    _siblingInsert(frame, i.cell, anchor: anchor.map((h) => h.cell));

    _vertex.id.assign(i, id);
    return _vertex.handleFor(i);
  }

  void _removeVertex(VertexHandle h) {
    assert(_checkVertex(h));
    assert(!vertexHasUses(h), 'cannot remove vertex with uses');
    _siblingUnlink(h.cell);
    _vertex.id.release(h.index);
    _vertex.release(h.index);
  }

  void _setVertexPosition(VertexHandle h, Vec2 position) {
    assert(_checkVertex(h));
    _vertex.position[h.index] = position;
  }

  List<List<EdgeHandle>> _vertexSectors(VertexHandle h) {
    assert(_checkVertex(h));
    final vi = h.index;

    final order = <EdgeIndex>[];
    final seen = <EdgeIndex>{};
    for (final cv in _vertexDisk(vi)) {
      final e = _covertex.edge[cv];
      if (seen.add(e)) order.add(e);
    }

    final label = <EdgeIndex, EdgeIndex>{for (final e in order) e: e};
    for (final e in order) {
      _useEdge(_edge.handleFor(e));
      for (final c in _edgeRadial(e)) {
        final forward = _coedge.direction[c];
        final shared = forward ? _edge.vEnd[e] : _edge.vStart[e];
        if (shared != vi) continue;

        final next = _coedge.edge[_coedge.cycleNext[c]];
        final a = label[e]!, b = label[next]!;
        if (a == b) continue;
        for (final k in label.keys) {
          if (label[k] == b) label[k] = a;
        }
      }
    }

    final byLabel = <EdgeIndex, List<EdgeHandle>>{};
    for (final e in order) {
      final l = label[e]!;
      byLabel[l] ??= [];
      byLabel[l]!.add(_edge.handleFor(e));
    }

    return byLabel.values.toList();
  }

  Vec2 _vertexPositionIn(VertexIndex v, FrameIndex space) {
    final f = _vertex.parent[v];
    final p = _vertex.position[v];
    if (f == space) return p;

    final m = _frameTransformBetween(f, space);
    return m.transform2(p);
  }

  Vec2 _vertexPositionWorld(VertexIndex v) {
    final m = _frameWorldTransform(_vertex.parent[v]);
    return m.transform2(_vertex.position[v]);
  }
}
