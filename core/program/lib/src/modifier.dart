part of '_program.dart';

/// A [Modifier] is a "factory" for creating statements that modify the execution of a base statement.
sealed class Modifier<B extends Statement> {
  Modifier({this.enabled = true});

  final bool enabled;
  ModifierKind get kind;

  ModifierEvalContext<B> createContext(Evaluation evaluation, StatementId id, FragmentSelector fragment) {
    return ModifierEvalContext<B>(
      evaluation,
      fragment,
      id,
    );
  }

  Statement produce(ModifierEvalContext<B> context);
}

enum ModifierKind {
  fillet(_faced);

  const ModifierKind(this.appliesTo);
  final bool Function(Statement) appliesTo;

  // static bool _any(Statement s) => true;
  static bool _faced(Statement s) => s is FacedStatement;
}
