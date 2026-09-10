part of '../program.dart';

final class GeneratedIndex {
  final _generatorOf = <StatementId, (StatementId, Object?)>{};

  StatementId derive(StatementId generator, int key, {Object? origin}) {
    final id = StatementId.derived(generator, key);
    _generatorOf[id] = (generator, origin);
    return id;
  }

  StatementId? generatorOf(StatementId id) => _generatorOf[id]?.$1;
  Object? originOf(StatementId id) => _generatorOf[id]?.$2;

  StatementId rootOf(StatementId id) {
    var r = id;
    for (var g = _generatorOf[r]; g != null; g = _generatorOf[r]) r = g.$1;
    return r;
  }

  bool generatedBy(StatementId id, StatementId generator) {
    for (var g = _generatorOf[id]; g != null; g = _generatorOf[g.$1]) {
      if (g.$1 == generator) return true;
    }
    return false;
  }
}
