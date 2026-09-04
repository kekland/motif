part of 'program.dart';

final class UnresolvedRef(final String reason) implements Exception {
  @override
  String toString() => 'UnresolvedRef: $reason';
}
