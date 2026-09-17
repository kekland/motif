import 'package:editor/imports.dart';

enum Modifier { generator, filletFace }

final class ModifierFactory {
  const ModifierFactory({
    required this.type,
    required this.statement,
    required this.apply,
  });

  factory ModifierFactory.merged(List<Statement> s, List<ModifierFactory> factories) {
    assert(factories.every((f) => f.type == factories.first.type));

    if (factories.first.type == .generator) {
      return ModifierFactory(
        type: .generator,
        statement: null,
        apply: (txn) {
          final ids = factories.map((f) => f.statement!.id).toList();
          txn.attachAfter(
            ids,
            GeneratorStatement(selectors: ids.map((id) => FragmentSelector(id)).toList(), generator: .empty()),
          );
        },
      );
    }

    return ModifierFactory(
      type: factories.first.type,
      statement: null,
      apply: (txn) {
        for (final f in factories) f.apply(txn);
      },
    );
  }

  static ModifierFactory generator(Statement s) => ModifierFactory(
    statement: s,
    type: .generator,
    apply: (txn) => txn.attach(s.id, GeneratorStatement(selectors: [.new(s.id)], generator: .empty())),
  );

  static ModifierFactory filletFace(Statement s, FaceRef face) => ModifierFactory(
    statement: s,
    type: .filletFace,
    apply: (txn) => txn.attach(s.id, FilletFaceStatement(face.selector(), radius: .new(16.0, 16.0))),
  );

  final Modifier type;
  final Statement? statement;
  final void Function(SceneTransaction) apply;
}

extension StatementModifiers on Evaluation {
  List<ModifierFactory> _possibleModifiersFor(Statement s) => switch (s) {
    ShapeStatement s => [
      .filletFace(s, s.face),
      .generator(s),
    ],
    _ => [
      .generator(s),
    ],
  };

  List<ModifierFactory> possibleModifiersFor(List<Statement> statements) {
    final factories = statements.map(_possibleModifiersFor).expand((e) => e).toList();
    final factoriesByType = <Modifier, List<ModifierFactory>>{};
    for (final f in factories) {
      factoriesByType[f.type] ??= [];
      factoriesByType[f.type]!.add(f);
    }

    final merged = <Modifier, ModifierFactory>{};
    for (final entry in factoriesByType.entries) {
      if (entry.value.length != statements.length) continue;
      merged[entry.key] = ModifierFactory.merged(statements, entry.value);
    }

    return factories;
  }
}
