part of '../kernel.dart';

abstract final class Mix {
  static const _two32 = 0x100000000;
  static const _two20 = 0x100000;

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

  static int mix(int a, int b) {
    final lo = _fmix32(_u32(_u32(a % _two32) ^ _u32(b % _two32)) + 0x9E3779B9);
    final hi = _fmix32(_u32(_u32(a ~/ _two32) ^ _u32(b ~/ _two32)) + lo);
    return (hi % _two20) * _two32 + lo;
  }
}
