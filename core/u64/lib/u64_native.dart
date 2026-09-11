import 'package:u64/u64.dart';

extension type const U64._(int value) implements Object {
  const U64.of(int hi, int lo) : this._((hi << 32) | lo);
  static const zero = U64._(0);

  int get hi => value >>> 32;
  int get lo => value & 0xFFFFFFFF;

  int get hash32 => Mix64.hash32(hi, lo);
  int compareTo(U64 other) => value.compareTo(other.value);
}
