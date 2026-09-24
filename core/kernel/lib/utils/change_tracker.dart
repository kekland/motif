part of '../kernel.dart';

final class ChangeTracker {
  var _epoch = 0;
  var _bufferLow = Uint32List(64), _bufferHigh = Uint32List(64);
  var _count = 0;

  final _frames = <FrameIndex>[];

  void begin() => _epoch++;

  void add(Bundle bundle, ArenaStorage arena, CellHandle h) {
    _mark(arena, h);
    if (h.kind != .frame) return;
    for (final cf in bundle._frameDependents(h.asFrame.index)) {
      final c = bundle._coframe.cell[cf];
      _mark(bundle._arenaOf(c.kind), bundle._cellHandle(c));
    }
  }

  void markFrameChildrenChanged(FrameIndex frame) => _frames.add(frame);

  void _mark(ArenaStorage arena, CellHandle h) {
    final i = h.index.i;
    if (arena.mark[i] == _epoch) return;
    arena.mark[i] = _epoch;
    if (_count == _bufferLow.length) {
      _bufferLow = _bufferLow.grow(_count * 2);
      _bufferHigh = _bufferHigh.grow(_count * 2);
    }

    _bufferLow[_count] = h.cellIndex.value;
    _bufferHigh[_count] = h.gen;
    _count++;
  }

  (Set<CellRef>, Set<FrameRef>) take(Bundle b) {
    final moved = HashSet<CellRef>();
    final movedFrames = HashSet<FrameRef>();

    for (var i = 0; i < _count; i++) {
      final h = CellHandle.assemble(.raw(_bufferLow[i]), _bufferHigh[i]);
      if (!b.isCellReachable(h)) continue;
      moved.add(h.ref(b));

      if (h.kind != .frame) {
        final f = b.parentOf(h);
        if (f != null) movedFrames.add(f.ref(b));
      }
    }

    for (final f in _frames) {
      final h = b._frame.handleFor(f);
      if (f == .root || b.isCellReachable(h)) movedFrames.add(h.ref(b));
    }

    return (moved, movedFrames);
  }

  void clear() {
    _count = 0;
    _frames.clear();
  }
}
