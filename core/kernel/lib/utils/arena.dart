part of '../kernel.dart';

const int _baseSize = _arenaListBaseSize;

abstract class ArenaStorage<I extends ElementIndex, THandle, T extends ArenaStorage<I, THandle, T>> {
  var gen = Uint32List(_baseSize);
  var state = Uint8List(_baseSize);
  var mark = Uint32List(_baseSize);
  var version = Uint32List(_baseSize);
  var top = 0;
  final _freeIndices = <int>[];

  static const _free = 0, _live = 1, _ghost = 2;
  int get rowCount => top - _freeIndices.length;

  Iterable<I> get liveIndices sync* {
    for (var i = 0; i < top; i++) {
      if (state[i] == _live) yield _wrapIndex(i);
    }
  }

  Iterable<THandle> get liveHandles sync* {
    for (var idx in liveIndices) yield handleFor(idx);
  }

  I alloc() {
    int i;

    if (_freeIndices.isNotEmpty) {
      i = _freeIndices.removeLast();
    } else {
      i = top++;
      grow(i + 1);
    }

    state[i] = _live;
    return _wrapIndex(i);
  }

  void touch(I index) {
    assert(state[index.i] != _free, 'touching a free index $index');
    version[index.i]++;
  }

  void ghost(I index) {
    assert(state[index.i] == _live, 'ghosting a non-live index $index');
    state[index.i] = _ghost;
  }

  void relink(I index) {
    assert(state[index.i] == _ghost, 'relinking a non-ghost index $index');
    state[index.i] = _live;
  }

  void free(I index) {
    assert(state[index.i] != _free, 'double free index $index');
    state[index.i] = _free;
    gen[index.i]++;
    _freeIndices.add(index.i);
  }

  void grow(int atLeast) {
    if (gen.length < atLeast) {
      gen = gen.grow(atLeast);
      state = state.grow(atLeast);
      mark = mark.grow(atLeast);
      version = version.grow(atLeast);
    }
  }

  bool isLive(I index) => index.i < top && state[index.i] == _live;
  bool isGhost(I index) => index.i < top && state[index.i] == _ghost;
  bool isReachable(I index) => index.i < top && state[index.i] != _free;

  bool isHandleLive(I index, int gen) => isLive(index) && this.gen[index.i] == gen;
  bool isHandleGhost(I index, int gen) => isGhost(index) && this.gen[index.i] == gen;
  bool isHandleReachable(I index, int gen) => isReachable(index) && this.gen[index.i] == gen;

  void copyFrom(T other) {
    gen = .fromList(other.gen);
    state = .fromList(other.state);
    mark = .fromList(other.mark);
    version = .fromList(other.version);
    top = other.top;

    _freeIndices.clear();
    _freeIndices.addAll(other._freeIndices);
  }

  THandle handleFor(I index);
  I _wrapIndex(int i);
}

final class IdTable<I extends ElementIndex> {
  IdTable(this.kind);

  final String kind;

  final _slots = <CellId?>[];
  final _indexById = <CellId, I>{};

  void assign(I index, CellId id) {
    assert(!_indexById.containsKey(id), 'duplicate $kind id: $id');
    while (_slots.length <= index.i) _slots.add(null);
    _slots[index.i] = id;
    _indexById[id] = index;
  }

  void free(I index) {
    final id = _slots[index.i];
    if (id != null) _indexById.remove(id);
    _slots[index.i] = null;
  }

  CellId of(I index) => _slots[index.i]!;
  CellId? maybeOf(I index) => index.i < _slots.length ? _slots[index.i] : null;
  I? indexOf(CellId id) => _indexById[id];

  void copyFrom(IdTable<I> other) {
    _slots.clear();
    _slots.addAll(other._slots);
    _indexById.clear();
    _indexById.addAll(other._indexById);
  }
}
