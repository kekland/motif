part of '../kernel.dart';

extension TopologyBundleCoedge on TopologyBundle {
  Coedge _coedgeAt(CoedgeIndex i) {
    assert(i.isNotNone);
    return .new(
      _edge.handleFor(_coedge.edge[i]),
      forward: _coedge.direction[i],
    );
  }

  Iterable<CoedgeIndex> _edgeRadial(EdgeIndex e) sync* {
    for (var c = _edge.radialStart[e]; c != .none; c = _coedge.radialNext[c]) yield c;
  }

  CoedgeIndex _addCoedge(EdgeIndex e, bool isForward, FaceIndex f) {
    final i = _coedge.alloc();
    _coedge.edge[i] = e;
    _coedge.direction[i] = isForward;
    _coedge.face[i] = f;

    _radialInsert(e, i);
    return i;
  }

  void _removeCoedge(CoedgeIndex i) {
    final e = _coedge.edge[i];
    _radialUnlink(e, i);
    _coedge.release(i);
  }

  void _radialInsert(EdgeIndex e, CoedgeIndex i) {
    _coedge.radialNext[i] = _edge.radialStart[e];
    _edge.radialStart[e] = i;
  }

  void _radialUnlink(EdgeIndex e, CoedgeIndex i) {
    var cur = _edge.radialStart[e];
    if (cur == i) {
      _edge.radialStart[e] = _coedge.radialNext[i];
      return;
    }

    while (_coedge.radialNext[cur] != i) cur = _coedge.radialNext[cur];
    _coedge.radialNext[cur] = _coedge.radialNext[i];
  }
}
