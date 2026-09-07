part of '../kernel.dart';

final class ChangeTracker {
  var _epoch = 0;
  var _bufferLow = Uint32List(64), _bufferHigh = Uint32List(64);
  var _count = 0;

  void begin() => _epoch++;

  void add(Bundle bundle, ArenaStorage arena, CellHandle h) {
    _mark(arena, h);
    if (h.kind != .frame) return;
    for (final cf in bundle._frameDependents(h.asFrame.index)) {
      final c = bundle._coframe.cell[cf];
      _mark(bundle._arenaOf(c.kind), bundle._cellHandle(c));
    }
  }

  void _mark(ArenaStorage arena, CellHandle h) {
    final i = h.index.i;
    if (arena.mark[i] == _epoch) return;
    arena.mark[i] = _epoch;
    if (_count == _bufferLow.length) {
      _bufferLow = _bufferLow.grow(_count * 2);
      _bufferHigh = _bufferHigh.grow(_count * 2);
    }

    _bufferLow[_count] = h._v & 0xFFFFFFFF;
    _bufferHigh[_count] = h._v >> 32;
    _count++;
  }

  List<CellRef> take(Bundle b) {
    final out = <CellRef>[];
    for (var i = 0; i < _count; i++) {
      final v = (_bufferHigh[i] << 32) | _bufferLow[i];
      final h = CellHandle._(v);
      if (b.isCellReachable(h)) out.add(h.ref(b));
    }

    _count = 0;
    return out;
  }

  void clear() {
    _count = 0;
  }
}
