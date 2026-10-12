part of '_program.dart';

final class ProgramSlice {
  new({required this.statements});
  ProgramSlice.empty() : statements = [];

  factory ProgramSlice.decode(gen.ProgramSlice program) => ProgramCodec.decodeProgramSlice(program);
  static ProgramSlice? decodeRaw(Uint8List data) => codec.decodeRaw(() => .decode(.fromBuffer(data)));

  factory ProgramSlice.merged(Iterable<ProgramSlice> slices, {int Function(StatementId)? indexOf}) {
    final seen = <StatementId>{};
    final statements = <Statement>[];
    for (final s in slices) {
      for (final statement in s.statements) {
        if (seen.add(statement.id)) {
          statements.add(statement);
        }
      }
    }

    if (indexOf != null) {
      statements.sort((a, b) => indexOf(a.id).compareTo(indexOf(b.id)));
    }

    return .new(statements: statements);
  }

  final List<Statement> statements;
  int get length => statements.length;

  ProgramSlice transform(Statement Function(int, Statement) transformer) {
    final transformed = <Statement>[];
    for (var i = 0; i < statements.length; i++) transformed.add(transformer(i, statements[i]));
    return ProgramSlice(statements: transformed);
  }

  ProgramSlice materialize(StatementId Function(int, Statement) idOf) {
    final idMap = <StatementId, StatementId>{};
    for (var i = 0; i < statements.length; i++) {
      final s = statements[i];
      final id = idOf(i, s);
      idMap[s.id] = id;
    }

    final remap = Remap.statements(idMap);
    final prefabs = SlicePrefabIndex(slice: this);
    final output = <Statement>[];

    for (final s in statements) {
      if (s is PrefabOriginStatement) {
        final instance = PrefabInstanceStatement.fromOrigin(s, id: idMap[s.id]);
        output.add(instance.remap(remap));
      } else if (prefabs.originOf(s.id) == null) {
        output.add(s.remap(remap));
      }
    }

    return ProgramSlice(statements: output);
  }

  (Remap, ProgramSlice) materializeRaw(StatementId Function(int, Statement) idOf) {
    final idMap = <StatementId, StatementId>{};
    for (var i = 0; i < statements.length; i++) {
      final s = statements[i];
      final id = idOf(i, s);
      idMap[s.id] = id;
    }

    final remap = Remap.statements(idMap);
    return (
      remap,
      .new(statements: statements.map((s) => s.remap(remap)).toList()),
    );
  }

  ProgramSlice extend(ProgramSlice other) => .new(statements: [...statements, ...other.statements]);

  Statement operator [](StatementId id) => statements.firstWhere((s) => s.id == id);
  void operator []=(StatementId id, Statement statement) {
    final index = statements.indexWhere((s) => s.id == id);
    if (index == -1) throw ArgumentError('Statement with id $id not found');
    statements[index] = statement;
  }

  ProgramSlice clone() => .new(statements: statements.toList());
}
