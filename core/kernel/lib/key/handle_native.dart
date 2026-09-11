import 'package:kernel/kernel.dart';

const int _genBits = 20;
const int _indexBits = 30;
const int _kindBits = 2;

const int _genShift = _indexBits + _kindBits;
const int _indexShift = _kindBits;

extension type const CellHandle._(int _v) implements Object {
  CellHandle.make(CellKind kind, ElementIndex index, int gen) : this._(_pack(kind.index, index.i, gen));
  CellHandle.assemble(CellIndex cellIndex, int gen) : this._(_join(cellIndex.value, gen));

  static int _join(int low, int gen) => (gen << _genShift) | low;

  static int _pack(int kind, int index, int gen) {
    assert(gen >= 0 && gen < (1 << _genBits));
    assert(index >= 0 && index < (1 << _indexBits));
    assert(kind >= 0 && kind < (1 << _kindBits));
    return (gen << _genShift) | (index << _indexShift) | kind;
  }

  int get rawIndex => (_v & ((1 << (_indexBits + _kindBits)) - 1)) >>> _indexShift;
  ElementIndex get index => .new(rawIndex);
  CellIndex get cellIndex => .raw(_v & ((1 << (_indexBits + _kindBits)) - 1));
  int get gen => (_v >>> _genShift);
  CellKind get kind => .values[_v & ((1 << _kindBits) - 1)];
}
