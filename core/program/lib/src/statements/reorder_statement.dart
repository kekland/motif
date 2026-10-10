part of '../_program.dart';

final class ReorderStatement extends Statement {
  new(
    CellSelector target, {
    required this.placement,
    this.rank,
    CellSelector? sibling,
    super.id,
    super.modifiers,
    super.name,
  }) : target = target.clone(),
       sibling = sibling?.clone() {
    selectors = [this.target, ?this.sibling];
  }

  ReorderStatement.fromAnchor(
    CellSelector target, {
    required ZAnchor anchor,
    StatementId? id,
    ModifierStack modifiers = const .empty(),
  }) : this(
         target,
         placement: anchor.placement,
         rank: anchor.rank,
         sibling: anchor.sibling?.selector(),
         id: id,
         modifiers: modifiers,
       );

  final CellSelector target;
  final ZPlacement placement;
  final int? rank;
  final CellSelector? sibling;

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    yield ReorderOp(
      cell: context.resolve(target),
      anchor: switch (placement) {
        .top => .top(rank!),
        .bottom => .bottom(rank!),
        .above => .above(context.resolve(sibling!)),
        .below => .below(context.resolve(sibling!)),
      },
    );
  }

  @override
  ReorderStatement copyWith({
    StatementId? id,
    ModifierStack? modifiers,
    String? name,
    CellSelector? target,
    int? rank,
    ZPlacement? placement,
    CellSelector? sibling,
  }) => .new(
    id: id ?? this.id,
    name: name ?? this.name,
    modifiers: modifiers ?? this.modifiers,
    target ?? this.target,
    placement: placement ?? this.placement,
    rank: rank ?? this.rank,
    sibling: sibling ?? this.sibling,
  );
}
