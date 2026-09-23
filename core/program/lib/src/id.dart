part of '_program.dart';

/// A unique identifier for a statement within the program.
extension type const StatementId.raw(U64 value) implements Object {
  static StatementId allocate() => .raw(.of(0, _seq++));
  static int _seq = 1;

  static const _derivedBit = 0x80000000;

  /// Identifier that is produced from this statement under the given key.
  StatementId derive(U64 key) {
    final m = Mix64.mix(value, key);
    return .raw(.of(m.hi | _derivedBit, m.lo));
  }

  bool get isDerived => (value.hi & _derivedBit) != 0;

  /// Namespace of a cell that would be produced from this statement.
  U64 get namespace => value;

  /// A cell that would be produced from this statement. Used for eager bindings.
  CellRef<H> cell<H extends CellHandle>(
    CellKind kind,
    int op, [
    int sub = 0,
  ]) => .make(namespace: namespace, op: op, sub: sub, kind: kind);
}

extension StatementIdCellRefExt on CellRef {
  /// Statement identifier that produced this cell.
  StatementId get statementId => .raw(namespace);
}

extension StatementIdRefExt on Ref {
  StatementId get statementId => switch (this) {
    CellRef r => .raw(r.namespace),
    CovertexRef r => .raw(r.edge.namespace),
  };

  CellRef get cell => switch (this) {
    CellRef r => r,
    CovertexRef r => r.edge,
  };
}

// final class StatementIdAllocator {
//   StatementIdAllocator();
//   int _seq = 1;

//   StatementId allocate() => .raw(.of(0, _seq++));
// }
