part of '../program.dart';

final class DrawOrderIndex {
  DrawOrderIndex(this.evaluation);

  final Evaluation evaluation;
  late final Bundle bundle = evaluation.bundle;

  final _drawOrder = <FrameRef, List<(CellRef, CellHandle)>>{};
  Map<CellRef, int>? _drawIndex;

  List<(CellRef, CellHandle)> of(FrameHandle frame) => _drawOrder.putIfAbsent(
    frame.ref(bundle),
    () => _resolve(frame),
  );

  int indexOf(CellRef r) {
    _drawIndex ??= _buildIndex();
    return _drawIndex![r]!;
  }

  void invalidate(CellRef r) {
    final h = bundle.handle(r);
    if (h == null) return;
    final parent = bundle.parentOf(h)?.ref(bundle);
    _drawOrder.remove(parent);
    _drawIndex = null;
  }

  List<(CellRef, CellHandle)> _resolve(FrameHandle frame) {
    final sorted = <CellRef>[];
    for (final c in bundle.frameChildren(frame)) sorted.add(c.ref(bundle));

    sorted.sort((a, b) {
      final s = evaluation._index[a.statementId]!.compareTo(evaluation._index[b.statementId]!);
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
      final anchor = evaluation.program.zOrders.of(r);

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

    final out = list.map((e) => (e.ref, bundle.handle(e.ref)!)).toList(growable: false);
    return out;
  }

  Map<CellRef, int> _buildIndex() {
    final out = <CellRef, int>{};
    var i = 0;

    void walk(FrameHandle f) {
      for (final (ref, handle) in of(f)) {
        out[ref] = i++;
        if (ref.kind == .frame) walk(handle.asFrame);
      }
    }

    walk(.root);
    return out;
  }
}

extension EvaluationZOrder on Evaluation {
  void reorder(EvaluationPass pass, CellRef r) {
    drawOrder.invalidate(r);
    pass.reordered.add(r);
  }
}
