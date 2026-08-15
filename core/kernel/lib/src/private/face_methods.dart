part of '../kernel.dart';

extension TopologyBundleFace on TopologyBundle {
  FaceHandle _faceAt(FaceIndex i) => _face.handleFor(i);

  Iterable<CoedgeIndex> _faceBoundary(FaceIndex f) sync* {
    for (final head in _face.boundary[f]) yield head;
  }

  FaceHandle _addFace(
    CellId id, {
    FrameHandle? parent,
    SiblingHandleAnchor anchor = const .append(),
  }) {
    assert(_checkInsertion(parent, anchor));

    final i = _face.alloc();
    final frame = parent?.index ?? .root;

    _face.boundary[i] = .empty();
    _face.parent[i] = frame;
    _face.siblingPrev[i] = .none;
    _face.siblingNext[i] = .none;

    _siblingInsert(frame, i.cell, anchor: anchor.map((h) => h.cell));

    _face.id.assign(i, id);
    return _face.handleFor(i);
  }

  void _removeFace(FaceHandle h) {
    assert(_checkFace(h));

    final i = h.index;
    for (final head in _faceBoundary(i).toList()) _removeCycle(i, head);
    _siblingUnlink(i.cell);
    _face.id.release(i);
    _face.release(i);
  }

  int _faceWinding(FaceHandle face, Vec2 p) {
    var winding = 0;

    for (final cycle in faceBoundary(face)) {
      winding += _cycleWinding(cycle, p);
    }

    return winding;
  }
}
