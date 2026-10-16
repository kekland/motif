part of '../_program.dart';

final class FragmentSelector extends Selector<Statement> {
  FragmentSelector(this._id, {this.modifierIndex}) : super([]);

  @override
  final SelectorKind kind = .fragment;

  StatementId _id;
  StatementId get id => _id;
  final int? modifierIndex;

  @override
  Statement _resolve(EvalContext context) {
    final s = context.evaluation.statement(id)!;
    if (modifierIndex == null) return s;
    return s.copyWith(modifiers: s.modifiers!.sublist(0, modifierIndex!));
  }

  @override
  Iterable<CellRef<CellHandle>> resolved(EvalContext context) sync* {
    final node = context.evaluation.tree[id]!;
    final added = node.commit?.added;
    if (added != null) yield* added;

    final children = node.children;
    for (final c in modifierIndex != null ? children.take(modifierIndex!) : children) {
      yield* context.productsOf(c.id);
    }
  }

  @override
  Iterable<CellRef<CellHandle>> get refs => const [];

  @override
  Set<StatementId> get dependencies => {id};

  @override
  RemapResult _remap(Remap remap) {
    final renamed = remap.statement(id);
    if (renamed == null) return .unchanged;
    _id = renamed;
    return .changed;
  }

  @override
  FragmentSelector clone() => .new(id, modifierIndex: modifierIndex);

  @override
  int get hashCode => Object.hash(kind, id, modifierIndex);

  @override
  bool operator ==(Object other) {
    if (other is! FragmentSelector) return false;
    if (other.kind != kind) return false;
    if (other.id != id) return false;
    if (other.modifierIndex != modifierIndex) return false;
    return true;
  }
}
