import 'package:u64/mix.dart';

final class U64 implements Comparable<U64> {
  U64.of(this.hi, this.lo) : hashCode = Mix64.hash32(hi, lo);
  static final zero = U64.of(0, 0);

  final int hi, lo;

  int get hash32 => hashCode;

  @override
  final int hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is U64 && hi == other.hi && lo == other.lo;

  @override
  int compareTo(U64 other) => hi != other.hi ? hi.compareTo(other.hi) : lo.compareTo(other.lo);

  @override
  String toString() => 'U64(${hi.toRadixString(16)}:${lo.toRadixString(16)})';
}
