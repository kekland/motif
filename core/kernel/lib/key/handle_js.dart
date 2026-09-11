
import 'package:kernel/kernel.dart';

const int _genBits = 20;
const int _indexBits = 30;
const int _kindBits = 2;

// ignore: unused_element
const int _genShift = _indexBits + _kindBits;
const int _indexShift = _kindBits;

const int _two32 = 0x100000000;

extension type const CellHandle._(int _v) implements Object {
  CellHandle.make(CellKind kind, ElementIndex index, int gen) : this._(_pack(kind.index, index.i, gen));
  CellHandle.assemble(CellIndex cellIndex, int gen) : this._(_join(cellIndex.value, gen));

  static int _join(int low, int gen) => gen * _two32 + low;

  static int _pack(int kind, int index, int gen) {
    assert(gen >= 0 && gen < (1 << _genBits));
    assert(index >= 0 && index < (1 << _indexBits));
    assert(kind >= 0 && kind < (1 << _kindBits));
    return gen * _two32 + index * (1 << _kindBits) + kind;
  }

  int get _low => _v % _two32;
  int get rawIndex => _low >>> _indexShift;
  ElementIndex get index => .new(rawIndex);
  CellIndex get cellIndex => .raw(_low);
  int get gen => _v ~/ _two32;
  CellKind get kind => .values[_low & ((1 << _kindBits) - 1)];
}
