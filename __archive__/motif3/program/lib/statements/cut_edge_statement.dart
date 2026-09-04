part of '../program.dart';

final class CutEdgeStatement extends Statement {
  new(
    EdgeSelector edge, {
    super.id,
    super.modifiers,
    required this.t,
  }) : edge = edge.copyWith();

  final EdgeSelector edge;
  final double t;

  @override
  Iterable<Selector> get selectors => [edge];

  @override
  void performExecute(EvalContext context) {
    context.transaction.cutEdge(edge.resolve(context), t);
  }

  @override
  CutEdgeStatement copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    EdgeSelector? edge,
    double? t,
  }) => .new(
    edge ?? this.edge,
    t: t ?? this.t,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
  );
}
