part of '../kernel.dart';

typedef SiblingIndexAnchor = SiblingAnchor<CellIndex>;
typedef SiblingHandleAnchor = SiblingAnchor<CellHandle>;
typedef SiblingKeyAnchor = SiblingAnchor<CellKey>;

sealed class SiblingAnchor<T> {
  const SiblingAnchor();
  const factory SiblingAnchor.after(T after) = AnchorAfter._;
  const factory SiblingAnchor.prepend() = AnchorPrepend._;
  const factory SiblingAnchor.append() = AnchorAppend._;

  bool get isPrepend => this is AnchorPrepend<T>;
  bool get isAppend => this is AnchorAppend<T>;
  bool get isAfter => this is AnchorAfter<T>;

  SiblingAnchor<R> map<R>(R Function(T) f) => switch (this) {
    AnchorPrepend() => AnchorPrepend<R>._(),
    AnchorAppend() => AnchorAppend<R>._(),
    AnchorAfter(:final after) => AnchorAfter<R>._(f(after)),
  };
}

final class AnchorPrepend<T> extends SiblingAnchor<T> {
  const AnchorPrepend._();
}

final class AnchorAppend<T> extends SiblingAnchor<T> {
  const AnchorAppend._();
}

final class AnchorAfter<T> extends SiblingAnchor<T> {
  const AnchorAfter._(this.after);
  final T after;
}

extension TopologyBundleTree on TopologyBundle {
  CellHandle _handleOf(CellIndex t) {
    assert(!t.isNone);
    final i = t.index.i;
    final gen = switch (t.kind) {
      .vertex => _vertex.gen[i],
      .edge => _edge.gen[i],
      .face => _face.gen[i],
      .frame => _frame.gen[i],
    };
    return .make(t.kind, t.index, gen);
  }

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

  CellIndex _siblingPrev(CellIndex t) {
    if (t.isNone) return .none;
    return _treeSiblingPrevStorage(t.kind)[t.index];
  }

  CellIndex _siblingNext(CellIndex t) {
    if (t.isNone) return .none;
    return _treeSiblingNextStorage(t.kind)[t.index];
  }

  void _setSiblingPrev(CellIndex t, CellIndex v) {
    final storage = _treeSiblingPrevStorage(t.kind);
    storage[t.index] = v;
  }

  void _setSiblingNext(CellIndex t, CellIndex v) {
    final storage = _treeSiblingNextStorage(t.kind);
    storage[t.index] = v;
  }

  bool _checkInsertion(FrameHandle? parent, SiblingHandleAnchor anchor) {
    assert(parent == null || parent.index == .root || _checkFrame(parent));
    assert(() {
      if (anchor is AnchorAfter<CellHandle>) {
        final after = anchor.after;
        assert(_checkCell(after));
      }
      return true;
    }());
    return true;
  }

  void _setParent(CellIndex t, FrameIndex p, {SiblingIndexAnchor after = const .append()}) {
    _siblingUnlink(t);
    final storage = _treeParentStorage(t.kind);
    storage[t.index] = p;
    _siblingInsert(p, t, anchor: after);
    if (t.kind == .frame) _invalidateWorldTransforms();
  }

  FrameIndex _parentOf(CellIndex t) {
    if (t.isNone) return .none;
    return _treeParentStorage(t.kind)[t.index];
  }

  void _siblingInsert(FrameIndex frame, CellIndex t, {SiblingIndexAnchor anchor = const .append()}) {
    final prev = switch (anchor) {
      AnchorPrepend() => CellIndex.none,
      AnchorAppend() => _frame.childTail[frame],
      AnchorAfter(:final after) => after,
    };

    assert(prev.isNone || _parentOf(prev) == frame, 'after must be a child of the frame');
    assert(prev != t, 'after cannot be the same as t');

    final n = prev.isNone ? _frame.childHead[frame] : _siblingNext(prev);
    _setSiblingPrev(t, prev);
    _setSiblingNext(t, n);

    if (prev.isNone) {
      _frame.childHead[frame] = t;
    } else {
      _setSiblingNext(prev, t);
    }

    if (n.isNone) {
      _frame.childTail[frame] = t;
    } else {
      _setSiblingPrev(n, t);
    }
  }

  void _siblingUnlink(CellIndex t) {
    final frame = _parentOf(t);
    final p = _siblingPrev(t), n = _siblingNext(t);
    if (p.isNone) {
      _frame.childHead[frame] = n;
    } else {
      _setSiblingNext(p, n);
    }

    if (n.isNone) {
      _frame.childTail[frame] = p;
    } else {
      _setSiblingPrev(n, p);
    }

    _setSiblingPrev(t, .none);
    _setSiblingNext(t, .none);
  }

  // void _moveSibling(CellIndex t, CellIndex after) {
  //   _siblingUnlink(t);
  //   _siblingInsert(_parentOf(t), t, anchor: .after(after));
  //   _invalidateWorldTransforms();
  // }

  FrameIndex _spaceOf(CellHandle h) => h.kind == .frame ? h.asFrame.index : _parentOf(h.cell);

  List<FrameIndex> _chainToRoot(FrameIndex start) {
    final chain = <FrameIndex>[];
    for (var q = start; q.isNotNone; q = _frame.parent[q]) {
      if (q != .root) _useFrame(_frame.handleFor(q));
      chain.add(q);
    }
    return chain;
  }

  FrameHandle _lca(CellHandle a, CellHandle b) {
    assert(_checkCell(a));
    assert(_checkCell(b));

    final chainA = _chainToRoot(_spaceOf(a));
    final chainB = _chainToRoot(_spaceOf(b));
    var ia = chainA.length - 1, ib = chainB.length - 1;
    var lca = chainA[ia];
    while (ia > 0 && ib > 0 && chainA[ia - 1] == chainB[ib - 1]) {
      ia--;
      ib--;
      lca = chainA[ia];
    }

    return _frame.handleFor(lca);
  }

  Mat4 _transformBetween(CellHandle from, CellHandle to) {
    assert(_checkCell(from));
    assert(_checkCell(to));
    return _frameTransformBetween(_spaceOf(from), _spaceOf(to));
  }

  Mat4 _frameTransformBetween(FrameIndex from, FrameIndex to) {
    if (from == to) return .identity();
    final chainFrom = _chainToRoot(from);
    final chainTo = _chainToRoot(to);

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

  bool _isAncestorOf(CellHandle target, {required FrameHandle ancestor}) {
    assert(_checkFrame(ancestor));
    assert(_checkCell(target));
    return _chainToRoot(_spaceOf(target)).contains(ancestor.index);
  }

  Iterable<CellHandle> _dependentsOf(CellHandle h) {
    h = _useCell(h);

    final Iterable<CellHandle> d = switch (h.kind) {
      .frame => frameChildren(h.asFrame),
      .vertex => vertexEdges(h.asVertex),
      .edge => edgeFaces(h.asEdge),
      _ => const [],
    };

    return d;
  }

  Iterable<CellHandle> _dependenciesOf(CellHandle h) {
    h = _useCell(h);

    final Iterable<CellHandle> d = switch (h.kind) {
      .edge => edgeVertices(h.asEdge),
      .face => faceEdges(h.asFace),
      _ => const [],
    };

    final parent = parentOf(h);
    if (parent != null) return [parent, ...d];
    return d;
  }
}
