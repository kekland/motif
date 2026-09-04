part of 'program.dart';

final class EvalFailure(
  final StatementId statement,
  final Scope? scope,
  final Object error,
  final StackTrace stackTrace,
) implements Exception {
  @override
  String toString() => 'EvalFailure(statement: $statement, scope: $scope, error: $error, stackTrace: $stackTrace)';
}

final class UnresolvedRef implements Exception {
  UnresolvedRef(this.ref);
  final Ref ref;

  @override
  String toString() => 'unresolved ref ${ref.statement.value}/${ref.product.value}';
}

final class ConsumedRef implements Exception {
  ConsumedRef(this.ref);
  final Ref ref;

  @override
  String toString() => 'consumed ref ${ref.statement.value}/${ref.product.value}';
}

final class AmbiguousRef implements Exception {
  AmbiguousRef(this.ref);
  final Ref ref;

  @override
  String toString() => 'ambiguous ref ${ref.statement.value}/${ref.product.value}';
}

final class StaleCell implements Exception {
  StaleCell(this.key);
  final CellKey key;

  @override
  String toString() => 'stale cell $key';
}
