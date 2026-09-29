part of '../kernel.dart';

extension TreeMethods on Bundle {
  // -------------------------------------------------------------------------------------------------------------------
  // Storage and retrieval
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

  Int32Storage _treeZPlacementStorage(CellKind k) {
    return switch (k) {
      .vertex => _vertex.zPlacement,
      .edge => _edge.zPlacement,
      .face => _face.zPlacement,
      .frame => _frame.zPlacement,
    };
  }

  CellIndexStorage _treeZSiblingStorage(CellKind k) {
    return switch (k) {
      .vertex => _vertex.zSibling,
      .edge => _edge.zSibling,
      .face => _face.zSibling,
      .frame => _frame.zSibling,
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

  int _treeZPlacement(CellIndex t) => _treeZPlacementStorage(t.kind)[t.index];
  // bool _treeZRegular(CellIndex t) => _treeZPlacement(t) == 0;
  // bool _treeZTop(CellIndex t) => _treeZPlacement(t) > 1;
  // bool _treeZBottom(CellIndex t) => _treeZPlacement(t) < 1;
  bool _treeZAbove(CellIndex t) => _treeZPlacement(t) == 1;
  // bool _treeZBelow(CellIndex t) => _treeZPlacement(t) == -1;
  bool _treeZAttached(CellIndex t) => _treeZPlacement(t).abs() == 1;

  CellIndex _treeZSibling(CellIndex t) {
    if (!_treeZAttached(t)) return .none;
    return _treeZSiblingStorage(t.kind)[t.index];
  }

  bool _treeZAttachedTo(CellIndex t, CellIndex c) {
    while (t.isNotNone && _treeZAttached(t)) {
      final sibling = _treeZSibling(t);
      if (sibling == c) return true;
      t = sibling;
    }
    return false;
  }

  (CellIndex lo, CellIndex hi) _treeZAttachments(CellIndex c) {
    var lo = c, hi = c;
    while (true) {
      final prev = _treeSiblingPrev(lo);
      if (prev.isNone || !_treeZAttachedTo(prev, c)) break;
      lo = prev;
    }
    while (true) {
      final next = _treeSiblingNext(hi);
      if (next.isNone || !_treeZAttachedTo(next, c)) break;
      hi = next;
    }
    return (lo, hi);
  }

  int _treeZOrder(CellIndex a, CellIndex b) {
    final cmp = _order;
    return cmp != null ? cmp(_cellHandle(a).ref(this), _cellHandle(b).ref(this)) : 0;
  }

  int _treeZCompare(CellIndex a, CellIndex b) {
    final d = _treeZPlacement(a) - _treeZPlacement(b);
    return d != 0 ? d : _treeZOrder(a, b);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Mutations
  // -------------------------------------------------------------------------------------------------------------------

  void _treeSetSiblingPrev(CellIndex t, CellIndex v) {
    final storage = _treeSiblingPrevStorage(t.kind);
    storage[t.index] = v;
  }

  void _treeSetSiblingNext(CellIndex t, CellIndex v) {
    final storage = _treeSiblingNextStorage(t.kind);
    storage[t.index] = v;
  }

  void _treeSpliceOut(FrameIndex frame, CellIndex lo, CellIndex hi) {
    final prev = _treeSiblingPrev(lo);
    final next = _treeSiblingNext(hi);

    if (prev.isNone) {
      _frame.childHead[frame] = next;
    } else {
      _treeSetSiblingNext(prev, next);
    }

    if (next.isNone) {
      _frame.childTail[frame] = prev;
    } else {
      _treeSetSiblingPrev(next, prev);
    }

    _treeSetSiblingPrev(lo, .none);
    _treeSetSiblingNext(hi, .none);
    _changeTracker.markFrameChildrenChanged(frame);
  }

  void _treeSpliceIn(FrameIndex frame, CellIndex lo, CellIndex hi, {required CellIndex after}) {
    final prev = after;
    final next = after.isNone ? _frame.childHead[frame] : _treeSiblingNext(after);

    _treeSetSiblingPrev(lo, prev);
    _treeSetSiblingNext(hi, next);
    if (prev.isNone) {
      _frame.childHead[frame] = lo;
    } else {
      _treeSetSiblingNext(prev, lo);
    }

    if (next.isNone) {
      _frame.childTail[frame] = hi;
    } else {
      _treeSetSiblingPrev(next, hi);
    }

    _changeTracker.markFrameChildrenChanged(frame);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Placement
  // -------------------------------------------------------------------------------------------------------------------

  CellIndex _treeZSlot(FrameIndex frame, CellIndex t) {
    if (!_treeZAttached(t)) {
      var r = _frame.childTail[frame];
      while (r.isNotNone && (_treeZAttached(r) || _treeZCompare(r, t) > 0)) r = _treeSiblingPrev(r);
      return r.isNotNone ? _treeZAttachments(r).$2 : .none;
    }

    final s = _treeZSibling(t);
    if (_treeZAbove(t)) {
      var after = s;
      for (var d = _treeSiblingNext(s); ; d = _treeSiblingNext(_treeZAttachments(d).$2)) {
        if (d.isNone || _treeZSibling(d) != s) break;
        if (_treeZOrder(d, t) > 0) break;
        after = _treeZAttachments(d).$2;
      }
      return after;
    } else {
      for (var d = _treeSiblingPrev(s); ; d = _treeSiblingPrev(_treeZAttachments(d).$1)) {
        if (d.isNone || _treeZSibling(d) != s) break;
        if (_treeZOrder(d, t) < 0) return _treeZAttachments(d).$2;
      }
      return _treeSiblingPrev(_treeZAttachments(s).$1);
    }
  }

  void _treeZSet(CellIndex t, ZAnchor? anchor) {
    final (int placement, CellIndex sibling) = switch (anchor) {
      null => (0, .none),
      ZTop z => (1 + z.rank, .none),
      ZBottom z => (-1 - z.rank, .none),
      ZAbove z => (1, handle(z.sibling)!.cellIndex),
      ZBelow z => (-1, handle(z.sibling)!.cellIndex),
    };

    final frame = _treeParentOf(t);
    final (lo, hi) = _treeZAttachments(t);
    _treeSpliceOut(frame, lo, hi);
    _treeZPlacementStorage(t.kind)[t.index] = placement;
    _treeZSiblingStorage(t.kind)[t.index] = placement.abs() == 1 ? sibling : .none;
    _treeSpliceIn(frame, lo, hi, after: _treeZSlot(frame, t));
  }

  void _treeSiblingInsert(FrameIndex frame, CellIndex t) {
    _treeZPlacementStorage(t.kind)[t.index] = 0;
    _treeZSiblingStorage(t.kind)[t.index] = .none;
    _treeSpliceIn(frame, t, t, after: _treeZSlot(frame, t));
  }

  void _treeSiblingUnlink(CellIndex t) {
    final frame = _treeParentOf(t);
    while (true) {
      final (lo, hi) = _treeZAttachments(t);
      if (lo == t && hi == t) break;
      _treeZSet(lo != t ? _treeSiblingPrev(t) : _treeSiblingNext(t), null);
    }
    _treeSpliceOut(frame, t, t);
  }

  void _treeReorder(CellHandle h, ZAnchor? anchor) {
    final sibling = anchor?.sibling;
    if (sibling != null) {
      final s = handle(sibling)!;
      if (parentOf(s) != parentOf(h)) throw StateError('$sibling is not a sibling of $h');
      if (_treeZAttachedTo(s.cellIndex, h.cellIndex)) throw StateError('$sibling is attached to $h: cycle formed');
    }

    _treeZSet(h.cellIndex, anchor);
  }

  ZAnchor? _treeZAnchorOf(CellIndex t) {
    final placement = _treeZPlacementStorage(t.kind)[t.index];
    final sibling = _treeZSiblingStorage(t.kind)[t.index];

    return switch (placement) {
      0 => null,
      1 => .above(ref(_cellHandle(sibling))),
      -1 => .below(ref(_cellHandle(sibling))),
      > 1 => .top(placement - 1),
      < -1 => .bottom(-1 - placement),
      _ => null,
    };
  }
}
