part of '../kernel.dart';

extension TopologyBundleFrame on TopologyBundle {
  // FrameHandle _frameAt(FrameIndex i) => _frame.handleFor(i);

  FrameHandle _addFrame(
    CellId id, {
    Mat4? transform,
    Size2? size,
    FrameHandle? parent,
    SiblingHandleAnchor anchor = const .append(),
  }) {
    assert(_checkInsertion(parent, anchor));

    final i = _frame.alloc();
    final p = parent?.index ?? .root;

    _frame.parent[i] = p;
    _frame.transform[i] = transform ?? .identity();
    if (size != null) {
      _frame.size[i] = size;
      _frame.hasSize[i] = true;
    } else {
      _frame.size[i] = .zero();
      _frame.hasSize[i] = false;
    }
    _frame.clip[i] = .none;
    _frame.siblingPrev[i] = .none;
    _frame.siblingNext[i] = .none;
    _frame.childHead[i] = .none;
    _frame.childTail[i] = .none;

    _siblingInsert(p, i.cell, anchor: anchor.map((h) => h.cell));

    _frame.id.assign(i, id);
    return _frame.handleFor(i);
  }

  void _removeFrame(FrameHandle h) {
    assert(_checkFrame(h));
    assert(!frameHasChildren(h), 'cannot delete frame with children');
    assert(h.index != .root, 'cannot delete root frame');
    _siblingUnlink(h.cell);
    _frame.id.release(h.index);
    _frame.release(h.index);
  }

  void _setFrameTransform(FrameHandle h, Mat4 transform) {
    assert(_checkFrame(h));
    _frame.transform[h.index] = transform;
    _invalidateWorldTransforms();
  }

  void _setFrameSize(FrameHandle h, Size2? size) {
    assert(_checkFrame(h));
    if (size != null) {
      _frame.size[h.index] = size;
      _frame.hasSize[h.index] = true;
    } else {
      _frame.size[h.index] = .zero();
      _frame.hasSize[h.index] = false;
    }
  }

  void _setFrameClip(FrameHandle h, FaceHandle? clip) {
    assert(_checkFrame(h));
    assert(clip == null || _checkFace(clip), 'invalid clip face');
    if (clip != null && _spaceOf(clip) != h.index) {
      throw ArgumentError.value(clip, 'clip', 'clip face must be a direct child of the frame');
    }

    _frame.clip[h.index] = clip?.index ?? .none;
  }

  void _invalidateWorldTransforms() {
    _worldEpoch++;
    _cachedArrangement = null;
  }

  void _ensureWorldTransform(FrameIndex f) {
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
        _frame.worldTransform[q] = _frame.transform[q];
      } else {
        _frame.worldTransform[q] = _frame.worldTransform[p];
        _frame.worldTransform[q].multiply(_frame.transform[q]);
      }

      _frame.composedAt[q] = epoch;
    }
  }

  Mat4 _frameWorldTransform(FrameIndex i) {
    _chainToRoot(i);
    _ensureWorldTransform(i);
    return _frame.worldTransform[i];
  }

  Size2? _frameSizeIn(FrameIndex i, FrameIndex space) {
    final hasSize = _frame.hasSize[i];
    if (!hasSize) return null;

    final size = _frame.size[i];
    if (i == space) return size;

    final t = _frameTransformBetween(i, space);
    return size.transformed(t);
  }
}
