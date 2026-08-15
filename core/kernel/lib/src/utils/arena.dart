part of '../kernel.dart';

const int _baseSize = _arenaListBaseSize;

abstract class ArenaStorage<I extends ElementIndex, THandle, T extends ArenaStorage<I, THandle, T>> {
  var gen = Uint32List(_baseSize);
  var alive = Uint8List(_baseSize);
  var top = 0;
  final free = <int>[];

  int get liveCount => top - free.length;

  Iterable<I> get liveIndices sync* {
    for (var i = 0; i < top; i++) {
      if (alive[i] == 1) yield _wrapIndex(i);
    }
  }

  Iterable<THandle> get liveHandles sync* {
    for (var idx in liveIndices) yield handleFor(idx);
  }

  I alloc() {
    int i;

    if (free.isNotEmpty) {
      i = free.removeLast();
    } else {
      i = top++;
      grow(i + 1);
    }

    alive[i] = 1;
    return _wrapIndex(i);
  }

  void release(I index) {
    final i = index.i;
    assert(alive[i] == 1, 'double release of index $index');
    alive[i] = 0;
    gen[i]++;
    free.add(i);
  }

  void grow(int atLeast) {
    if (gen.length < atLeast) {
      gen = gen.grow(atLeast);
      alive = alive.grow(atLeast);
    }
  }

  bool isAliveAt(I index) => index.i < top && alive[index.i] == 1;
  bool isHandleAlive(I index, int gen) => isAliveAt(index) && this.gen[index.i] == gen;

  void copyFrom(T other) {
    gen = .fromList(other.gen);
    alive = .fromList(other.alive);
    top = other.top;

    free.clear();
    free.addAll(other.free);
  }

  THandle handleFor(I index) => _handleFor(index.i);

  I _wrapIndex(int i);
  THandle _handleFor(int i);
}

sealed class IdTable<I extends ElementIndex> {
  IdTable(this.kind);

  final String kind;

  final _slots = <CellId?>[];
  final _indexById = <CellId, int>{};

  void assign(I index, CellId id) {
    assert(!_indexById.containsKey(id), 'duplicate $kind id: $id');
    while (_slots.length <= index.i) _slots.add(null);
    _slots[index.i] = id;
    _indexById[id] = index.i;
  }

  void release(I index) {
    final id = _slots[index.i];
    if (id != null) _indexById.remove(id);
    _slots[index.i] = null;
  }

  CellId of(I index) => _slots[index.i]!;
  CellId? maybeOf(I index) => index.i < _slots.length ? _slots[index.i] : null;
  I? wrapIndex(int? i);
  I? indexOf(CellId id) => wrapIndex(_indexById[id]);

  void copyFrom(IdTable other) {
    _slots.clear();
    _slots.addAll(other._slots);
    _indexById.clear();
    _indexById.addAll(other._indexById);
  }
}
