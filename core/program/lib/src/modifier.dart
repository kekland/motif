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

final class ModifierStack {
  const ModifierStack([this._entries = const []]);
  const ModifierStack.empty() : this(const []);

  final List<Modifier> _entries;
  List<Modifier> get entries => _entries;

  int get length => _entries.length;
  bool get isEmpty => _entries.isEmpty;
  bool get isNotEmpty => _entries.isNotEmpty;

  ModifierStack sublist(int start, [int? end]) => .new(_entries.sublist(start, end));

  ModifierStack append(Modifier modifier) => .new([..._entries, modifier]);
  ModifierStack remove(int index) => .new([..._entries]..removeAt(index));

  ModifierStack update(int index, Modifier d) {
    final out = entries.toList();
    out[index] = d;
    return .new(out);
  }
}
