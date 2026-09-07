part of '../program.dart';

extension EvaluationZOrder on Evaluation {
  List<CellRef> drawOrderOf(FrameHandle frame) {
    return _drawOrder.putIfAbsent(
      frame.ref(bundle),
      () => _resolveDrawOrder(frame),
    );
  }

  int drawIndexOf(CellRef r) {
    _drawIndex ??= _buildDrawIndex();
    return _drawIndex![r]!;
  }

  List<CellRef> _resolveDrawOrder(FrameHandle frame) {
    final sorted = <CellRef>[];
    for (final c in bundle.frameChildren(frame)) sorted.add(c.ref(bundle));

    sorted.sort((a, b) {
      final s = _index[a.statementId]!.compareTo(_index[b.statementId]!);
      if (s != 0) return s;
      return a.kind.index.compareTo(b.kind.index);
    });

    final list = LinkedList<_ZOrderEntry>();
    final entries = <CellRef, _ZOrderEntry>{};
    for (final c in sorted) {
      final entry = _ZOrderEntry(c);
      entries[c] = entry;
      list.add(entry);
    }

    final placed = <CellRef>{};
    void place(CellRef r) {
      if (!placed.add(r)) return;
      final e = entries[r]!;
      final anchor = program.zOrders.of(r);

      switch (anchor) {
        case null:
          break;
        case ZTop():
          list.add(e..unlink());
        case ZBottom():
          list.addFirst(e..unlink());
        case ZAbove(:final sibling) when entries.containsKey(sibling):
          place(sibling);
          entries[sibling]!.insertAfter(e..unlink());
        case ZBelow(:final sibling) when entries.containsKey(sibling):
          place(sibling);
          entries[sibling]!.insertBefore(e..unlink());
        case ZAbove() || ZBelow():
          break;
      }
    }

    for (final r in sorted) place(r);
    return list.map((e) => e.ref).toList(growable: false);
  }

  void _invalidateDrawOrder(CellRef r) {
    final h = bundle.handle(r);
    if (h == null) return;
    final parent = bundle.parentOf(h)?.ref(bundle);
    _drawOrder.remove(parent);
    _drawIndex = null;
  }

  void reorder(EvaluationPass pass, CellRef r) {
    _invalidateDrawOrder(r);
    pass.reordered.add(r);
  }

  Map<CellRef, int> _buildDrawIndex() {
    final out = <CellRef, int>{};
    var i = 0;

    void walk(FrameHandle f) {
      for (final r in drawOrderOf(f)) {
        out[r] = i++;
        if (r.kind == .frame) walk(bundle.handle(r)!.asFrame);
      }
    }

    walk(.root);
    return out;
  }
}
