part of '../kernel.dart';

const int _baseSize = storageBaseSize;

abstract class ArenaStorage<I extends ElementIndex, THandle, T extends ArenaStorage<I, THandle, T>> {
  var gen = Uint32List(_baseSize);
  var state = Uint8List(_baseSize);
  var mark = Uint32List(_baseSize);
  var version = Uint32List(_baseSize);
  var top = 0;
  var _liveCount = 0;
  final _freeIndices = <int>[];

  static const _free = 0, _live = 1, _ghost = 2;
  int get rowCount => top - _freeIndices.length;
  int get liveCount => _liveCount;

  final _observers = <ArenaObserver<I>>[];
  void observe(ArenaObserver<I> observer) => _observers.add(observer);

  void _notifyTouched(I i) {
    for (final o in _observers) o.onTouched(i);
  }

  void _notifyRetired(I i) {
    for (final o in _observers) o.onRetired(i);
  }

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
    _liveCount++;

    final index = _wrapIndex(i);
    _notifyTouched(index);
    return index;
  }

  void touch(I index) {
    assert(state[index.i] != _free, 'touching a free index $index');
    version[index.i]++;
    _notifyTouched(index);
  }

  void ghost(I index) {
    assert(state[index.i] == _live, 'ghosting a non-live index $index');
    state[index.i] = _ghost;
    _liveCount--;
    _notifyRetired(index);
  }

  void relink(I index) {
    assert(state[index.i] == _ghost, 'relinking a non-ghost index $index');
    state[index.i] = _live;
    _liveCount++;
    _notifyTouched(index);
  }

  void free(I index) {
    assert(state[index.i] != _free, 'double free index $index');
    state[index.i] = _free;
    gen[index.i]++;
    _freeIndices.add(index.i);
    _liveCount--;
    _notifyRetired(index);
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

final class IdTable<R extends CellRef, I extends ElementIndex> {
  IdTable(this.kind);

  final String kind;

  final _slots = <R?>[];
  final _indexOf = <R, I>{};

  void assign(I index, R ref) {
    assert(!_indexOf.containsKey(ref), 'duplicate $kind ref: $ref');
    while (_slots.length <= index.i) _slots.add(null);
    _slots[index.i] = ref;
    _indexOf[ref] = index;
  }

  void free(I index) {
    final id = _slots[index.i];
    if (id != null) _indexOf.remove(id);
    _slots[index.i] = null;
  }

  R of(I index) => _slots[index.i]!;
  R? maybeOf(I index) => index.i < _slots.length ? _slots[index.i] : null;
  I? indexOf(R ref) => _indexOf[ref];

  void copyFrom(IdTable<R, I> other) {
    _slots.clear();
    _slots.addAll(other._slots);
    _indexOf.clear();
    _indexOf.addAll(other._indexOf);
  }
}

abstract interface class ArenaObserver<I extends ElementIndex> {
  void onTouched(I index);
  void onRetired(I index);
}

final class CacheArenaObserver<I extends ElementIndex> implements ArenaObserver<I> {
  final _touched = HashSet<I>();
  final _retired = HashSet<I>();

  Set<I> get touched => _touched;
  Set<I> get retired => _retired;

  bool get isNotEmpty => _touched.isNotEmpty || _retired.isNotEmpty;
  bool get isEmpty => _touched.isEmpty && _retired.isEmpty;

  @override
  void onTouched(I index) => _touched.add(index);

  @override
  void onRetired(I index) => _retired.add(index);

  void clear() {
    _touched.clear();
    _retired.clear();
  }
}
