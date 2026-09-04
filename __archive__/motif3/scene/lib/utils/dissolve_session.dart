part of '../scene.dart';

final class DissolveSession {
  DissolveSession._(this.router);

  factory DissolveSession.of(
    Scene scene, {
    Iterable<StatementId> statements = const [],
    Iterable<Ref> refs = const [],
  }) {
    final router = scene.program.resolveDissolveRouter(scene._evaluation!, statements: statements, refs: refs);
    return DissolveSession._(router);
  }

  final DissolveRouter router;

  bool get isEmpty => router.isEmpty;
  Set<StatementId> get removed => router.removed;
  Map<StatementId, List<Statement>> get replaced => router.replaced;
  Map<Ref, Ref> get refMap => router.refMap;

  void apply(SceneTransaction transaction) {
    if (isEmpty) return;

    Ref remap(Ref ref) => refMap[ref] ?? ref;

    final statements = transaction.program.statements.toList();
    for (final statement in statements.reversed.toList()) {
      final id = statement.id;

      if (removed.contains(id)) {
        transaction.remove(id);
      } else if (replaced.containsKey(id)) {
        final newStatements = replaced[id]!;
        transaction.replace(id, newStatements);
      } else if (refMap.isNotEmpty) {
        final newStatement = statement.copyWithRefs(remap);
        if (newStatement != statement) transaction.replace(id, [newStatement]);
      }
    }
  }
}
