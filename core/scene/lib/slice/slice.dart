part of '../scene.dart';

final class SceneSlice {
  new({
    required this.statements,
    required this.styleOverrides,
  });

  factory SceneSlice.decode(pb.SceneSlice slice) => SceneCodec.decodeSceneSlice(slice);

  static SceneSlice? decodeRaw(Uint8List data) {
    try {
      final slice = pb.SceneSlice.fromBuffer(data);
      return .decode(slice);
    } catch (e) {
      return null;
    }
  }

  factory SceneSlice.from(Scene scene, Iterable<StatementId> selection) {
    final targets = <StatementId>{};

    void visit(StatementId id) {
      if (!targets.add(id)) return;
      final statement = scene.program.byId(id);
      if (statement == null) return;

      final Set<Arg?> ignore = statement is FrameStatement ? {statement.parent} : const {};
      for (final arg in statement.args) {
        if (ignore.contains(arg)) continue;
        visit(arg.ref.statement);
      }
    }

    selection.forEach(visit);
    final overrides = scene.styleOverrides.slice(targets);
    final statements = scene.program.statements.where((s) => targets.contains(s.id)).toList();

    return .new(statements: statements, styleOverrides: overrides);
  }

  final List<Statement> statements;
  final StyleOverrides styleOverrides;

  SceneSlice remap() {
    final idMap = <StatementId, StatementId>{
      for (final s in statements) s.id: StatementId.generate(),
    };

    Ref remapRef(Ref ref) {
      final newId = idMap[ref.statement]!;
      return ref.copyWith(statement: newId);
    }

    final newStatements = statements.map((s) => s.copyWithRefs(remapRef, id: idMap[s.id]!)).toList();
    final newStyle = styleOverrides.remap(remapRef);

    return .new(
      statements: newStatements,
      styleOverrides: newStyle,
    );
  }
}
