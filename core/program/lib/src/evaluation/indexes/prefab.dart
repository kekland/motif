part of '../../_program.dart';

/// A [PrefabIndex] keeps track of all currently active prefabs.
final class PrefabIndex extends PrefabIndexBase {
  PrefabIndex(this.evaluation) : super();

  final Evaluation evaluation;
  Program get program => evaluation.program;

  @override
  Statement? statement(StatementId id) => program.statement(id);

  @override
  Iterable<Statement> get statements => program.statements;

  PrefabInstanceStatement? instanceOf(StatementId id) {
    final node = evaluation.tree[id];
    if (node == null) return null;

    var current = node.parent;
    while (current != null) {
      final statement = current.statement;
      if (statement is PrefabInstanceStatement) return statement;
      current = current.parent;
    }
    return null;
  }
}

final class SlicePrefabIndex extends PrefabIndexBase {
  new({required this.slice});
  final ProgramSlice slice;

  @override
  Statement? statement(StatementId id) => slice.statements.firstWhereOrNull((s) => s.id == id);

  @override
  Iterable<Statement> get statements => slice.statements;
}

extension type const PrefabId(StatementId value) implements StatementId;

abstract class PrefabIndexBase {
  PrefabIndexBase() {
    _build();
  }

  Statement? statement(StatementId id);
  Iterable<Statement> get statements;

  final _prefabs = <PrefabId, ProgramSlice>{};
  final _prefabChildren = <PrefabId, List<StatementId>>{};
  final _instances = <PrefabId, List<StatementId>>{};

  Iterable<PrefabId> get origins => _prefabs.keys;

  PrefabOriginStatement? originOf(StatementId id) {
    final stmt = statement(id);
    if (stmt == null) return null;

    if (stmt is! PlacedStatement) {
      for (final sel in stmt.selectors) {
        for (final ref in sel.refs) {
          final origin = originOf(ref.statementId);
          if (origin != null) return origin;
        }
      }

      return null;
    }

    for (Statement? s = stmt; s != null; s = _parentOf(s)) {
      if (s is PrefabOriginStatement) return s;
    }

    return null;
  }

  Statement? _parentOf(Statement s) => switch (s) {
    PlacedStatement(:final parent?) => statement(parent.ref.statementId),
    _ => null,
  };

  ProgramSlice sliceOf(PrefabId origin) => _prefabs[origin]!;
  Iterable<StatementId> instancesOf(PrefabId origin) {
    return _instances[origin] ?? const [];
  }

  /// Returns the prefabs used by the given statement.
  Iterable<StatementId> prefabsIn(StatementId id) {
    final s = statement(id);

    if (s is PrefabOriginStatement) return {s.id, ...childrenOf(s.id)};
    if (s is PrefabInstanceStatement) return {s.prefabId, ...childrenOf(s.prefabId)};

    return const [];
  }

  Iterable<StatementId> childrenOf(PrefabId origin) {
    return _prefabChildren[origin] ?? const [];
  }

  void _build() {
    _prefabs.clear();
    _instances.clear();

    for (final s in statements) {
      if (s is PrefabOriginStatement) {
        assert(!_prefabs.containsKey(s.id));
        _prefabs[s.id] = .new(statements: [s]);
        _prefabChildren[s.id] = [];
        continue;
      }

      final parentOrigin = originOf(s.id);
      if (parentOrigin != null) {
        _prefabs[parentOrigin.id]!.statements.add(s);
      }

      if (s is PrefabInstanceStatement) {
        final originId = s.prefabId;
        _instances.putIfAbsent(originId, () => []).add(s.id);

        if (parentOrigin != null) {
          _prefabChildren[parentOrigin.id]!.add(s.id);
        }
      }
    }
  }
}
