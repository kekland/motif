part of '../kernel.dart';

final class ChangeTracker {
  var _epoch = 0;
  var _buffer = Uint32List(64);
  var _count = 0;

  void begin() => _epoch++;

  void add(ArenaStorage arena, CellHandle h) {
    final i = h.index.i;
    if (arena.mark[i] == _epoch) return;
    arena.mark[i] = _epoch;
    if (_count == _buffer.length) _buffer = _buffer.grow(_count * 2);
    _buffer[_count++] = h._v;
  }

  List<CellRef> take(Bundle b) {
    final out = <CellRef>[];
    for (var i = 0; i < _count; i++) {
      final h = CellHandle._(_buffer[i]);
      if (b.isCellReachable(h)) out.add(h.ref(b));
    }

    _count = 0;
    return out;
  }

  void clear() {
    _count = 0;
  }
}
