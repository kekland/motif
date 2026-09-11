import 'package:u64/u64.dart';

abstract final class Mix64 {
  static const _two32 = 0x100000000;

  static int _u32(int x) => x % _two32;

  static int _mul32(int a, int b) {
    final lo = (a % 0x10000) * b;
    final hi = (((a ~/ 0x10000) * b) % 0x10000) * 0x10000;
    return (lo + hi) % _two32;
  }

  static int _fmix32(int h) {
    h = _u32(h ^ (h >>> 16));
    h = _mul32(h, 0x85EBCA6B);
    h = _u32(h ^ (h >>> 13));
    h = _mul32(h, 0xC2B2AE35);
    return _u32(h ^ (h >>> 16));
  }

  static int hash32(int hi, int lo) => _fmix32(_u32(_u32(hi ^ lo) + 0x9E3779B9)) % 0x40000000;

  static U64 mix(U64 a, U64 b) {
    var lo = _fmix32(_u32(_u32(a.lo ^ b.lo) + 0x9E3779B9));
    final hi = _fmix32(_u32(_u32(a.hi ^ b.hi) + lo));
    lo = _fmix32(_u32(lo ^ hi));
    return .of(hi, lo);
  }

  static U64 mixWithKey(U64 a, int key) => mix(a, .of(key ~/ _two32, key % _two32));
  static int hash(U64 a) => hash32(a.hi, a.lo);
}
