final class Forbidden implements Exception {
  const Forbidden();

  @override
  String toString() => 'Forbidden';
}

final class NotFound implements Exception {
  const NotFound([this.id]);
  final String? id;

  @override
  String toString() => 'Not found: $id';
}
