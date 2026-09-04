part of '../program.dart';

final class Dissolve extends Statement {
  new(this.targets, {super.id, super.modifiers});

  final List<Selector<CellRef>> targets;

  @override
  Iterable<Selector> get selectors => targets;

  @override
  Iterable<Op> ops(EvalContext context) sync* {
    for (final t in targets) {
      final r = context.resolve(t);
      yield switch (r.kind) {
        .frame => DeleteFrameOp(r.asFrame),
        .vertex => DeleteVertexOp(r.asVertex),
        .edge => DeleteEdgeOp(r.asEdge),
        .face => DeleteFaceOp(r.asFace),
      };
    }
  }

  @override
  Dissolve copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    List<Selector<CellRef>>? targets,
  }) => .new(
    targets ?? this.targets,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
  );
}
